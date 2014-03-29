//
//  ImageFilter.h
//  TestUIImageFiliters
//
//  Created by Yu Sugawara on 2014/03/26.
//  Copyright (c) 2014年 Yu Sugawara. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ImageFilter : NSObject

#pragma mark - resize

+ (UIImage*)resizeInCoreGraphicsWithImage:(UIImage*)image
                                     size:(CGSize)newSize
                                  quality:(CGInterpolationQuality)quality
                                trimToFit:(BOOL)trimToFit;

+ (UIImage*)resizeInNYXImagesKitWithImage:(UIImage*)image
                                     size:(CGSize)size
                                trimToFit:(BOOL)trimToFit;

+ (UIImage*)resizeInGPUImageWithImage:(UIImage*)image
                                 size:(CGSize)size
                            trimToFit:(BOOL)trimToFit;

#pragma mark - sepia

+ (UIImage*)sepiaInNYXImagesKitWithImage:(UIImage*)image;
+ (UIImage*)sepiaInGPUImageWithImage:(UIImage*)image;

@end
