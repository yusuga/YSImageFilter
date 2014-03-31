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
    YSImageFilterMaskCircle,
};

typedef void(^YSImageFilterComletion)(UIImage *filterdImage);

@interface YSImageFilter : NSObject

/* Resize */

+ (void)fastResizeWithImage:(UIImage*)image
                       size:(CGSize)newSize
                  trimToFit:(BOOL)trimToFit
                       mask:(YSImageFilterMask)mask
                 completion:(YSImageFilterComletion)completion;

+ (void)mediumQualityResizeWithImage:(UIImage*)image
                                size:(CGSize)newSize
                           trimToFit:(BOOL)trimToFit
                                mask:(YSImageFilterMask)mask
                          completion:(YSImageFilterComletion)completion;

+ (void)highQualityResizeWithImage:(UIImage*)image
                              size:(CGSize)newSize
                         trimToFit:(BOOL)trimToFit
                              mask:(YSImageFilterMask)mask
                        completion:(YSImageFilterComletion)completion;

+ (void)resizeWithImage:(UIImage*)sourceImage
                   size:(CGSize)targetSize
                quality:(CGInterpolationQuality)quality
              trimToFit:(BOOL)trimToFit
                   mask:(YSImageFilterMask)mask
             completion:(YSImageFilterComletion)completion;

+ (UIImage*)resizeWithImage:(UIImage*)sourceImage
                       size:(CGSize)targetSize
                    quality:(CGInterpolationQuality)quality
                  trimToFit:(BOOL)trimToFit
                       mask:(YSImageFilterMask)mask;

@end
