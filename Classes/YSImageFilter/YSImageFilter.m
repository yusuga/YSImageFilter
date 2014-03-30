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

typedef void(^ResizedRect)(CGRect projectTo, CGSize newSize);

@implementation YSImageFilter

#pragma mark - resize

+ (UIImage *)fastResizeWithImage:(UIImage *)image size:(CGSize)newSize trimToFit:(BOOL)trimToFit
{
    return [self resizeWithImage:image size:newSize quality:kCGInterpolationLow trimToFit:trimToFit];
}

+ (UIImage *)highQualityResizeWithImage:(UIImage *)image size:(CGSize)newSize trimToFit:(BOOL)trimToFit
{
    return [self resizeWithImage:image size:newSize quality:kCGInterpolationHigh trimToFit:trimToFit];
}

+ (UIImage*)resizeWithImage:(UIImage*)sourceImage
                       size:(CGSize)targetSize
                    quality:(CGInterpolationQuality)quality
                  trimToFit:(BOOL)trimToFit
{
    CGSize sourceImageSize = sourceImage.size;
    LOG_YSIMAGE_FILTER(@"sourceImage.size: %@", NSStringFromCGSize(sourceImgSize));
    if (sourceImageSize.height < 1 || sourceImageSize.width < 1 ||
        targetSize.height < 1 || targetSize.width < 1) {
        return nil;
    }

    CGRect projectTo;
    CGSize newSize;
    [self resizedRectWithSourceImageSize:sourceImageSize
                              targetSize:targetSize
                               trimToFit:trimToFit
                            projectToPtr:&projectTo
                              newSizePtr:&newSize];
    
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.f);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetInterpolationQuality(context, quality);
    [sourceImage drawInRect:projectTo];
    UIImage* resizedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    LOG_YSIMAGE_FILTER(@"resizedImage: %@", NSStringFromCGSize(resizedImage.size));
    return resizedImage;
}

/*
 GTMUIImage+Resize.m
 Copyright 2009 Google Inc.
 
 Licensed under the Apache License, Version 2.0 (the "License"); you may not
 use this file except in compliance with the License.  You may obtain a copy
 of the License at
 
 http://www.apache.org/licenses/LICENSE-2.0
 
 Unless required by applicable law or agreed to in writing, software
 distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
 WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.  See the
 License for the specific language governing permissions and limitations under
 the License.
 */
+ (void)resizedRectWithSourceImageSize:(CGSize)sourceImageSize
                            targetSize:(CGSize)targetSize
                             trimToFit:(BOOL)trimToFit
                          projectToPtr:(CGRect*)projectToPtr
                            newSizePtr:(CGSize*)newSizePtr
{
    CGFloat aspectRatio = sourceImageSize.width / sourceImageSize.height;
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
    
    LOG_YSIMAGE_FILTER(@"before CGRectIntegral(projectTo); projectTo: %@", NSStringFromCGRect(projectTo));
    projectTo = CGRectIntegral(projectTo);
    LOG_YSIMAGE_FILTER(@"after CGRectIntegral(projectTo); projectTo: %@", NSStringFromCGRect(projectTo));
    // There's no CGSizeIntegral, so we fake our own.
    CGRect integralRect = CGRectZero;
    integralRect.size = newSize;
    newSize = CGRectIntegral(integralRect).size;
    LOG_YSIMAGE_FILTER(@"newSize: %@", NSStringFromCGSize(newSize));
    
    *projectToPtr = projectTo;
    *newSizePtr = newSize;
}

@end
                                                                                                        
