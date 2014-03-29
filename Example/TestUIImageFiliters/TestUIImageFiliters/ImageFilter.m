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

@implementation ImageFilter

+ (UIImage*)resizeInCoreGraphicsWithImage:(UIImage*)image
                                     size:(CGSize)targetSize
                              quality:(CGInterpolationQuality)quality
                                trimToFit:(BOOL)trimToFit
{
    CGSize sourceImgSize = image.size;
    LOG_IMAGE_FILTER(@"sourceImage.size: %@", NSStringFromCGSize(sourceImgSize));
    if (sourceImgSize.height < 1 || sourceImgSize.width < 1 ||
        targetSize.height < 1 || targetSize.width < 1) {
        return nil;
    }

    CGFloat aspectRatio = sourceImgSize.width / sourceImgSize.height;
    CGFloat targetAspectRatio = targetSize.width / targetSize.height;
    CGRect projectTo = CGRectZero;
    CGSize newSize = targetSize;
    if (trimToFit) {
        // Scale and clip image so that the aspect ratio is preserved and the
        // target size is filled.
        if (targetAspectRatio < aspectRatio) {
            // clip the x-axis.
            projectTo.size.width = targetSize.height * aspectRatio;
            projectTo.size.height = targetSize.height;
            projectTo.origin.x = (targetSize.width - projectTo.size.width) / 2;
            projectTo.origin.y = 0;
        } else {
            // clip the y-axis.
            projectTo.size.width = targetSize.width;
            projectTo.size.height = targetSize.width / aspectRatio;
            projectTo.origin.x = 0;
            projectTo.origin.y = (targetSize.height - projectTo.size.height) / 2;
        }
    } else {
        // Scale image to ensure it fits inside the specified targetSize.
        if (targetAspectRatio < aspectRatio) {
            // target is less wide than the original.
            projectTo.size.width = newSize.width;
            projectTo.size.height = projectTo.size.width / aspectRatio;
            newSize = projectTo.size;
        } else {
            // target is wider than the original.
            projectTo.size.height = newSize.height;
            projectTo.size.width = projectTo.size.height * aspectRatio;
            newSize = projectTo.size;
        }
    } // if (clip)
    LOG_IMAGE_FILTER(@"before CGRectIntegral(projectTo); projectTo: %@", NSStringFromCGRect(projectTo));
    projectTo = CGRectIntegral(projectTo);
    LOG_IMAGE_FILTER(@"after CGRectIntegral(projectTo); projectTo: %@", NSStringFromCGRect(projectTo));
    // There's no CGSizeIntegral, so we fake our own.
    CGRect integralRect = CGRectZero;
    integralRect.size = newSize;
    newSize = CGRectIntegral(integralRect).size;
    LOG_IMAGE_FILTER(@"newSize: %@", NSStringFromCGSize(newSize));
    
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.f);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetInterpolationQuality(context, quality);
    [image drawInRect:projectTo];
    UIImage* resizedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    LOG_IMAGE_FILTER(@"resizedImage: %@", NSStringFromCGSize(resizedImage.size));
    return resizedImage;
}

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
    UIImage *filterdImage = [filter imageFromCurrentFramebuffer];
    LOG_IMAGE_FILTER(@"sepiaImage: %@", NSStringFromCGSize(filterdImage.size));
    return filterdImage;
}

@end
