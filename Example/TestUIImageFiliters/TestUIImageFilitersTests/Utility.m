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

+ (UIImage*)imageWithSize:(CGSize)size
{
    return [UIImage ys_imageFromColor:[UIColor redColor] withSize:size];
}

+ (UIImage*)catImage500x500
{
    static UIImage *s_image;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        s_image = [UIImage imageNamed:@"cat"];
        NSAssert(s_image != nil, nil);
        CGSize size = CGSizeMake(500.f, 500.f);
        s_image = [YSImageFilter resizeWithImage:s_image size:size useGPU:YES trimToFit:YES];
        NSAssert2(CGSizeEqualToSize(size, s_image.size), @"size: %@, s_image.size: %@", NSStringFromCGSize(size), NSStringFromCGSize(s_image.size));
    });
    return s_image;
}

+ (UIImage*)catImage50x50
{
    static UIImage *s_image;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        s_image = [UIImage imageNamed:@"cat"];
        NSAssert(s_image != nil, nil);
        CGSize size = CGSizeMake(50.f, 50.f);
        s_image = [YSImageFilter resizeWithImage:s_image size:size useGPU:YES trimToFit:YES];
        NSAssert2(CGSizeEqualToSize(size, s_image.size), @"size: %@, s_image.size: %@", NSStringFromCGSize(size), NSStringFromCGSize(s_image.size));
    });
    return s_image;
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
