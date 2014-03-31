//
//  TestSepiaPerformance.m
//  TestUIImageFiliters
//
//  Created by Yu Sugawara on 2014/03/29.
//  Copyright (c) 2014年 Yu Sugawara. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "Utility.h"
#import "YSImageFilter.h"
#import "ImageFilter.h"
#import <YSProcessTimer/YSProcessTimer.h>

@interface TestSepiaPerformance : XCTestCase

@end

@implementation TestSepiaPerformance

- (void)testAllAverageWithCatImage500x500
{
    [self allAverageWithImage:[Utility catImageWithSize:CGSizeMake(500.f, 500.f)]];
}

- (void)testAllAverageWithCatImage50x50
{
    [self allAverageWithImage:[Utility catImageWithSize:CGSizeMake(50.f, 50.f)]];
}

- (void)allAverageWithImage:(UIImage*)sourceImage
{
    /* Idling */
    // CoreImage
    [ImageFilter sepiaInCoreImageWithImage:sourceImage intensity:1.f useGPU:NO];
    [ImageFilter sepiaInCoreImageWithImage:sourceImage intensity:1.f useGPU:YES];
    
    // NYXImagesKit
    [ImageFilter sepiaInNYXImagesKitWithImage:sourceImage];
    
    // GPUImage
    [ImageFilter sepiaInGPUImageWithImage:sourceImage];
    
    CGFloat intensity = 1.f;
    NSTimeInterval coreImageTimeCPU = [self averageCoreImageWithImage:sourceImage intensity:intensity useGPU:NO];
    NSTimeInterval coreImageTimeGPU = [self averageCoreImageWithImage:sourceImage intensity:intensity useGPU:YES];
    
    NSTimeInterval NYXImagesKitTime = [YSProcessTimer startAverageWithProcessName:@"average NYXImagesKit" numberOfTrials:kNumberOfTrials process:^{
        [ImageFilter sepiaInNYXImagesKitWithImage:sourceImage];
    }];
    
    NSTimeInterval GPUImageTime = [YSProcessTimer startAverageWithProcessName:@"average GPUImage" numberOfTrials:kNumberOfTrials process:^{
        [ImageFilter sepiaInGPUImageWithImage:sourceImage];
    }];
    NSLog(@"\n\n\
sourceImage.size: %@\n\
CoreImage(CPU) %f (%@ FPS)\n\
CoreImage(GPU) %f (%@ FPS)\n\
NYXImagesKit %f (%@ FPS)\n\
GPUImage %f (%@ FPS)\n\n",
          NSStringFromCGSize(sourceImage.size),
          coreImageTimeCPU,
          @(((int)(1/coreImageTimeCPU))),
          coreImageTimeGPU,
          @(((int)(1/coreImageTimeGPU))),
          NYXImagesKitTime,
          @(((int)(1/NYXImagesKitTime))),
          GPUImageTime,
          @(((int)(1/GPUImageTime))));
}

- (NSTimeInterval)averageCoreImageWithImage:(UIImage*)image intensity:(CGFloat)intensity useGPU:(BOOL)useGPU
{
    NSString *name = [NSString stringWithFormat:@"average CoreImage(%@)", useGPU ? @"GPU" : @"CPU"];
    return [YSProcessTimer startAverageWithProcessName:name numberOfTrials:kNumberOfTrials process:^{
        [ImageFilter sepiaInCoreImageWithImage:image intensity:intensity useGPU:useGPU];
    }];
}

@end
