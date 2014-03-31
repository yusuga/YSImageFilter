//
//  TestUtility.m
//  TestUIImageFiliters
//
//  Created by Yu Sugawara on 2014/03/28.
//  Copyright (c) 2014年 Yu Sugawara. All rights reserved.
//

#import "Utility.h"
#import <YSUIKitAdditions/UIImage+YSUIKitAdditions.h>
#import "YSImageFilter.h"

NSUInteger const kNumberOfTrials = 100;

@implementation Utility

+ (UIImage*)solidColorImageWithSize:(CGSize)size
{
    return [UIImage ys_imageFromColor:[UIColor redColor] withSize:size];
}

+ (UIImage *)catImageWithSize:(CGSize)size
{
    return [YSImageFilter resizeWithImage:[UIImage imageNamed:@"cat"]
                                     size:size
                                  quality:kCGInterpolationHigh
                                trimToFit:YES
                                     mask:YSImageFilterMaskNone];
}

+ (BOOL)validateImage:(UIImage*)image estimatedSize:(CGSize)estimatedSize
{
    if (image == nil) {
        NSLog(@"%s; resizedImage == nil", __func__);
        return NO;
    }
    NSLog(@">%@ %@", NSStringFromCGSize(image.size), NSStringFromCGSize(estimatedSize));
    if (CGSizeEqualToSize(image.size, estimatedSize)) {
        return YES;
    } else {
        NSLog(@"Error: image.size: %@, estimatedSize: %@", NSStringFromCGSize(image.size), NSStringFromCGSize(estimatedSize));
        return NO;
    }
}

+ (BOOL)validateImageScaleWithImage:(UIImage*)image
{
    if (image.scale == [UIScreen mainScreen].scale) {
        return YES;
    } else {
        NSLog(@"img.scale: %f, [UIScreen mainScreen].scale: %f", image.scale, [UIScreen mainScreen].scale);
        return NO;
    }
}

@end
