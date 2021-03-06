//
//  TestUtility.m
//  TestUIImageFiliters
//
//  Created by Yu Sugawara on 2014/03/28.
//  Copyright (c) 2014年 Yu Sugawara. All rights reserved.
//

#import "Utility.h"
#import <YSUIKitAdditions/UIImage+YSUIKitAdditions.h>
#import "UIImage+YSImageFilter.h"

NSUInteger const kNumberOfTrials = 100;

@implementation Utility

+ (UIImage *)imageWithSize:(CGSize)size type:(ImageType)type
{
    switch (type) {
        case ImageTypeSolidColor:
            return [self solidColorImageWithSize:size];
            case ImageTypeCat:
            return [self catImageWithSize:size];
        default:
            NSAssert1(false, @"Unsupported image type = %zd;", type);
            return nil;
    }
}

+ (UIImage*)solidColorImageWithSize:(CGSize)size
{
    return [UIImage ys_imageFromColor:[UIColor redColor] withSize:size];
}

+ (UIImage *)catImageWithSize:(CGSize)size
{
    YSImageFilter *filter = [[YSImageFilter alloc] init];
    filter.size = size;
    filter.quality = kCGInterpolationHigh;
    filter.trimToFit = YES;
    
    return [[UIImage imageNamed:@"cat"] ys_filter:filter];
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
