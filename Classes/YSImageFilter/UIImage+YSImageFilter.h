//
//  UIImage+YSImageFilter.h
//  TestUIImageFiliters
//
//  Created by Yu Sugawara on 2014/06/22.
//  Copyright (c) 2014年 Yu Sugawara. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^YSImageFilterComletion)(UIImage *filteredImage);

typedef NS_ENUM(NSUInteger, YSImageFilterMask) {
    YSImageFilterMaskNone,
    YSImageFilterMaskRoundedCorners,
    YSImageFilterMaskRoundedCornersIOS7RadiusRatio,
    YSImageFilterMaskCircle,
};

@interface YSImageFilter : NSObject

// resize
@property (nonatomic) CGSize size;
@property (nonatomic) CGFloat maxResolution;
@property (nonatomic) CGInterpolationQuality quality; // default: kCGInterpolationDefault
@property (nonatomic) BOOL trimToFit;

// border
@property (nonatomic) CGFloat borderWidth;
@property (nonatomic) UIColor *borderColor;

// mask
@property (nonatomic) YSImageFilterMask mask;
@property (nonatomic) CGFloat maskCornerRadius;

// background color
@property (nonatomic) UIColor *backgroundColor;
 
// color effect
@property (nonatomic) NSArray *colorEffectFilterAttributes;

+ (NSDictionary *)monochromeAttributesWithColor:(UIColor*)color
                                      intensity:(CGFloat)intensity;

// mask path

+ (CGPathRef)maskPathOfSize:(CGSize)size
                       mask:(YSImageFilterMask)mask
           maskCornerRadius:(CGFloat)maskCornerRadius;

@end

@interface UIImage (YSImageFilter)

- (UIImage*)ys_filter:(YSImageFilter*)filter;

- (void)ys_filter:(YSImageFilter*)filter
   withCompletion:(YSImageFilterComletion)completion;

@end
