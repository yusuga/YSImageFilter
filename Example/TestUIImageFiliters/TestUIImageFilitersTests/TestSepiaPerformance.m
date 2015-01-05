//
//  TestSepiaPerformance.m
//  TestUIImageFiliters
//
//  Created by Yu Sugawara on 2014/03/29.
//  Copyright (c) 2014年 Yu Sugawara. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "Utility.h"
#import "UIImage+YSImageFilter.h"
#import "ImageFilter.h"
#import <YSProcessTimer/YSProcessTimer.h>

@interface TestSepiaPerformance : XCTestCase

@end

@implementation TestSepiaPerformance

#pragma mark - CoreImage
#pragma mark CPU

- (void)testCoreImageWithImage500x500
{
    BOOL useGPU = NO;
    UIImage *image = [self imageInCoreImageWithSourceSize:500.f useGPU:useGPU];
    
    [self measureMetrics:[XCTestCase defaultPerformanceMetrics] automaticallyStartMeasuring:NO forBlock:^{
        [self startMeasuring];
        [ImageFilter sepiaInCoreImageWithImage:image intensity:1.f useGPU:useGPU];
        [self stopMeasuring];
    }];
}

- (void)testCoreImageWithImage50x50
{
    BOOL useGPU = NO;
    UIImage *image = [self imageInCoreImageWithSourceSize:50.f useGPU:useGPU];
    
    [self measureMetrics:[XCTestCase defaultPerformanceMetrics] automaticallyStartMeasuring:NO forBlock:^{
        [self startMeasuring];
        [ImageFilter sepiaInCoreImageWithImage:image intensity:1.f useGPU:useGPU];
        [self stopMeasuring];
    }];
}

#pragma mark GPU

- (void)testCoreImageWithGPUWithImage500x500
{
    BOOL useGPU = YES;
    UIImage *image = [self imageInCoreImageWithSourceSize:500.f useGPU:useGPU];
    
    [self measureMetrics:[XCTestCase defaultPerformanceMetrics] automaticallyStartMeasuring:NO forBlock:^{
        [self startMeasuring];
        [ImageFilter sepiaInCoreImageWithImage:image intensity:1.f useGPU:useGPU];
        [self stopMeasuring];
    }];
}

- (void)testCoreImageWithGPUWithImage50x50
{
    BOOL useGPU = YES;
    UIImage *image = [self imageInCoreImageWithSourceSize:50.f useGPU:useGPU];
    
    [self measureMetrics:[XCTestCase defaultPerformanceMetrics] automaticallyStartMeasuring:NO forBlock:^{
        [self startMeasuring];
        [ImageFilter sepiaInCoreImageWithImage:image intensity:1.f useGPU:useGPU];
        [self stopMeasuring];
    }];
}

#pragma mark - NYXImagesKit

- (void)testNYXImagesKitWithGPUWithImage500x500
{
    UIImage *image = [self imageInNYXImagesKitWithSourceSize:500.f];
    
    [self measureMetrics:[XCTestCase defaultPerformanceMetrics] automaticallyStartMeasuring:NO forBlock:^{
        [self startMeasuring];
        [ImageFilter sepiaInNYXImagesKitWithImage:image];
        [self stopMeasuring];
    }];
}

- (void)testNYXImagesKitWithGPUWithImage50x50
{
    UIImage *image = [self imageInNYXImagesKitWithSourceSize:50.f];
    
    [self measureMetrics:[XCTestCase defaultPerformanceMetrics] automaticallyStartMeasuring:NO forBlock:^{
        [self startMeasuring];
        [ImageFilter sepiaInNYXImagesKitWithImage:image];
        [self stopMeasuring];
    }];
}

#pragma mark - GPUImage

- (void)testGPUImageWithGPUWithImage500x500
{
    UIImage *image = [self imageInGPUImageWithSourceSize:500.f];
    
    [self measureMetrics:[XCTestCase defaultPerformanceMetrics] automaticallyStartMeasuring:NO forBlock:^{
        [self startMeasuring];
        [ImageFilter sepiaInGPUImageWithImage:image];
        [self stopMeasuring];
    }];
}

- (void)testGPUImageWithGPUWithImage50x50
{
    UIImage *image = [self imageInGPUImageWithSourceSize:50.f];
    
    [self measureMetrics:[XCTestCase defaultPerformanceMetrics] automaticallyStartMeasuring:NO forBlock:^{
        [self startMeasuring];
        [ImageFilter sepiaInGPUImageWithImage:image];
        [self stopMeasuring];
    }];
}

#pragma mark - Utility

- (UIImage*)imageInCoreImageWithSourceSize:(CGFloat)sourceSize
                                    useGPU:(BOOL)useGPU
{
    UIImage *image = [Utility catImageWithSize:CGSizeMake(sourceSize, sourceSize)];
    [ImageFilter sepiaInCoreImageWithImage:image intensity:1.f useGPU:useGPU];
    return image;
}

- (UIImage*)imageInNYXImagesKitWithSourceSize:(CGFloat)sourceSize
{
    UIImage *image = [Utility catImageWithSize:CGSizeMake(sourceSize, sourceSize)];
    [ImageFilter sepiaInNYXImagesKitWithImage:image];
    return image;
}

- (UIImage*)imageInGPUImageWithSourceSize:(CGFloat)sourceSize
{
    UIImage *image = [Utility catImageWithSize:CGSizeMake(sourceSize, sourceSize)];
    [ImageFilter sepiaInGPUImageWithImage:image];
    return image;
}

@end
