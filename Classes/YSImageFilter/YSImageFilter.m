//
//  YSImageFilter.m
//  TestUIImageFiliters
//
//  Created by Yu Sugawara on 2014/03/26.
//  Copyright (c) 2014年 Yu Sugawara. All rights reserved.
//

#import "YSImageFilter.h"
@import CoreImage;

#if DEBUG
    #if 0
        #define LOG_YSIMAGE_FILTER(...) NSLog(__VA_ARGS__)
    #endif
#endif

#ifndef LOG_YSIMAGE_FILTER
    #define LOG_YSIMAGE_FILTER(...)
#endif

static inline CGFLOAT_TYPE CGFloat_round(CGFLOAT_TYPE cgfloat) {
#if defined(__LP64__) && __LP64__
    return round(cgfloat);
#else
    return roundf(cgfloat);
#endif
}

static inline CIContext *contextUsedGPU()
{
    static CIContext *s_context;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        s_context = [CIContext contextWithOptions:@{kCIContextUseSoftwareRenderer : @NO}];
    });
    return s_context;
}

static inline CIContext *contextUsedCPU()
{
    static CIContext *s_context;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        s_context = [CIContext contextWithOptions:nil];
    });
    return s_context;
}

static inline UIImage *imageFromCIImage(CIImage *ciImage, CGFloat imageScale, BOOL useGPU)
{
    CIContext *context = useGPU ? contextUsedGPU() : contextUsedCPU();
    CGImageRef imageRef = [context createCGImage:ciImage fromRect:ciImage.extent];
    UIImage *image  = [UIImage imageWithCGImage:imageRef scale:imageScale orientation:UIImageOrientationUp];
    CGImageRelease(imageRef);
    return image;
}

@implementation YSImageFilter

#pragma mark - resize

+ (UIImage*)resizeWithImage:(UIImage*)image
                       size:(CGSize)targetSize
                  trimToFit:(BOOL)trimToFit
{
    return [self resizeWithImage:image size:targetSize useGPU:YES trimToFit:trimToFit];
}

+ (UIImage*)resizeWithImage:(UIImage*)image
                       size:(CGSize)targetSize
                     useGPU:(BOOL)useGPU
                  trimToFit:(BOOL)trimToFit
{
    CIImage *ciImage = [[CIImage alloc] initWithCGImage:image.CGImage];
    CGSize imageSize = ciImage.extent.size;
    if (imageSize.height < 1 || imageSize.width < 1 ||
        targetSize.height < 1 || targetSize.width < 1) {
        NSLog(@"Error: %s", __func__);
        return nil;
    }
    
    CGFloat imageScale = image.scale;
    CGFloat aspectRatio = imageSize.width / imageSize.height;
    CGFloat targetAspectRatio = targetSize.width / targetSize.height;
    CGRect projectTo = CGRectZero;
    CGSize newSize;
    CIImage *resizedCiImage;
    LOG_YSIMAGE_FILTER(@"imageSize: %@\nimageScale: %f\ntargetSize: %@\naspectRatio: %f\ntargetAspectRatio: %f", NSStringFromCGSize(imageSize), imageScale, NSStringFromCGSize(targetSize), aspectRatio, targetAspectRatio);
    if (trimToFit) {
        CGFloat ratio;
  
        if (targetAspectRatio < aspectRatio) {
            LOG_YSIMAGE_FILTER(@"clip the x-axis");
            ratio = imageSize.height / targetSize.height;
        } else {
            LOG_YSIMAGE_FILTER(@"clip the y-axis");
            ratio = imageSize.width / targetSize.width;
        }
        newSize = CGSizeMake(targetSize.width * ratio,
                             targetSize.height * ratio);
        
        LOG_YSIMAGE_FILTER(@"ratio: %f, newSize: %@", ratio, NSStringFromCGSize(newSize));
        newSize = CGRectIntegral(CGRectMake(0.f, 0.f, newSize.width, newSize.height)).size;
        
        projectTo = CGRectMake(imageSize.width/2.f - newSize.width/2.f,
                               imageSize.height/2.f - newSize.height/2.f,
                               newSize.width,
                               newSize.height);
        
        LOG_YSIMAGE_FILTER(@"before CGRectIntegral(projectTo) %@", NSStringFromCGRect(projectTo));
        projectTo = CGRectIntegral(projectTo);
        LOG_YSIMAGE_FILTER(@"after CGRectIntegral(projectTo) %@", NSStringFromCGRect(projectTo));
        resizedCiImage = [ciImage imageByCroppingToRect:projectTo];
        LOG_YSIMAGE_FILTER(@"croped center ciImage %@", NSStringFromCGRect(resizedCiImage.extent));
        resizedCiImage = [resizedCiImage imageByApplyingTransform:CGAffineTransformMakeScale((1.f / ratio) * imageScale,
                                                                                             (1.f / ratio) * imageScale)];
        LOG_YSIMAGE_FILTER(@"resized ciImage  %@", NSStringFromCGRect(resizedCiImage.extent));
    } else {
        if (targetAspectRatio < aspectRatio) {
            LOG_YSIMAGE_FILTER(@"clip the x-axis");
            newSize = CGSizeMake(targetSize.width * imageScale,
                                 targetSize.width / aspectRatio * imageScale);
        } else {
            LOG_YSIMAGE_FILTER(@"clip the y-axis");
            newSize = CGSizeMake(targetSize.height * aspectRatio * imageScale,
                                 targetSize.height * imageScale);
        }
        LOG_YSIMAGE_FILTER(@"before CGRectIntegral(newsize) %@", NSStringFromCGSize(newSize));
        CGRect integralRect = CGRectZero;
        integralRect.size = newSize;
        newSize = CGRectIntegral(integralRect).size;
        LOG_YSIMAGE_FILTER(@"after CGRectIntegral(newsize) %@", NSStringFromCGSize(newSize));
        LOG_YSIMAGE_FILTER(@"newSize: %@", NSStringFromCGSize(newSize));
        CGPoint scale = CGPointMake(newSize.width/imageSize.width,
                                    newSize.height/imageSize.height);
        LOG_YSIMAGE_FILTER(@"resize scale %@", NSStringFromCGPoint(scale));
        resizedCiImage = [ciImage imageByApplyingTransform:CGAffineTransformMakeScale(scale.x, scale.y)];
        LOG_YSIMAGE_FILTER(@"resized ciImage %@", NSStringFromCGRect(resizedCiImage.extent));
    }
    CGRect cropRect = resizedCiImage.extent;
    cropRect = CGRectMake(CGFloat_round(cropRect.origin.x),
                          CGFloat_round(cropRect.origin.y),
                          CGFloat_round(cropRect.size.width),
                          CGFloat_round(cropRect.size.height));
    LOG_YSIMAGE_FILTER(@"crop rect %@", NSStringFromCGRect(cropRect));
    resizedCiImage = [resizedCiImage imageByCroppingToRect:cropRect];
    LOG_YSIMAGE_FILTER(@"croped ciImage %@", NSStringFromCGRect(resizedCiImage.extent));
    
    UIImage *resizedImage = imageFromCIImage(resizedCiImage, imageScale, useGPU);
    LOG_YSIMAGE_FILTER(@"resizedImage %@", NSStringFromCGSize(resizedImage.size));
    return resizedImage;
}

#pragma mark - Sepia

+ (UIImage *)sepiaWithImage:(UIImage *)image intensity:(CGFloat)intensity useGPU:(BOOL)useGPU
{
    CIImage *ciImage = [[CIImage alloc] initWithCGImage:image.CGImage];
    CIFilter *filter = [CIFilter filterWithName:@"CISepiaTone"
                                  keysAndValues:kCIInputImageKey, ciImage, @"inputIntensity", @(intensity), nil];
    CIImage *filterdImage = [filter outputImage];
    return imageFromCIImage(filterdImage, image.scale, useGPU);
}

@end
