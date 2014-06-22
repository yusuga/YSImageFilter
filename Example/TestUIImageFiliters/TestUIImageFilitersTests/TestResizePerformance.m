//
//  TestResizePerformance.m
//  TestUIImageFiliters
//
//  Created by Yu Sugawara on 2014/03/28.
//  Copyright (c) 2014年 Yu Sugawara. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "Utility.h"
#import <YSProcessTimer/YSProcessTimer.h>
#import <NSRunLoop+PerformBlock/NSRunLoop+PerformBlock.h>

#import "UIImage+YSImageFilter.h"
#import "ImageFilter.h"

@interface TestResizePerformance : XCTestCase

@end

@implementation TestResizePerformance

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

- (void)testAllAverageWithImage1000x1000to300x300
{
    [self allAverageWithSourceImageSize:CGSizeMake(1000.f, 1000.f) resizeSize:CGSizeMake(300.f, 300.f) trimToFit:NO];
}

- (void)testAllAverageTrimToFitWithImage1000x1000to300x300
{
    [self allAverageWithSourceImageSize:CGSizeMake(1000.f, 1000.f) resizeSize:CGSizeMake(300.f, 300.f) trimToFit:YES];
}

- (void)testAllAverageWithImage1000x1000To50x50
{
    [self allAverageWithSourceImageSize:CGSizeMake(1000.f, 1000.f) resizeSize:CGSizeMake(50.f, 50.f) trimToFit:NO];
}

- (void)testAllAverageTrimToFitWithImage1000x1000To50x50
{
    [self allAverageWithSourceImageSize:CGSizeMake(1000.f, 1000.f) resizeSize:CGSizeMake(50.f, 50.f) trimToFit:YES];
}

- (void)allAverageWithSourceImageSize:(CGSize)sourceImageSize resizeSize:(CGSize)resizeSize trimToFit:(BOOL)trimToFit
{
    [self allAverageWithSourceImageName:@"SolidColor"
                                  image:[Utility solidColorImageWithSize:sourceImageSize]
                             resizeSize:resizeSize
                              trimToFit:trimToFit];
    
    
    [self allAverageWithSourceImageName:@"Cat"
                                  image:[Utility catImageWithSize:sourceImageSize]
                             resizeSize:resizeSize
                              trimToFit:trimToFit];
}

#pragma mark - cpu busy

#if 0
- (void)testCPUBusy
{
    [self enumeratePrimeInBackground:10];
    [NSThread sleepForTimeInterval:3.0];
    [self testAllAverageTrimToFitWithImage1000x1000To50x50];
}

- (void)enumeratePrimeInBackground:(NSUInteger)threadNum
{
    for (NSUInteger thread = 0; thread < threadNum; thread++) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
            for (NSUInteger i = 2; i < NSUIntegerMax; i++) {
                BOOL isPrime = [self searchPrime:i];
                if (isPrime) {
//                    NSLog(@"prime %@", @(i));
                }
            }
        });
    }
}

- (BOOL)searchPrime:(NSUInteger)num
{
    for(NSUInteger i = 2; i*i <= num; i++){
        if(num%i == 0){
            return NO;
        }
    }
    return YES;
}
#endif

#pragma mark - average

- (void)allAverageWithSourceImageName:(NSString*)sourceImageName image:(UIImage*)sourceImage resizeSize:(CGSize)resizeSize trimToFit:(BOOL)trimToFit
{
    /* Idling */
    // CoreGraphics
    YSImageFilter *filter = [[YSImageFilter alloc] init];
    filter.size = resizeSize;
    filter.quality = kCGInterpolationNone;
    filter.trimToFit = trimToFit;
    filter.mask = YSImageFilterMaskNone;
    
    [sourceImage ys_filter:filter];
    
    filter.quality = kCGInterpolationLow;
    [sourceImage ys_filter:filter];
    
    filter.quality = kCGInterpolationMedium;
    [sourceImage ys_filter:filter];
    
    filter.quality = kCGInterpolationHigh;
    [sourceImage ys_filter:filter];
    
    // NYXImagesKit
    [ImageFilter resizeInNYXImagesKitWithImage:sourceImage size:resizeSize trimToFit:trimToFit];
    
    // GPUImage
    [ImageFilter resizeInGPUImageWithImage:sourceImage size:resizeSize trimToFit:trimToFit];
    
    // CoreImage
    [ImageFilter resizeInCoreImageWithImage:sourceImage size:resizeSize useGPU:NO trimToFit:trimToFit];
    [ImageFilter resizeInCoreImageWithImage:sourceImage size:resizeSize useGPU:YES trimToFit:trimToFit];
    
    NSTimeInterval coreGraphicsTimeNone = [self averageCoreGraphicsWithImage:sourceImage size:resizeSize quality:kCGInterpolationNone trimToFit:trimToFit];
    NSTimeInterval coreGraphicsTimeLow = [self averageCoreGraphicsWithImage:sourceImage size:resizeSize quality:kCGInterpolationLow trimToFit:trimToFit];
    NSTimeInterval coreGraphicsTimeMedium = [self averageCoreGraphicsWithImage:sourceImage size:resizeSize quality:kCGInterpolationMedium trimToFit:trimToFit];
    NSTimeInterval coreGraphicsTimeHigh = [self averageCoreGraphicsWithImage:sourceImage size:resizeSize quality:kCGInterpolationHigh trimToFit:trimToFit];
    NSTimeInterval NYXImagesKitTime = [self averageNYXImagesKitWithImage:sourceImage size:resizeSize trimToFit:trimToFit];
    NSTimeInterval GPUImageTime = [self averageGPUImageWithImage:sourceImage size:resizeSize trimToFit:trimToFit];
    NSTimeInterval ciImageTimeCPU = [self averageCoreImageWithImage:sourceImage size:resizeSize useGPU:NO trimToFit:trimToFit];
    NSTimeInterval ciImageTimeGPU = [self averageCoreImageWithImage:sourceImage size:resizeSize useGPU:YES trimToFit:trimToFit];

    NSLog(@"\n\n\
name: %@, sourceImage.size: %@, resizeSize: %@, trimToFit: %@, numberOfTrials: %@\n\
CoreGraphics(None) %f (%@ FPS)\n\
CoreGraphics(Low) %f (%@ FPS)\n\
CoreGraphics(Mid) %f (%@ FPS)\n\
CoreGraphics(High) %f (%@ FPS)\n\
NYXImagesKit %f (%@ FPS)\n\
GPUImage %f (%@ FPS)\n\
CoreImage(CPU) %f (%@ FPS)\n\
CoreImage(GPU) %f (%@ FPS)\n\n",
          sourceImageName,
          NSStringFromCGSize(sourceImage.size),
          NSStringFromCGSize(resizeSize),
          trimToFit ? @"YES" : @"NO",
          @(kNumberOfTrials),
          coreGraphicsTimeNone,
          @(((int)(1/coreGraphicsTimeNone))),
          coreGraphicsTimeLow,
          @(((int)(1/coreGraphicsTimeLow))),
          coreGraphicsTimeMedium,
          @(((int)(1/coreGraphicsTimeMedium))),
          coreGraphicsTimeHigh,
          @(((int)(1/coreGraphicsTimeHigh))),
          NYXImagesKitTime,
          @(((int)(1/NYXImagesKitTime))),
          GPUImageTime,
          @(((int)(1/GPUImageTime))),
          ciImageTimeCPU,
          @(((int)(1/ciImageTimeCPU))),
          ciImageTimeGPU,
          @(((int)(1/ciImageTimeGPU))));
}

#pragma mark - average

- (NSTimeInterval)averageCoreGraphicsWithImage:(UIImage*)image size:(CGSize)size quality:(CGInterpolationQuality)quality trimToFit:(BOOL)trimToFit
{
    NSString *qualityStr;
    switch (quality) {
        case kCGInterpolationNone:
            qualityStr = @"None";
            break;
        case kCGInterpolationLow:
            qualityStr = @"Low";
            break;
        case kCGInterpolationMedium:
            qualityStr = @"Medium";
            break;
        case kCGInterpolationHigh:
            qualityStr = @"High";
            break;
        case kCGInterpolationDefault:
            qualityStr = @"Default";
            break;
        default:
            qualityStr = @"Unknown";
            break;
    }
    NSString *name = [NSString stringWithFormat:@"average CoreGraphics(%@), resize: %@", qualityStr, NSStringFromCGSize(size)];
    return [YSProcessTimer startAverageWithProcessName:name numberOfTrials:kNumberOfTrials process:^{
        YSImageFilter *filter = [[YSImageFilter alloc] init];
        filter.size = size;
        filter.quality = quality;
        filter.trimToFit = trimToFit;
        
        [image ys_filter:filter];
    }];
}

- (NSTimeInterval)averageNYXImagesKitWithImage:(UIImage*)image size:(CGSize)size trimToFit:(BOOL)trimToFit
{
    return [YSProcessTimer startAverageWithProcessName:@"average NYXImagesKit" numberOfTrials:kNumberOfTrials process:^{
        [ImageFilter resizeInNYXImagesKitWithImage:image size:size trimToFit:trimToFit];
    }];
}

- (NSTimeInterval)averageGPUImageWithImage:(UIImage*)image size:(CGSize)size trimToFit:(BOOL)trimToFit
{
    return [YSProcessTimer startAverageWithProcessName:@"average GPUImage" numberOfTrials:kNumberOfTrials process:^{
        [ImageFilter resizeInGPUImageWithImage:image size:size trimToFit:trimToFit];
    }];
}

- (NSTimeInterval)averageCoreImageWithImage:(UIImage*)image size:(CGSize)size useGPU:(BOOL)useGPU trimToFit:(BOOL)trimToFit
{
    return [YSProcessTimer startAverageWithProcessName:@"average GPUImage" numberOfTrials:kNumberOfTrials process:^{
        [ImageFilter resizeInCoreImageWithImage:image size:size useGPU:useGPU trimToFit:trimToFit];
    }];
}

@end
