//
//  UIImage+YSImageFilter.m
//  TestUIImageFiliters
//
//  Created by Yu Sugawara on 2014/06/22.
//  Copyright (c) 2014年 Yu Sugawara. All rights reserved.
//

#import "UIImage+YSImageFilter.h"

#if DEBUG
    #if 0
        #warning enable debug log
        #define LOG_YSIMAGE_FILTER(...) NSLog(__VA_ARGS__)
    #endif
#endif

#ifndef LOG_YSIMAGE_FILTER
    #define LOG_YSIMAGE_FILTER(...)
#endif

static NSString * const kMonochrome = @"CIColorMonochrome";

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

static inline void resizedRectOfMaxResolutionWithSourceImageSize(CGSize sourceImageSize,
                                                                 CGFloat maxResolution,
                                                                 CGRect* projectToPtr,
                                                                 CGSize* newSizePtr)
{
    CGSize imgSize = sourceImageSize;
	if (imgSize.width > maxResolution || imgSize.height > maxResolution) {
		CGFloat ratio = imgSize.width/imgSize.height;
		if (ratio > 1) {
			imgSize.width = maxResolution;
			imgSize.height = imgSize.width / ratio;
		}
		else {
			imgSize.height = maxResolution;
			imgSize.width = imgSize.height * ratio;
		}
	}
	*projectToPtr = CGRectMake(0.f, 0.f, imgSize.width, imgSize.height);
    *newSizePtr = imgSize;
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

static inline CGPathRef iOS7RoundedCornersPath(CGRect rect, CGFloat radius)
{
    static NSMutableDictionary *s_cache;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        s_cache = [NSMutableDictionary dictionary];
    });
    NSString *key = [NSString stringWithFormat:@"%@_%f", NSStringFromCGRect(rect), radius];
    
    UIBezierPath *path = [s_cache objectForKey:key];
    
    if (path) {
        return path.CGPath;
    }
    
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

/* http://scriptogr.am/jimniels/post/calculate-the-border-radius-for-ios-style-icons-using-a-simple-ratio */
static CGFloat kIOS7CornerRadiusRatio = 0.17544f;

static inline CGFloat iOS7CornerRadius(CGRect rect)
{
    return MIN(rect.size.width, rect.size.height) * kIOS7CornerRadiusRatio;
}

static inline CGPathRef maskPath(CGSize size, YSImageFilterMask mask, CGFloat radius)
{
    CGRect rect = CGRectMake(0.f, 0.f, size.width, size.height);
    switch (mask) {
        case YSImageFilterMaskNone:
            return [UIBezierPath bezierPathWithRect:rect].CGPath;
        case YSImageFilterMaskRoundedCorners:
            return iOS7RoundedCornersPath(rect, radius);
        case YSImageFilterMaskRoundedCornersIOS7RadiusRatio:
            return iOS7RoundedCornersPath(rect, iOS7CornerRadius(rect));
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

- (instancetype)init
{
    if (self = [super init]) {
        self.quality = kCGInterpolationDefault;
    }
    return self;
}

+ (NSDictionary *)monochromeAttributesWithColor:(UIColor*)color intensity:(CGFloat)intensity
{
    return @{kMonochrome : @{
                     kCIInputColorKey : color,
                     kCIInputIntensityKey : @(intensity)
                     }
             };
}

+ (CGPathRef)maskPathOfSize:(CGSize)size
                       mask:(YSImageFilterMask)mask
           maskCornerRadius:(CGFloat)maskCornerRadius
{
    return maskPath(size, mask, maskCornerRadius);
}

@end

@implementation UIImage (YSImageFilter)

+ (dispatch_queue_t)ys_filterDispatchQueue
{
    static dispatch_queue_t s_queue;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        s_queue = dispatch_queue_create("jp.YuSugawara.YSImageFilter.queue", NULL);
    });
    return s_queue;
}

- (UIImage*)ys_filter:(YSImageFilter*)filter
{
    if (self.images) {
        NSMutableArray *images = [NSMutableArray arrayWithCapacity:[self.images count]];
        for (UIImage *image in self.images) {
            [images addObject:[image ys_filter:filter]];
        }
        return [UIImage animatedImageWithImages:images duration:self.duration];
    } else {
        return [[self class] ys_filteredImageForImage:self withFilter:filter];
    }
}

- (void)ys_filter:(YSImageFilter*)filter withCompletion:(YSImageFilterComletion)completion
{
    __strong typeof(self) strongSelf = self;
    dispatch_async([[self class] ys_filterDispatchQueue], ^{
        UIImage *filteredImage = [strongSelf ys_filter:filter];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (completion) completion(filteredImage);
        });
    });
}

#pragma mark - Private

+ (UIImage*)ys_filteredImageForImage:(UIImage*)image withFilter:(YSImageFilter*)filter
{
    UIImage *sourceImage = image;
    CGSize sourceImageSize = sourceImage.size;
    
    LOG_YSIMAGE_FILTER(@"sourceImage.size: %@", NSStringFromCGSize(sourceImageSize));
    if (sourceImageSize.height < 1 || sourceImageSize.width < 1) {
        return image;
    }
    
    BOOL resize = NO;
    CGRect projectTo;
    CGSize newSize;
    
    if (filter.maxResolution > 0.f) {
        resize = YES;
        resizedRectOfMaxResolutionWithSourceImageSize(sourceImageSize, filter.maxResolution, &projectTo, &newSize);
    } else {
        if (CGSizeEqualToSize(filter.size, CGSizeZero) ||
            CGSizeEqualToSize(sourceImageSize, filter.size)) {
            projectTo = CGRectMake(0.f, 0.f, sourceImageSize.width, sourceImageSize.height);
            newSize = sourceImageSize;
        } else {
            resize = YES;
            resizedRectWithSourceImageSize(sourceImageSize, filter.size, filter.trimToFit, &projectTo, &newSize);
        }
    }
    
    CGPathRef path = maskPath(newSize, filter.mask, filter.maskCornerRadius);
    
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.f);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetInterpolationQuality(context, filter.quality);
    
    if ([filter.colorEffectFilterAttributes count] > 0) {
        if (resize || filter.mask != YSImageFilterMaskNone) {
            addMaskPath(context, newSize, path);
            CGContextClip(context);
            [sourceImage drawInRect:projectTo];
            sourceImage = UIGraphicsGetImageFromCurrentImageContext();
        }
        
        for (NSDictionary *filterAttribute in filter.colorEffectFilterAttributes) {
            CIImage *ciImage = [[CIImage alloc] initWithCGImage:sourceImage.CGImage];
            NSString *filterName = [[filterAttribute allKeys] firstObject];
            NSDictionary *attribute = filterAttribute[filterName];
            CIFilter *filter;
            if ([filterName isEqualToString:kMonochrome]) {
                UIColor *color = attribute[kCIInputColorKey];
                NSNumber *intensity = attribute[kCIInputIntensityKey];
                filter = [CIFilter filterWithName:filterName
                                    keysAndValues:kCIInputImageKey, ciImage, kCIInputColorKey, [CIColor colorWithCGColor:color.CGColor], kCIInputIntensityKey, intensity, nil];
            } else {
                NSAssert1(false, @"unsupported filter: %@", filterName);
                continue;
            }
            
            CIImage *filteredImage = [filter outputImage];
            sourceImage = imageFromCIImage(filteredImage, sourceImage.scale, YES);
        }
    }
    
    if (filter.backgroundColor) {
        CGContextRef context = UIGraphicsGetCurrentContext();
        [filter.backgroundColor setFill];
        addMaskPath(context, newSize, path);
        CGContextFillPath(context);
    }
    
    addMaskPath(context, newSize, path);
    CGContextClip(context);
    [sourceImage drawInRect:projectTo];
    
    if (filter.borderWidth > 0.f && filter.borderColor) {
        addMaskPath(context, newSize, path);
        CGContextSetLineWidth(context, filter.borderWidth);
        CGContextSetStrokeColorWithColor(context, filter.borderColor.CGColor);
        CGContextStrokePath(context);
    }
    
    UIImage *filteredImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    LOG_YSIMAGE_FILTER(@"filteredImage: %@", NSStringFromCGSize(filteredImage.size));
    return filteredImage;
}

@end
