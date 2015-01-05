//
//  TestUtility.h
//  TestUIImageFiliters
//
//  Created by Yu Sugawara on 2014/03/28.
//  Copyright (c) 2014年 Yu Sugawara. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSUInteger const kNumberOfTrials;

typedef void(^EnumerateSizes)(CGSize size, BOOL *finish);

typedef NS_ENUM(NSUInteger, ImageType) {
    ImageTypeSolidColor,
    ImageTypeCat,
};

@interface Utility : NSObject

+ (UIImage*)imageWithSize:(CGSize)size type:(ImageType)type;
+ (UIImage*)solidColorImageWithSize:(CGSize)size;
+ (UIImage*)catImageWithSize:(CGSize)size;

+ (BOOL)validateImage:(UIImage*)image estimatedSize:(CGSize)estimatedSize;
+ (BOOL)validateImageScaleWithImage:(UIImage*)image;

@end
