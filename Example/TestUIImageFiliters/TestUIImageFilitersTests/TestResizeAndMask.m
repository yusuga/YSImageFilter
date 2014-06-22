//
//  TestResize.m
//  TestUIImageFiliters
//
//  Created by Yu Sugawara on 2014/03/28.
//  Copyright (c) 2014年 Yu Sugawara. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "Utility.h"
#import "UIImage+YSImageFilter.h"
#import "ImageFilter.h"
#import <NSRunLoop+PerformBlock/NSRunLoop+PerformBlock.h>

typedef BOOL(^QuadrangleProcess)(UIImage *image, CGSize size);

@interface TestResizeAndMask : XCTestCase

@end

@implementation TestResizeAndMask

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

#pragma mark - test CoreGraphics

- (void)testResizeSquareInCoreGraphics
{
    [self resizeSquareWithProcess:^BOOL(UIImage *image, CGSize size) {
        return [self resizeInCoreGraphicsWithImage:image size:size];
    }];
}

- (void)testResizeRectangle4to3InCoreGraphics
{
    [self resizeRectangle4to3WithProcess:^BOOL(UIImage *image, CGSize size) {
        return [self resizeInCoreGraphicsWithImage:image size:size];
    }];
}

- (void)testResizeRectangle3to4InCoreGraphics
{
    [self resizeRectangle3to4WithProcess:^BOOL(UIImage *image, CGSize size) {
        return [self resizeInCoreGraphicsWithImage:image size:size];
    }];
}

#pragma mark - test NYXImagesKit

- (void)testResizeSquareInNYXImagesKit
{
    [self resizeSquareWithProcess:^BOOL(UIImage *image, CGSize size) {
        return [self resizeInNYXImagesKitWithImage:image size:size];
    }];
}
- (void)testResizeRectangle4to3InNYXImagesKit
{
    [self resizeRectangle4to3WithProcess:^BOOL(UIImage *image, CGSize size) {
        return [self resizeInNYXImagesKitWithImage:image size:size];
    }];
}

- (void)testResizeRectangle3to4InNYXImagesKit
{
    [self resizeRectangle3to4WithProcess:^BOOL(UIImage *image, CGSize size) {
        return [self resizeInNYXImagesKitWithImage:image size:size];
    }];
}

#pragma mark - GPUImage

- (void)testResizeSquareInGPUImage
{
    [self resizeSquareWithProcess:^BOOL(UIImage *image, CGSize size) {
        return [self resizeInGPUImageKitWithImage:image size:size];
    }];
}
- (void)testResizeRectangle4to3InGPUImage
{
    [self resizeRectangle4to3WithProcess:^BOOL(UIImage *image, CGSize size) {
        return [self resizeInGPUImageKitWithImage:image size:size];
    }];
}

- (void)testResizeRectangle3to4InGPUImage
{
    [self resizeRectangle3to4WithProcess:^BOOL(UIImage *image, CGSize size) {
        return [self resizeInGPUImageKitWithImage:image size:size];
    }];
}

#pragma mark - test CoreImage

- (void)testResizeSquareInCoreImage
{
    [self resizeSquareWithProcess:^BOOL(UIImage *image, CGSize size) {
        return [self resizeInCoreImageWithImage:image size:size useGPU:NO];
    }];
    
    [self resizeSquareWithProcess:^BOOL(UIImage *image, CGSize size) {
        return [self resizeInCoreImageWithImage:image size:size useGPU:YES];
    }];
}

- (void)testResizeRectangle4to3InCoreImage
{
    [self resizeRectangle4to3WithProcess:^BOOL(UIImage *image, CGSize size) {
        return [self resizeInCoreImageWithImage:image size:size useGPU:NO];
    }];
    
    [self resizeRectangle4to3WithProcess:^BOOL(UIImage *image, CGSize size) {
        return [self resizeInCoreImageWithImage:image size:size useGPU:YES];
    }];
}

- (void)testResizeRectangle3to4InCoreImage
{
    [self resizeRectangle3to4WithProcess:^BOOL(UIImage *image, CGSize size) {
        return [self resizeInCoreImageWithImage:image size:size useGPU:NO];
    }];
    
    [self resizeRectangle3to4WithProcess:^BOOL(UIImage *image, CGSize size) {
        return [self resizeInCoreImageWithImage:image size:size useGPU:YES];
    }];
}

#pragma mark - resize process

- (BOOL)resizeInCoreGraphicsWithImage:(UIImage*)image size:(CGSize)size
{
    NSArray *qualities = @[@(kCGInterpolationNone),
                           @(kCGInterpolationLow),
                           @(kCGInterpolationMedium),
                           @(kCGInterpolationHigh),
                           @(kCGInterpolationDefault)];
    
    NSArray *masks = @[@(YSImageFilterMaskNone),
                       @(YSImageFilterMaskRoundedCorners),
                       @(YSImageFilterMaskCircle)];
    
    for (NSNumber *qualityNum in qualities) {
        CGInterpolationQuality quality = [qualityNum integerValue];
        for (NSNumber *maskNum in masks) {
            YSImageFilterMask mask = [maskNum integerValue];
            
            for (NSNumber *asyncNum in @[@NO, @YES]) {
                BOOL async = [asyncNum boolValue];
                if (![self validateResizedImageWithSourceImage:image resizeSize:size process:^UIImage *(UIImage *sourceImage,
                                                                                                        CGSize resizeSize,
                                                                                                        BOOL trimToFit)
                      {
                          YSImageFilter *filter = [[YSImageFilter alloc] init];
                          filter.size = size;
                          filter.quality = quality;
                          filter.trimToFit = trimToFit;
                          filter.mask = mask;
                          
                          __block UIImage *resizedImage;
                          if (async) {
                              [[NSRunLoop currentRunLoop] performBlockAndWait:^(BOOL *finish) {
                                  [sourceImage ys_filter:filter withCompletion:^(UIImage *filterdImage) {
                                      resizedImage = filterdImage;
                                      *finish = YES;
                                  }];
                              } timeoutInterval:DBL_MAX];
                          } else {
                              resizedImage = [sourceImage ys_filter:filter];
                          }
                          return resizedImage;
                      }]) {
                          return NO;
                      }
            }
        }
    }
    return YES;
}

- (BOOL)resizeInNYXImagesKitWithImage:(UIImage*)image size:(CGSize)size
{
    if (![self validateResizedImageWithSourceImage:image resizeSize:size process:^UIImage *(UIImage *sourceImage, CGSize resizeSize, BOOL trimToFit) {
        return [ImageFilter resizeInNYXImagesKitWithImage:sourceImage size:size trimToFit:trimToFit];
    }]) {
        return NO;
    }
    return YES;
}

- (BOOL)resizeInGPUImageKitWithImage:(UIImage*)image size:(CGSize)size
{
    if (![self validateResizedImageWithSourceImage:image resizeSize:size process:^UIImage *(UIImage *sourceImage, CGSize resizeSize, BOOL trimToFit) {
        return [ImageFilter resizeInGPUImageWithImage:sourceImage size:size trimToFit:trimToFit];
    }]) {
        return NO;
    }
    return YES;
}

- (BOOL)resizeInCoreImageWithImage:(UIImage*)image size:(CGSize)size useGPU:(BOOL)useGPU
{
    if (![self validateResizedImageWithSourceImage:image resizeSize:size process:^UIImage *(UIImage *sourceImage, CGSize resizeSize, BOOL trimToFit) {
        return [ImageFilter resizeInCoreImageWithImage:sourceImage size:resizeSize useGPU:useGPU trimToFit:trimToFit];
    }]) {
        return NO;
    }
    return YES;
}

#pragma mark - quadrangle process

- (void)resizeSquareWithProcess:(QuadrangleProcess)process
{
    NSArray *images = @[[Utility solidColorImageWithSize:CGSizeMake(100.f, 100.f)],
                        [Utility solidColorImageWithSize:CGSizeMake(50.f, 50.f)],
                        [Utility solidColorImageWithSize:CGSizeMake(1.f, 1.f)]];
    for (UIImage *image in images) {
        if (!process(image, CGSizeMake(50.f, 50.f))) {
            return;
        }
    }
}

- (void)resizeRectangle4to3WithProcess:(QuadrangleProcess)process
{
    NSArray *images = @[[Utility solidColorImageWithSize:CGSizeMake(120.f, 90.f)],
                        [Utility solidColorImageWithSize:CGSizeMake(40.f, 30.f)],
                        [Utility solidColorImageWithSize:CGSizeMake(4.f, 3.f)]];
    for (UIImage *image in images) {
        if (!process(image, CGSizeMake(40.f, 30.f))) {
            return;
        }
    }
}

- (void)resizeRectangle3to4WithProcess:(QuadrangleProcess)process
{
    NSArray *images = @[[Utility solidColorImageWithSize:CGSizeMake(90.f, 120.f)],
                        [Utility solidColorImageWithSize:CGSizeMake(30.f, 40.f)],
                        [Utility solidColorImageWithSize:CGSizeMake(3.f, 4.f)]];
    for (UIImage *image in images) {
        if (!process(image, CGSizeMake(30.f, 40.f))) {
            return;
        }
    }
}

#pragma mark - validate

- (BOOL)validateResizedImageWithSourceImage:(UIImage*)sourceImage
                                 resizeSize:(CGSize)resizeSize
                                    process:(UIImage*(^)(UIImage *sourceImage, CGSize resizeSize, BOOL trimToFit))process
{
    for (NSNumber *trimToFitNum in @[@NO, @YES]) {
        BOOL trimToFit = [trimToFitNum boolValue];
        if (![self validateResizedImage:process(sourceImage, resizeSize, trimToFit)
                             resizeSize:resizeSize
                        sourceImageSize:sourceImage.size
                              trimToFit:trimToFit])
        {
            return NO;
        }
    }
    return YES;
}

- (BOOL)validateResizedImage:(UIImage*)resizedImage resizeSize:(CGSize)resizeSize sourceImageSize:(CGSize)sourceImageSize trimToFit:(BOOL)trimToFit
{
    CGSize estimatedSize;
    if (trimToFit) {
        estimatedSize = resizeSize;
    } else {
        CGSize imageSize = sourceImageSize;
        CGFloat aspectRatio = imageSize.width / imageSize.height;
        CGFloat targetAspectRatio = resizeSize.width / resizeSize.height;
        if (targetAspectRatio < aspectRatio) {
            estimatedSize = CGSizeMake(resizeSize.width,
                                       resizeSize.width / aspectRatio);
        } else {
            estimatedSize = CGSizeMake(resizeSize.height * aspectRatio,
                                       resizeSize.height);
        }
        CGRect integralRect = CGRectZero;
        integralRect.size = estimatedSize;
        estimatedSize = CGRectIntegral(integralRect).size;
    }
    NSLog(@"estimatedSize: %@", NSStringFromCGSize(estimatedSize));
    if (![Utility validateImage:resizedImage estimatedSize:estimatedSize]) {
        XCTFail(@"image.size: %@, resize: %@, estimatedSize: %@, resizedImage.size: %@", NSStringFromCGSize(sourceImageSize), NSStringFromCGSize(resizeSize), NSStringFromCGSize(estimatedSize), NSStringFromCGSize(resizedImage.size));
        return NO;
    }
    return YES;
}

@end
