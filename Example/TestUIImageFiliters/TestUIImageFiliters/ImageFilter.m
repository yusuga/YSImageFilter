//
//  ImageFilter.m
//  TestUIImageFiliters
//
//  Created by Yu Sugawara on 2014/03/26.
//  Copyright (c) 2014年 Yu Sugawara. All rights reserved.
//

#import "ImageFilter.h"
#import <NYXImagesKit/NYXImagesKit.h>
#import <GPUImage/GPUImage.h>

#if DEBUG
    #if 0
        #define LOG_IMAGE_FILTER(...) NSLog(__VA_ARGS__)
    #endif
#endif

#ifndef LOG_IMAGE_FILTER
    #define LOG_IMAGE_FILTER(...)
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

@implementation ImageFilter

+ (UIImage*)resizeInNYXImagesKitWithImage:(UIImage*)image
                                     size:(CGSize)targetSize
                                trimToFit:(BOOL)trimToFit
{
    UIImage *resizedImage;
    if (trimToFit) {
        CGSize imageSize = image.size;
        CGFloat aspectRatio = imageSize.width / imageSize.height;
        CGFloat targetAspectRatio = targetSize.width / targetSize.height;
        CGFloat ratio;
        if (targetAspectRatio < aspectRatio) {
            ratio = imageSize.height/targetSize.height;
        } else {
            ratio = imageSize.width/targetSize.width;
        }
        CGSize newSize = CGSizeMake(targetSize.width*ratio,
                                    targetSize.height*ratio);
        newSize = CGRectIntegral(CGRectMake(0.f, 0.f, newSize.width, newSize.height)).size;
        
        UIImage *cropImage = [image cropToSize:newSize
                                     usingMode:NYXCropModeCenter];
        resizedImage = [cropImage scaleToFitSize:targetSize];
    } else {
        resizedImage = [image scaleToFitSize:targetSize];
    }
    LOG_IMAGE_FILTER(@"resizedImage: %@", NSStringFromCGSize(resizedImage.size));
    return resizedImage;
}

+ (UIImage*)resizeInCoreImageWithImage:(UIImage*)image
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
    LOG_IMAGE_FILTER(@"imageSize: %@\nimageScale: %f\ntargetSize: %@\naspectRatio: %f\ntargetAspectRatio: %f", NSStringFromCGSize(imageSize), imageScale, NSStringFromCGSize(targetSize), aspectRatio, targetAspectRatio);
    if (trimToFit) {
        CGFloat ratio;
        
        if (targetAspectRatio < aspectRatio) {
            LOG_IMAGE_FILTER(@"clip the x-axis");
            ratio = imageSize.height / targetSize.height;
        } else {
            LOG_IMAGE_FILTER(@"clip the y-axis");
            ratio = imageSize.width / targetSize.width;
        }
        newSize = CGSizeMake(targetSize.width * ratio,
                             targetSize.height * ratio);
        
        LOG_IMAGE_FILTER(@"ratio: %f, newSize: %@", ratio, NSStringFromCGSize(newSize));
        newSize = CGRectIntegral(CGRectMake(0.f, 0.f, newSize.width, newSize.height)).size;
        
        projectTo = CGRectMake(imageSize.width/2.f - newSize.width/2.f,
                               imageSize.height/2.f - newSize.height/2.f,
                               newSize.width,
                               newSize.height);
        
        LOG_IMAGE_FILTER(@"before CGRectIntegral(projectTo) %@", NSStringFromCGRect(projectTo));
        projectTo = CGRectIntegral(projectTo);
        LOG_IMAGE_FILTER(@"after CGRectIntegral(projectTo) %@", NSStringFromCGRect(projectTo));
        resizedCiImage = [ciImage imageByCroppingToRect:projectTo];
        LOG_IMAGE_FILTER(@"croped center ciImage %@", NSStringFromCGRect(resizedCiImage.extent));
        resizedCiImage = [resizedCiImage imageByApplyingTransform:CGAffineTransformMakeScale((1.f / ratio) * imageScale,
                                                                                             (1.f / ratio) * imageScale)];
        LOG_IMAGE_FILTER(@"resized ciImage  %@", NSStringFromCGRect(resizedCiImage.extent));
    } else {
        if (targetAspectRatio < aspectRatio) {
            LOG_IMAGE_FILTER(@"clip the x-axis");
            newSize = CGSizeMake(targetSize.width * imageScale,
                                 targetSize.width / aspectRatio * imageScale);
        } else {
            LOG_IMAGE_FILTER(@"clip the y-axis");
            newSize = CGSizeMake(targetSize.height * aspectRatio * imageScale,
                                 targetSize.height * imageScale);
        }
        LOG_IMAGE_FILTER(@"before CGRectIntegral(newsize) %@", NSStringFromCGSize(newSize));
        CGRect integralRect = CGRectZero;
        integralRect.size = newSize;
        newSize = CGRectIntegral(integralRect).size;
        LOG_IMAGE_FILTER(@"after CGRectIntegral(newsize) %@", NSStringFromCGSize(newSize));
        LOG_IMAGE_FILTER(@"newSize: %@", NSStringFromCGSize(newSize));
        CGPoint scale = CGPointMake(newSize.width/imageSize.width,
                                    newSize.height/imageSize.height);
        LOG_IMAGE_FILTER(@"resize scale %@", NSStringFromCGPoint(scale));
        resizedCiImage = [ciImage imageByApplyingTransform:CGAffineTransformMakeScale(scale.x, scale.y)];
        LOG_IMAGE_FILTER(@"resized ciImage %@", NSStringFromCGRect(resizedCiImage.extent));
    }
    CGRect cropRect = resizedCiImage.extent;
    cropRect = CGRectMake(CGFloat_round(cropRect.origin.x),
                          CGFloat_round(cropRect.origin.y),
                          CGFloat_round(cropRect.size.width),
                          CGFloat_round(cropRect.size.height));
    LOG_IMAGE_FILTER(@"crop rect %@", NSStringFromCGRect(cropRect));
    resizedCiImage = [resizedCiImage imageByCroppingToRect:cropRect];
    LOG_IMAGE_FILTER(@"croped ciImage %@", NSStringFromCGRect(resizedCiImage.extent));
    
    UIImage *resizedImage = imageFromCIImage(resizedCiImage, imageScale, useGPU);
    LOG_IMAGE_FILTER(@"resizedImage %@", NSStringFromCGSize(resizedImage.size));
    return resizedImage;
}

+ (UIImage*)resizeInGPUImageWithImage:(UIImage*)image
                                 size:(CGSize)targetSize
                            trimToFit:(BOOL)trimToFit
{
    GPUImagePicture *stillImageSource = [[GPUImagePicture alloc] initWithImage:image];
    GPUImageFilterGroup *filterGroup = [[GPUImageFilterGroup alloc] init];
    GPUImageFilter *resizeFilter = [[GPUImageFilter alloc] init];
    if (trimToFit) {
        CGSize imageSize = image.size;
        CGFloat aspectRatio = imageSize.width / imageSize.height;
        CGFloat targetAspectRatio = targetSize.width / targetSize.height;
        CGRect cropRect = CGRectZero;
        CGSize cropSize;
        CGFloat ratio;
        
        if (targetAspectRatio < aspectRatio) {
            ratio = imageSize.height/targetSize.height;
        } else {
            ratio = imageSize.width/targetSize.width;
        }
        cropSize = CGSizeMake(targetSize.width*ratio,
                              targetSize.height*ratio);
        
        cropSize = CGRectIntegral(CGRectMake(0.f, 0.f, cropSize.width, cropSize.height)).size;
        
        cropRect = CGRectMake(imageSize.width/2.f - cropSize.width/2.f,
                              imageSize.height/2.f - cropSize.height/2.f,
                              cropSize.width,
                              cropSize.height);
        cropRect = CGRectIntegral(cropRect);

        cropRect = CGRectMake(cropRect.origin.x/imageSize.width,
                              cropRect.origin.y/imageSize.height,
                              cropRect.size.width/imageSize.width,
                              cropRect.size.height/imageSize.height);

        GPUImageCropFilter *cropFilter = [[GPUImageCropFilter alloc] initWithCropRegion:cropRect];
        [filterGroup addTarget:cropFilter];
        
        [resizeFilter forceProcessingAtSize:targetSize];
        [filterGroup addTarget:resizeFilter];
        
        [filterGroup setInitialFilters:@[cropFilter]];
        [filterGroup setTerminalFilter:resizeFilter];
        
        [cropFilter addTarget:resizeFilter];
    } else {
        [resizeFilter forceProcessingAtSizeRespectingAspectRatio:targetSize];
        [filterGroup setInitialFilters:@[resizeFilter]];
        [filterGroup setTerminalFilter:resizeFilter];
    }
    
    [stillImageSource addTarget:filterGroup];
    [filterGroup useNextFrameForImageCapture];
    [stillImageSource processImage];
    
    UIImage *resizedImage = [filterGroup imageFromCurrentFramebuffer];
    LOG_IMAGE_FILTER(@"resizedImage: %@", NSStringFromCGSize(resizedImage.size));
    return resizedImage;
}

#pragma mark - sepia

+ (UIImage *)sepiaInCoreImageWithImage:(UIImage *)image intensity:(CGFloat)intensity useGPU:(BOOL)useGPU
{
    CIImage *ciImage = [[CIImage alloc] initWithCGImage:image.CGImage];
    CIFilter *filter = [CIFilter filterWithName:@"CISepiaTone"
                                  keysAndValues:kCIInputImageKey, ciImage, @"inputIntensity", @(intensity), nil];
    CIImage *filteredImage = [filter outputImage];
    return imageFromCIImage(filteredImage, image.scale, useGPU);
}

+ (UIImage *)sepiaInNYXImagesKitWithImage:(UIImage *)image
{
    return image.sepia;
}

+ (UIImage *)sepiaInGPUImageWithImage:(UIImage *)image
{
    GPUImagePicture *stillImageSource = [[GPUImagePicture alloc] initWithImage:image];
    GPUImageSepiaFilter *filter = [[GPUImageSepiaFilter alloc] init];
    [stillImageSource addTarget:filter];
    [filter useNextFrameForImageCapture];
    [stillImageSource processImage];
    UIImage *filteredImage = [filter imageFromCurrentFramebuffer];
    LOG_IMAGE_FILTER(@"sepiaImage: %@", NSStringFromCGSize(filteredImage.size));
    return filteredImage;
}

@end
