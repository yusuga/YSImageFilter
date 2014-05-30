//
//  YSImageFilter.h
//  TestUIImageFiliters
//
//  Created by Yu Sugawara on 2014/03/26.
//  Copyright (c) 2014年 Yu Sugawara. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, YSImageFilterMask) {
    YSImageFilterMaskNone,
    YSImageFilterMaskRoundedCorners,
    YSImageFilterMaskRoundedCornersIOS7RadiusRatio,
    YSImageFilterMaskCircle,
};

typedef void(^YSImageFilterComletion)(UIImage *filterdImage);

@interface YSImageFilter : NSObject

/* Resize */

// sync

+ (UIImage*)resizeWithImage:(UIImage*)sourceImage
                       size:(CGSize)targetSize
                    quality:(CGInterpolationQuality)quality
                  trimToFit:(BOOL)trimToFit
                       mask:(YSImageFilterMask)mask;

+ (UIImage*)resizeWithImage:(UIImage*)sourceImage
                       size:(CGSize)targetSize
                    quality:(CGInterpolationQuality)quality
                  trimToFit:(BOOL)trimToFit
                       mask:(YSImageFilterMask)mask
                borderWidth:(CGFloat)borderWidth
                borderColor:(UIColor*)borderColor;

+ (UIImage*)resizeWithImage:(UIImage*)sourceImage
                       size:(CGSize)targetSize
                    quality:(CGInterpolationQuality)quality
                  trimToFit:(BOOL)trimToFit
                       mask:(YSImageFilterMask)mask
                borderWidth:(CGFloat)borderWidth
                borderColor:(UIColor*)borderColor
           maskCornerRadius:(CGFloat)maskCornerRadius;

+ (CGPathRef)maskPathOfSize:(CGSize)size
                       mask:(YSImageFilterMask)mask
           maskCornerRadius:(CGFloat)maskCornerRadius;

// async

+ (void)resizeWithImage:(UIImage*)sourceImage
                   size:(CGSize)targetSize
                quality:(CGInterpolationQuality)quality
              trimToFit:(BOOL)trimToFit
                   mask:(YSImageFilterMask)mask
             completion:(YSImageFilterComletion)completion;

+ (void)resizeWithImage:(UIImage*)sourceImage
                   size:(CGSize)targetSize
                quality:(CGInterpolationQuality)quality
              trimToFit:(BOOL)trimToFit
                   mask:(YSImageFilterMask)mask
            borderWidth:(CGFloat)borderWidth
            borderColor:(UIColor*)borderColor
             completion:(YSImageFilterComletion)completion;

+ (void)resizeWithImage:(UIImage*)sourceImage
                   size:(CGSize)targetSize
                quality:(CGInterpolationQuality)quality
              trimToFit:(BOOL)trimToFit
                   mask:(YSImageFilterMask)mask
            borderWidth:(CGFloat)borderWidth
            borderColor:(UIColor*)borderColor
       maskCornerRadius:(CGFloat)maskCornerRadius
             completion:(YSImageFilterComletion)completion;

/* color filter */
// https://developer.apple.com/jp/documentation/GraphicsImaging/Conceptual/CoreImaging/ci_filters/chapter_5_section_4.html

// sync

+ (UIImage *)monochromeImageWithImage:(UIImage*)sourceImage
                                color:(UIColor*)color
                            intensity:(CGFloat)intensity;

// async

+ (void)monochromeImageWithImage:(UIImage*)sourceImage
                           color:(UIColor*)color
                       intensity:(CGFloat)intensity
                      completion:(YSImageFilterComletion)completion;

@end
