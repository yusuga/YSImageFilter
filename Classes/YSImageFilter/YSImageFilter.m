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
static inline void resizedRectWithSourceImageSize(CGSize sourceImageSize,
                                                  CGSize targetSize,
                                                  BOOL trimToFit,
                                                  CGRect* projectToPtr,
                                                  CGSize* newSizePtr)
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

#pragma mark - iOS7 RoundedRect

/* http://www.paintcodeapp.com/blogpost/code-for-ios-7-rounded-rectangles */

#define TOP_LEFT(X, Y)\
    CGPointMake(rect.origin.x + X * limitedRadius,\
    rect.origin.y + Y * limitedRadius)

#define TOP_RIGHT(X, Y)\
    CGPointMake(rect.origin.x + rect.size.width - X * limitedRadius,\
    rect.origin.y + Y * limitedRadius)

#define BOTTOM_RIGHT(X, Y)\
    CGPointMake(rect.origin.x + rect.size.width - X * limitedRadius,\
    rect.origin.y + rect.size.height - Y * limitedRadius)

#define BOTTOM_LEFT(X, Y)\
    CGPointMake(rect.origin.x + X * limitedRadius,\
    rect.origin.y + rect.size.height - Y * limitedRadius)

static inline CGPathRef iOS7RoundedCornersPath(CGRect rect)
{
    /* http://scriptogr.am/jimniels/post/calculate-the-border-radius-for-ios-style-icons-using-a-simple-ratio */
    static CGFloat kCornerRadiusRatio = 0.17544f;
    
    static NSMutableDictionary *s_cache;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        s_cache = [NSMutableDictionary dictionary];
    });
    NSString *key = [NSString stringWithFormat:@"%@", NSStringFromCGRect(rect)];
    
    UIBezierPath *path = [s_cache objectForKey:key];
    
    if (path) {
        return path.CGPath;
    }
    
    CGFloat radius = rect.size.width * kCornerRadiusRatio;
    path = UIBezierPath.bezierPath;
    CGFloat limit = MIN(rect.size.width, rect.size.height) / 2 / 1.52866483;
    CGFloat limitedRadius = MIN(radius, limit);
    
    [path moveToPoint: TOP_LEFT(1.52866483, 0.00000000)];
    [path addLineToPoint: TOP_RIGHT(1.52866471, 0.00000000)];
    [path addCurveToPoint: TOP_RIGHT(0.66993427, 0.06549600)
            controlPoint1: TOP_RIGHT(1.08849323, 0.00000000)
            controlPoint2: TOP_RIGHT(0.86840689, 0.00000000)];
    [path addLineToPoint: TOP_RIGHT(0.63149399, 0.07491100)];
    [path addCurveToPoint: TOP_RIGHT(0.07491176, 0.63149399)
            controlPoint1: TOP_RIGHT(0.37282392, 0.16905899)
            controlPoint2: TOP_RIGHT(0.16906013, 0.37282401)];
    [path addCurveToPoint: TOP_RIGHT(0.00000000, 1.52866483)
            controlPoint1: TOP_RIGHT(0.00000000, 0.86840701)
            controlPoint2: TOP_RIGHT(0.00000000, 1.08849299)];
    [path addLineToPoint: BOTTOM_RIGHT(0.00000000, 1.52866471)];
    [path addCurveToPoint: BOTTOM_RIGHT(0.06549569, 0.66993493)
            controlPoint1: BOTTOM_RIGHT(0.00000000, 1.08849323)
            controlPoint2: BOTTOM_RIGHT(0.00000000, 0.86840689)];
    [path addLineToPoint: BOTTOM_RIGHT(0.07491111, 0.63149399)];
    [path addCurveToPoint: BOTTOM_RIGHT(0.63149399, 0.07491111)
            controlPoint1: BOTTOM_RIGHT(0.16905883, 0.37282392)
            controlPoint2: BOTTOM_RIGHT(0.37282392, 0.16905883)];
    [path addCurveToPoint: BOTTOM_RIGHT(1.52866471, 0.00000000)
            controlPoint1: BOTTOM_RIGHT(0.86840689, 0.00000000)
            controlPoint2: BOTTOM_RIGHT(1.08849323, 0.00000000)];
    [path addLineToPoint: BOTTOM_LEFT(1.52866483, 0.00000000)];
    [path addCurveToPoint: BOTTOM_LEFT(0.66993397, 0.06549569)
            controlPoint1: BOTTOM_LEFT(1.08849299, 0.00000000)
            controlPoint2: BOTTOM_LEFT(0.86840701, 0.00000000)];
    [path addLineToPoint: BOTTOM_LEFT(0.63149399, 0.07491111)];
    [path addCurveToPoint: BOTTOM_LEFT(0.07491100, 0.63149399)
            controlPoint1: BOTTOM_LEFT(0.37282401, 0.16905883)
            controlPoint2: BOTTOM_LEFT(0.16906001, 0.37282392)];
    [path addCurveToPoint: BOTTOM_LEFT(0.00000000, 1.52866471)
            controlPoint1: BOTTOM_LEFT(0.00000000, 0.86840689)
            controlPoint2: BOTTOM_LEFT(0.00000000, 1.08849323)];
    [path addLineToPoint: TOP_LEFT(0.00000000, 1.52866483)];
    [path addCurveToPoint: TOP_LEFT(0.06549600, 0.66993397)
            controlPoint1: TOP_LEFT(0.00000000, 1.08849299)
            controlPoint2: TOP_LEFT(0.00000000, 0.86840701)];
    [path addLineToPoint: TOP_LEFT(0.07491100, 0.63149399)];
    [path addCurveToPoint: TOP_LEFT(0.63149399, 0.07491100)
            controlPoint1: TOP_LEFT(0.16906001, 0.37282401)
            controlPoint2: TOP_LEFT(0.37282401, 0.16906001)];
    [path addCurveToPoint: TOP_LEFT(1.52866483, 0.00000000)
            controlPoint1: TOP_LEFT(0.86840701, 0.00000000)
            controlPoint2: TOP_LEFT(1.08849299, 0.00000000)];
    [path closePath];
    
    [s_cache setObject:path forKey:key];
    
    return path.CGPath;
}

#pragma mark - path

static inline CGPathRef maskPath(CGSize size, YSImageFilterMask mask)
{
    CGRect rect = CGRectMake(0.f, 0.f, size.width, size.height);
    switch (mask) {
        case YSImageFilterMaskNone:
            return [UIBezierPath bezierPathWithRect:rect].CGPath;
        case YSImageFilterMaskRoundedCorners:
            return iOS7RoundedCornersPath(rect);
        case YSImageFilterMaskCircle:
            return [UIBezierPath bezierPathWithOvalInRect:rect].CGPath;
        default:
            return nil;
    }
}

static inline void addMaskPath(CGContextRef context, CGSize size, CGPathRef maskPath)
{
    CGContextBeginPath(context);
    CGContextAddPath(context, maskPath);
    CGContextClosePath(context);
}

@implementation YSImageFilter

+ (dispatch_queue_t)filterDispatchQueue
{
    static dispatch_queue_t s_queue;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        s_queue = dispatch_queue_create("jp.YuSugawara.YSImageFilter.queue", NULL);
    });
    return s_queue;
}

#pragma mark - resize

+ (void)resizeWithImage:(UIImage*)sourceImage
                   size:(CGSize)targetSize
                quality:(CGInterpolationQuality)quality
              trimToFit:(BOOL)trimToFit
                   mask:(YSImageFilterMask)mask
             completion:(YSImageFilterComletion)completion;
{
    [self resizeWithImage:sourceImage
                     size:targetSize
                  quality:quality
                trimToFit:trimToFit
                     mask:mask
              borderWidth:0.f
              borderColor:nil
               completion:completion];
}

+ (void)resizeWithImage:(UIImage*)sourceImage
                   size:(CGSize)targetSize
                quality:(CGInterpolationQuality)quality
              trimToFit:(BOOL)trimToFit
                   mask:(YSImageFilterMask)mask
            borderWidth:(CGFloat)borderWidth
            borderColor:(UIColor*)borderColor
             completion:(YSImageFilterComletion)completion;
{
    dispatch_async([self filterDispatchQueue], ^{
        UIImage *filterdImage = [self resizeWithImage:sourceImage
                                                 size:targetSize
                                              quality:quality
                                            trimToFit:trimToFit
                                                 mask:mask
                                          borderWidth:borderWidth
                                          borderColor:borderColor];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (completion) completion(filterdImage);
        });
    });
}

+ (UIImage*)resizeWithImage:(UIImage*)sourceImage
                       size:(CGSize)targetSize
                    quality:(CGInterpolationQuality)quality
                  trimToFit:(BOOL)trimToFit
                       mask:(YSImageFilterMask)mask
{
    return [self resizeWithImage:sourceImage
                            size:targetSize
                         quality:quality
                       trimToFit:trimToFit
                            mask:mask
                     borderWidth:0.f
                     borderColor:nil];
}

+ (UIImage*)resizeWithImage:(UIImage*)sourceImage
                       size:(CGSize)targetSize
                    quality:(CGInterpolationQuality)quality
                  trimToFit:(BOOL)trimToFit
                       mask:(YSImageFilterMask)mask
                borderWidth:(CGFloat)borderWidth
                borderColor:(UIColor*)borderColor
{
    CGSize sourceImageSize = sourceImage.size;
    LOG_YSIMAGE_FILTER(@"sourceImage.size: %@", NSStringFromCGSize(sourceImageSize));
    if (sourceImageSize.height < 1 || sourceImageSize.width < 1 ||
        targetSize.height < 1 || targetSize.width < 1) {
        return nil;
    }

    CGRect projectTo;
    CGSize newSize;
    if (CGSizeEqualToSize(sourceImage.size, targetSize)) {
        projectTo = CGRectMake(0.f, 0.f, targetSize.width, targetSize.height);
        newSize = targetSize;
    } else {
        resizedRectWithSourceImageSize(sourceImageSize, targetSize, trimToFit, &projectTo, &newSize);
    }
    
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.f);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetInterpolationQuality(context, quality);

    CGPathRef path = maskPath(newSize, mask);
    addMaskPath(context, newSize, path);
    CGContextClip(context);
    
    [sourceImage drawInRect:projectTo];

    if (borderWidth > 0.f && borderColor != nil) {
        addMaskPath(context, newSize, path);
        CGContextSetLineWidth(context, borderWidth);
        CGContextSetStrokeColorWithColor(context, borderColor.CGColor);
        CGContextStrokePath(context);
    }
    
    UIImage* resizedImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    LOG_YSIMAGE_FILTER(@"resizedImage: %@", NSStringFromCGSize(resizedImage.size));
    return resizedImage;
}

+ (CGPathRef)maskPathOfSize:(CGSize)size mask:(YSImageFilterMask)mask
{
    return maskPath(size, mask);
}

@end