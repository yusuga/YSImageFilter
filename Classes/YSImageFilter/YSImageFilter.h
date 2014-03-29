//
//  YSImageFilter.h
//  TestUIImageFiliters
//
//  Created by Yu Sugawara on 2014/03/26.
//  Copyright (c) 2014年 Yu Sugawara. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YSImageFilter : NSObject

+ (UIImage*)resizeWithImage:(UIImage*)image
                       size:(CGSize)targetSize
                  trimToFit:(BOOL)trimToFit;

+ (UIImage*)resizeWithImage:(UIImage*)image
                       size:(CGSize)targetSize
                     useGPU:(BOOL)useGPU
                  trimToFit:(BOOL)trimToFit;

+ (UIImage *)sepiaWithImage:(UIImage *)image
                  intensity:(CGFloat)intensity
                     useGPU:(BOOL)useGPU;

@end
