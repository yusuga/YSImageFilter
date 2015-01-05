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

#pragma mark - CoreGraphics
#pragma mark None - 50x50

- (void)testCoreGraphicsWithQualityNoneWithSolidColorImage1000x1000to50x50
{
    [self imageAndFilterInCoreGraphicsWithImageType:ImageTypeSolidColor sourceSize:1000.f quality:kCGInterpolationNone resize:50.f trimToFit:NO completion:^(UIImage *image, YSImageFilter *filter) {
        [self measureMetrics:[XCTestCase defaultPerformanceMetrics] automaticallyStartMeasuring:NO forBlock:^{
            [self startMeasuring];
            [image ys_filter:filter];
            [self stopMeasuring];
        }];
    }];
}

- (void)testCoreGraphicsWithQualityNoneWithCatImage1000x1000to50x50
{
    [self imageAndFilterInCoreGraphicsWithImageType:ImageTypeCat sourceSize:1000.f quality:kCGInterpolationNone resize:50.f trimToFit:NO completion:^(UIImage *image, YSImageFilter *filter) {
        [self measureMetrics:[XCTestCase defaultPerformanceMetrics] automaticallyStartMeasuring:NO forBlock:^{
            [self startMeasuring];
            [image ys_filter:filter];
            [self stopMeasuring];
        }];
    }];
}

- (void)testCoreGraphicsWithQualityNoneAndTrimToFitWithSolidColorImage1000x1000to50x50
{
    [self imageAndFilterInCoreGraphicsWithImageType:ImageTypeSolidColor sourceSize:1000.f quality:kCGInterpolationNone resize:50.f trimToFit:YES completion:^(UIImage *image, YSImageFilter *filter) {
        [self measureMetrics:[XCTestCase defaultPerformanceMetrics] automaticallyStartMeasuring:NO forBlock:^{
            [self startMeasuring];
            [image ys_filter:filter];
            [self stopMeasuring];
        }];
    }];
}

- (void)testCoreGraphicsWithQualityNoneAndTrimToFitWithCatImage1000x1000to50x50
{
    [self imageAndFilterInCoreGraphicsWithImageType:ImageTypeCat sourceSize:1000.f quality:kCGInterpolationNone resize:50.f trimToFit:YES completion:^(UIImage *image, YSImageFilter *filter) {
        [self measureMetrics:[XCTestCase defaultPerformanceMetrics] automaticallyStartMeasuring:NO forBlock:^{
            [self startMeasuring];
            [image ys_filter:filter];
            [self stopMeasuring];
        }];
    }];
}

#pragma mark None - 300x300

- (void)testCoreGraphicsWithQualityNoneWithSolidColorImage1000x1000to300x300
{
    [self imageAndFilterInCoreGraphicsWithImageType:ImageTypeSolidColor sourceSize:1000.f quality:kCGInterpolationNone resize:300.f trimToFit:NO completion:^(UIImage *image, YSImageFilter *filter) {
        [self measureMetrics:[XCTestCase defaultPerformanceMetrics] automaticallyStartMeasuring:NO forBlock:^{
            [self startMeasuring];
            [image ys_filter:filter];
            [self stopMeasuring];
        }];
    }];
}

- (void)testCoreGraphicsWithQualityNoneWithCatImage1000x1000to300x300
{
    [self imageAndFilterInCoreGraphicsWithImageType:ImageTypeCat sourceSize:1000.f quality:kCGInterpolationNone resize:300.f trimToFit:NO completion:^(UIImage *image, YSImageFilter *filter) {
        [self measureMetrics:[XCTestCase defaultPerformanceMetrics] automaticallyStartMeasuring:NO forBlock:^{
            [self startMeasuring];
            [image ys_filter:filter];
            [self stopMeasuring];
        }];
    }];
}

- (void)testCoreGraphicsWithQualityNoneAndTrimToFitWithSolidColorImage1000x1000to300x300
{
    [self imageAndFilterInCoreGraphicsWithImageType:ImageTypeSolidColor sourceSize:1000.f quality:kCGInterpolationNone resize:300.f trimToFit:YES completion:^(UIImage *image, YSImageFilter *filter) {
        [self measureMetrics:[XCTestCase defaultPerformanceMetrics] automaticallyStartMeasuring:NO forBlock:^{
            [self startMeasuring];
            [image ys_filter:filter];
            [self stopMeasuring];
        }];
    }];
}

- (void)testCoreGraphicsWithQualityNoneAndTrimToFitWithCatImage1000x1000to300x300
{
    [self imageAndFilterInCoreGraphicsWithImageType:ImageTypeCat sourceSize:1000.f quality:kCGInterpolationNone resize:300.f trimToFit:YES completion:^(UIImage *image, YSImageFilter *filter) {
        [self measureMetrics:[XCTestCase defaultPerformanceMetrics] automaticallyStartMeasuring:NO forBlock:^{
            [self startMeasuring];
            [image ys_filter:filter];
            [self stopMeasuring];
        }];
    }];
}

#pragma mark Low - 50x50

- (void)testCoreGraphicsWithQualityLowWithSolidColorImage1000x1000to50x50
{
    [self imageAndFilterInCoreGraphicsWithImageType:ImageTypeSolidColor sourceSize:1000.f quality:kCGInterpolationLow resize:50.f trimToFit:NO completion:^(UIImage *image, YSImageFilter *filter) {
        [self measureMetrics:[XCTestCase defaultPerformanceMetrics] automaticallyStartMeasuring:NO forBlock:^{
            [self startMeasuring];
            [image ys_filter:filter];
            [self stopMeasuring];
        }];
    }];
}

- (void)testCoreGraphicsWithQualityLowWithCatImage1000x1000to50x50
{
    [self imageAndFilterInCoreGraphicsWithImageType:ImageTypeCat sourceSize:1000.f quality:kCGInterpolationLow resize:50.f trimToFit:NO completion:^(UIImage *image, YSImageFilter *filter) {
        [self measureMetrics:[XCTestCase defaultPerformanceMetrics] automaticallyStartMeasuring:NO forBlock:^{
            [self startMeasuring];
            [image ys_filter:filter];
            [self stopMeasuring];
        }];
    }];
}

- (void)testCoreGraphicsWithQualityLowAndTrimToFitWithSolidColorImage1000x1000to50x50
{
    [self imageAndFilterInCoreGraphicsWithImageType:ImageTypeSolidColor sourceSize:1000.f quality:kCGInterpolationLow resize:50.f trimToFit:YES completion:^(UIImage *image, YSImageFilter *filter) {
        [self measureMetrics:[XCTestCase defaultPerformanceMetrics] automaticallyStartMeasuring:NO forBlock:^{
            [self startMeasuring];
            [image ys_filter:filter];
            [self stopMeasuring];
        }];
    }];
}

- (void)testCoreGraphicsWithQualityLowAndTrimToFitWithCatImage1000x1000to50x50
{
    [self imageAndFilterInCoreGraphicsWithImageType:ImageTypeCat sourceSize:1000.f quality:kCGInterpolationLow resize:50.f trimToFit:YES completion:^(UIImage *image, YSImageFilter *filter) {
        [self measureMetrics:[XCTestCase defaultPerformanceMetrics] automaticallyStartMeasuring:NO forBlock:^{
            [self startMeasuring];
            [image ys_filter:filter];
            [self stopMeasuring];
        }];
    }];
}

#pragma mark Low - 300x300

- (void)testCoreGraphicsWithQualityLowWithSolidColorImage1000x1000to300x300
{
    [self imageAndFilterInCoreGraphicsWithImageType:ImageTypeSolidColor sourceSize:1000.f quality:kCGInterpolationLow resize:300.f trimToFit:NO completion:^(UIImage *image, YSImageFilter *filter) {
        [self measureMetrics:[XCTestCase defaultPerformanceMetrics] automaticallyStartMeasuring:NO forBlock:^{
            [self startMeasuring];
            [image ys_filter:filter];
            [self stopMeasuring];
        }];
    }];
}

- (void)testCoreGraphicsWithQualityLowWithCatImage1000x1000to300x300
{
    [self imageAndFilterInCoreGraphicsWithImageType:ImageTypeCat sourceSize:1000.f quality:kCGInterpolationLow resize:300.f trimToFit:NO completion:^(UIImage *image, YSImageFilter *filter) {
        [self measureMetrics:[XCTestCase defaultPerformanceMetrics] automaticallyStartMeasuring:NO forBlock:^{
            [self startMeasuring];
            [image ys_filter:filter];
            [self stopMeasuring];
        }];
    }];
}

- (void)testCoreGraphicsWithQualityLowAndTrimToFitWithSolidColorImage1000x1000to300x300
{
    [self imageAndFilterInCoreGraphicsWithImageType:ImageTypeSolidColor sourceSize:1000.f quality:kCGInterpolationLow resize:300.f trimToFit:YES completion:^(UIImage *image, YSImageFilter *filter) {
        [self measureMetrics:[XCTestCase defaultPerformanceMetrics] automaticallyStartMeasuring:NO forBlock:^{
            [self startMeasuring];
            [image ys_filter:filter];
            [self stopMeasuring];
        }];
    }];
}

- (void)testCoreGraphicsWithQualityLowAndTrimToFitWithCatImage1000x1000to300x300
{
    [self imageAndFilterInCoreGraphicsWithImageType:ImageTypeCat sourceSize:1000.f quality:kCGInterpolationLow resize:300.f trimToFit:YES completion:^(UIImage *image, YSImageFilter *filter) {
        [self measureMetrics:[XCTestCase defaultPerformanceMetrics] automaticallyStartMeasuring:NO forBlock:^{
            [self startMeasuring];
            [image ys_filter:filter];
            [self stopMeasuring];
        }];
    }];
}

#pragma mark Medium - 50x50

- (void)testCoreGraphicsWithQualityMediumWithSolidColorImage1000x1000to50x50
{
    [self imageAndFilterInCoreGraphicsWithImageType:ImageTypeSolidColor sourceSize:1000.f quality:kCGInterpolationMedium resize:50.f trimToFit:NO completion:^(UIImage *image, YSImageFilter *filter) {
        [self measureMetrics:[XCTestCase defaultPerformanceMetrics] automaticallyStartMeasuring:NO forBlock:^{
            [self startMeasuring];
            [image ys_filter:filter];
            [self stopMeasuring];
        }];
    }];
}

- (void)testCoreGraphicsWithQualityMediumWithCatImage1000x1000to50x50
{
    [self imageAndFilterInCoreGraphicsWithImageType:ImageTypeCat sourceSize:1000.f quality:kCGInterpolationMedium resize:50.f trimToFit:NO completion:^(UIImage *image, YSImageFilter *filter) {
        [self measureMetrics:[XCTestCase defaultPerformanceMetrics] automaticallyStartMeasuring:NO forBlock:^{
            [self startMeasuring];
            [image ys_filter:filter];
            [self stopMeasuring];
        }];
    }];
}

- (void)testCoreGraphicsWithQualityMediumAndTrimToFitWithSolidColorImage1000x1000to50x50
{
    [self imageAndFilterInCoreGraphicsWithImageType:ImageTypeSolidColor sourceSize:1000.f quality:kCGInterpolationMedium resize:50.f trimToFit:YES completion:^(UIImage *image, YSImageFilter *filter) {
        [self measureMetrics:[XCTestCase defaultPerformanceMetrics] automaticallyStartMeasuring:NO forBlock:^{
            [self startMeasuring];
            [image ys_filter:filter];
            [self stopMeasuring];
        }];
    }];
}

- (void)testCoreGraphicsWithQualityMediumAndTrimToFitWithCatImage1000x1000to50x50
{
    [self imageAndFilterInCoreGraphicsWithImageType:ImageTypeCat sourceSize:1000.f quality:kCGInterpolationMedium resize:50.f trimToFit:YES completion:^(UIImage *image, YSImageFilter *filter) {
        [self measureMetrics:[XCTestCase defaultPerformanceMetrics] automaticallyStartMeasuring:NO forBlock:^{
            [self startMeasuring];
            [image ys_filter:filter];
            [self stopMeasuring];
        }];
    }];
}

#pragma mark Medium - 300x300

- (void)testCoreGraphicsWithQualityMediumWithSolidColorImage1000x1000to300x300
{
    [self imageAndFilterInCoreGraphicsWithImageType:ImageTypeSolidColor sourceSize:1000.f quality:kCGInterpolationMedium resize:300.f trimToFit:NO completion:^(UIImage *image, YSImageFilter *filter) {
        [self measureMetrics:[XCTestCase defaultPerformanceMetrics] automaticallyStartMeasuring:NO forBlock:^{
            [self startMeasuring];
            [image ys_filter:filter];
            [self stopMeasuring];
        }];
    }];
}

- (void)testCoreGraphicsWithQualityMediumWithCatImage1000x1000to300x300
{
    [self imageAndFilterInCoreGraphicsWithImageType:ImageTypeCat sourceSize:1000.f quality:kCGInterpolationMedium resize:300.f trimToFit:NO completion:^(UIImage *image, YSImageFilter *filter) {
        [self measureMetrics:[XCTestCase defaultPerformanceMetrics] automaticallyStartMeasuring:NO forBlock:^{
            [self startMeasuring];
            [image ys_filter:filter];
            [self stopMeasuring];
        }];
    }];
}

- (void)testCoreGraphicsWithQualityMediumAndTrimToFitWithSolidColorImage1000x1000to300x300
{
    [self imageAndFilterInCoreGraphicsWithImageType:ImageTypeSolidColor sourceSize:1000.f quality:kCGInterpolationMedium resize:300.f trimToFit:YES completion:^(UIImage *image, YSImageFilter *filter) {
        [self measureMetrics:[XCTestCase defaultPerformanceMetrics] automaticallyStartMeasuring:NO forBlock:^{
            [self startMeasuring];
            [image ys_filter:filter];
            [self stopMeasuring];
        }];
    }];
}

- (void)testCoreGraphicsWithQualityMediumAndTrimToFitWithCatImage1000x1000to300x300
{
    [self imageAndFilterInCoreGraphicsWithImageType:ImageTypeCat sourceSize:1000.f quality:kCGInterpolationMedium resize:300.f trimToFit:YES completion:^(UIImage *image, YSImageFilter *filter) {
        [self measureMetrics:[XCTestCase defaultPerformanceMetrics] automaticallyStartMeasuring:NO forBlock:^{
            [self startMeasuring];
            [image ys_filter:filter];
            [self stopMeasuring];
        }];
    }];
}

#pragma mark High - 50x50

- (void)testCoreGraphicsWithQualityHighWithSolidColorImage1000x1000to50x50
{
    [self imageAndFilterInCoreGraphicsWithImageType:ImageTypeSolidColor sourceSize:1000.f quality:kCGInterpolationHigh resize:50.f trimToFit:NO completion:^(UIImage *image, YSImageFilter *filter) {
        [self measureMetrics:[XCTestCase defaultPerformanceMetrics] automaticallyStartMeasuring:NO forBlock:^{
            [self startMeasuring];
            [image ys_filter:filter];
            [self stopMeasuring];
        }];
    }];
}

- (void)testCoreGraphicsWithQualityHighWithCatImage1000x1000to50x50
{
    [self imageAndFilterInCoreGraphicsWithImageType:ImageTypeCat sourceSize:1000.f quality:kCGInterpolationHigh resize:50.f trimToFit:NO completion:^(UIImage *image, YSImageFilter *filter) {
        [self measureMetrics:[XCTestCase defaultPerformanceMetrics] automaticallyStartMeasuring:NO forBlock:^{
            [self startMeasuring];
            [image ys_filter:filter];
            [self stopMeasuring];
        }];
    }];
}

- (void)testCoreGraphicsWithQualityHighAndTrimToFitWithSolidColorImage1000x1000to50x50
{
    [self imageAndFilterInCoreGraphicsWithImageType:ImageTypeSolidColor sourceSize:1000.f quality:kCGInterpolationHigh resize:50.f trimToFit:YES completion:^(UIImage *image, YSImageFilter *filter) {
        [self measureMetrics:[XCTestCase defaultPerformanceMetrics] automaticallyStartMeasuring:NO forBlock:^{
            [self startMeasuring];
            [image ys_filter:filter];
            [self stopMeasuring];
        }];
    }];
}

- (void)testCoreGraphicsWithQualityHighAndTrimToFitWithCatImage1000x1000to50x50
{
    [self imageAndFilterInCoreGraphicsWithImageType:ImageTypeCat sourceSize:1000.f quality:kCGInterpolationHigh resize:50.f trimToFit:YES completion:^(UIImage *image, YSImageFilter *filter) {
        [self measureMetrics:[XCTestCase defaultPerformanceMetrics] automaticallyStartMeasuring:NO forBlock:^{
            [self startMeasuring];
            [image ys_filter:filter];
            [self stopMeasuring];
        }];
    }];
}

#pragma mark High - 300x300

- (void)testCoreGraphicsWithQualityHighWithSolidColorImage1000x1000to300x300
{
    [self imageAndFilterInCoreGraphicsWithImageType:ImageTypeSolidColor sourceSize:1000.f quality:kCGInterpolationHigh resize:300.f trimToFit:NO completion:^(UIImage *image, YSImageFilter *filter) {
        [self measureMetrics:[XCTestCase defaultPerformanceMetrics] automaticallyStartMeasuring:NO forBlock:^{
            [self startMeasuring];
            [image ys_filter:filter];
            [self stopMeasuring];
        }];
    }];
}

- (void)testCoreGraphicsWithQualityHighWithCatImage1000x1000to300x300
{
    [self imageAndFilterInCoreGraphicsWithImageType:ImageTypeCat sourceSize:1000.f quality:kCGInterpolationHigh resize:300.f trimToFit:NO completion:^(UIImage *image, YSImageFilter *filter) {
        [self measureMetrics:[XCTestCase defaultPerformanceMetrics] automaticallyStartMeasuring:NO forBlock:^{
            [self startMeasuring];
            [image ys_filter:filter];
            [self stopMeasuring];
        }];
    }];
}

- (void)testCoreGraphicsWithQualityHighAndTrimToFitWithSolidColorImage1000x1000to300x300
{
    [self imageAndFilterInCoreGraphicsWithImageType:ImageTypeSolidColor sourceSize:1000.f quality:kCGInterpolationHigh resize:300.f trimToFit:YES completion:^(UIImage *image, YSImageFilter *filter) {
        [self measureMetrics:[XCTestCase defaultPerformanceMetrics] automaticallyStartMeasuring:NO forBlock:^{
            [self startMeasuring];
            [image ys_filter:filter];
            [self stopMeasuring];
        }];
    }];
}

- (void)testCoreGraphicsWithQualityHighAndTrimToFitWithCatImage1000x1000to300x300
{
    [self imageAndFilterInCoreGraphicsWithImageType:ImageTypeCat sourceSize:1000.f quality:kCGInterpolationHigh resize:300.f trimToFit:YES completion:^(UIImage *image, YSImageFilter *filter) {
        [self measureMetrics:[XCTestCase defaultPerformanceMetrics] automaticallyStartMeasuring:NO forBlock:^{
            [self startMeasuring];
            [image ys_filter:filter];
            [self stopMeasuring];
        }];
    }];
}

#pragma mark - CoreImage
#pragma mark CPU

- (void)testCoreImageWithSolidColorImage1000x1000to50x50
{
    CGSize resize = CGSizeMake(50.f, 50.f);
    BOOL trimToFit = NO;
    BOOL useGPU = NO;
    
    [self imageInCoreImageWithImageType:ImageTypeSolidColor sourceSize:1000.f resize:resize trimToFit:trimToFit useGPU:useGPU completion:^(UIImage *image) {
        [self measureMetrics:[XCTestCase defaultPerformanceMetrics] automaticallyStartMeasuring:NO forBlock:^{
            [self startMeasuring];
            [ImageFilter resizeInCoreImageWithImage:image size:resize useGPU:useGPU trimToFit:trimToFit];
            [self stopMeasuring];
        }];
    }];
}

- (void)testCoreImageWithCatImage1000x1000to50x50
{
    CGSize resize = CGSizeMake(50.f, 50.f);
    BOOL trimToFit = NO;
    BOOL useGPU = NO;
    
    [self imageInCoreImageWithImageType:ImageTypeCat sourceSize:1000.f resize:resize trimToFit:trimToFit useGPU:useGPU completion:^(UIImage *image) {
        [self measureMetrics:[XCTestCase defaultPerformanceMetrics] automaticallyStartMeasuring:NO forBlock:^{
            [self startMeasuring];
            [ImageFilter resizeInCoreImageWithImage:image size:resize useGPU:useGPU trimToFit:trimToFit];
            [self stopMeasuring];
        }];
    }];
}

- (void)testCoreImageWithTrimToFitWithSolidColorImage1000x1000to300x300
{
    CGSize resize = CGSizeMake(300.f, 300.f);
    BOOL trimToFit = NO;
    BOOL useGPU = NO;
    
    [self imageInCoreImageWithImageType:ImageTypeSolidColor sourceSize:1000.f resize:resize trimToFit:trimToFit useGPU:useGPU completion:^(UIImage *image) {
        [self measureMetrics:[XCTestCase defaultPerformanceMetrics] automaticallyStartMeasuring:NO forBlock:^{
            [self startMeasuring];
            [ImageFilter resizeInCoreImageWithImage:image size:resize useGPU:useGPU trimToFit:trimToFit];
            [self stopMeasuring];
        }];
    }];
}

- (void)testCoreImageWithTrimToFitWithCatImage1000x1000to300x300
{
    CGSize resize = CGSizeMake(300.f, 300.f);
    BOOL trimToFit = NO;
    BOOL useGPU = NO;
    
    [self imageInCoreImageWithImageType:ImageTypeCat sourceSize:1000.f resize:resize trimToFit:trimToFit useGPU:useGPU completion:^(UIImage *image) {
        [self measureMetrics:[XCTestCase defaultPerformanceMetrics] automaticallyStartMeasuring:NO forBlock:^{
            [self startMeasuring];
            [ImageFilter resizeInCoreImageWithImage:image size:resize useGPU:useGPU trimToFit:trimToFit];
            [self stopMeasuring];
        }];
    }];
}

#pragma mark GPU

- (void)testCoreImageWithUseGPUWithSolidColorImage1000x1000to50x50
{
    CGSize resize = CGSizeMake(50.f, 50.f);
    BOOL trimToFit = NO;
    BOOL useGPU = YES;
    
    [self imageInCoreImageWithImageType:ImageTypeSolidColor sourceSize:1000.f resize:resize trimToFit:trimToFit useGPU:useGPU completion:^(UIImage *image) {
        [self measureMetrics:[XCTestCase defaultPerformanceMetrics] automaticallyStartMeasuring:NO forBlock:^{
            [self startMeasuring];
            [ImageFilter resizeInCoreImageWithImage:image size:resize useGPU:useGPU trimToFit:trimToFit];
            [self stopMeasuring];
        }];
    }];
}

- (void)testCoreImageWithUseGPUWithCatImage1000x1000to50x50
{
    CGSize resize = CGSizeMake(50.f, 50.f);
    BOOL trimToFit = NO;
    BOOL useGPU = YES;
    
    [self imageInCoreImageWithImageType:ImageTypeCat sourceSize:1000.f resize:resize trimToFit:trimToFit useGPU:useGPU completion:^(UIImage *image) {
        [self measureMetrics:[XCTestCase defaultPerformanceMetrics] automaticallyStartMeasuring:NO forBlock:^{
            [self startMeasuring];
            [ImageFilter resizeInCoreImageWithImage:image size:resize useGPU:useGPU trimToFit:trimToFit];
            [self stopMeasuring];
        }];
    }];
}

- (void)testCoreImageWithUseGPUWithTrimToFitWithSolidColorImage1000x1000to300x300
{
    CGSize resize = CGSizeMake(300.f, 300.f);
    BOOL trimToFit = NO;
    BOOL useGPU = YES;
    
    [self imageInCoreImageWithImageType:ImageTypeSolidColor sourceSize:1000.f resize:resize trimToFit:trimToFit useGPU:useGPU completion:^(UIImage *image) {
        [self measureMetrics:[XCTestCase defaultPerformanceMetrics] automaticallyStartMeasuring:NO forBlock:^{
            [self startMeasuring];
            [ImageFilter resizeInCoreImageWithImage:image size:resize useGPU:useGPU trimToFit:trimToFit];
            [self stopMeasuring];
        }];
    }];
}

- (void)testCoreImageWithUseGPUWithTrimToFitWithCatImage1000x1000to300x300
{
    CGSize resize = CGSizeMake(300.f, 300.f);
    BOOL trimToFit = NO;
    BOOL useGPU = YES;
    
    [self imageInCoreImageWithImageType:ImageTypeCat sourceSize:1000.f resize:resize trimToFit:trimToFit useGPU:useGPU completion:^(UIImage *image) {
        [self measureMetrics:[XCTestCase defaultPerformanceMetrics] automaticallyStartMeasuring:NO forBlock:^{
            [self startMeasuring];
            [ImageFilter resizeInCoreImageWithImage:image size:resize useGPU:useGPU trimToFit:trimToFit];
            [self stopMeasuring];
        }];
    }];
}

#pragma mark - NYXImagesKit

- (void)testNYXImagesKitWithSolidColorImage1000x1000to50x50
{
    CGSize resize = CGSizeMake(50.f, 50.f);
    BOOL trimToFit = NO;
    
    [self imageInNYXImagesKitWithImageType:ImageTypeSolidColor sourceSize:1000.f resize:resize trimToFit:trimToFit completion:^(UIImage *image) {
        [self measureMetrics:[XCTestCase defaultPerformanceMetrics] automaticallyStartMeasuring:NO forBlock:^{
            [self startMeasuring];
            [ImageFilter resizeInNYXImagesKitWithImage:image size:resize trimToFit:trimToFit];
            [self stopMeasuring];
        }];
    }];
}

- (void)testNYXImagesKitWithCatImage1000x1000to50x50
{
    CGSize resize = CGSizeMake(50.f, 50.f);
    BOOL trimToFit = NO;
    
    [self imageInNYXImagesKitWithImageType:ImageTypeCat sourceSize:1000.f resize:resize trimToFit:trimToFit completion:^(UIImage *image) {
        [self measureMetrics:[XCTestCase defaultPerformanceMetrics] automaticallyStartMeasuring:NO forBlock:^{
            [self startMeasuring];
            [ImageFilter resizeInNYXImagesKitWithImage:image size:resize trimToFit:trimToFit];
            [self stopMeasuring];
        }];
    }];
}

- (void)testNYXImagesKitWithTrimToFitWithSolidColorImage1000x1000to300x300
{
    CGSize resize = CGSizeMake(300.f, 300.f);
    BOOL trimToFit = YES;
    
    [self imageInNYXImagesKitWithImageType:ImageTypeSolidColor sourceSize:1000.f resize:resize trimToFit:trimToFit completion:^(UIImage *image) {
        [self measureMetrics:[XCTestCase defaultPerformanceMetrics] automaticallyStartMeasuring:NO forBlock:^{
            [self startMeasuring];
            [ImageFilter resizeInNYXImagesKitWithImage:image size:resize trimToFit:trimToFit];
            [self stopMeasuring];
        }];
    }];
}

- (void)testNYXImagesKitWithTrimToFitWithCatImage1000x1000to300x300
{
    CGSize resize = CGSizeMake(300.f, 300.f);
    BOOL trimToFit = YES;
    
    [self imageInNYXImagesKitWithImageType:ImageTypeCat sourceSize:1000.f resize:resize trimToFit:trimToFit completion:^(UIImage *image) {
        [self measureMetrics:[XCTestCase defaultPerformanceMetrics] automaticallyStartMeasuring:NO forBlock:^{
            [self startMeasuring];
            [ImageFilter resizeInNYXImagesKitWithImage:image size:resize trimToFit:trimToFit];
            [self stopMeasuring];
        }];
    }];
}

#pragma mark - GPUImage

- (void)testGPUImageWithSolidColorImage1000x1000to50x50
{
    CGSize resize = CGSizeMake(50.f, 50.f);
    BOOL trimToFit = NO;
    
    [self imageInGPUImageWithImageType:ImageTypeSolidColor sourceSize:1000.f resize:resize trimToFit:trimToFit completion:^(UIImage *image) {
        [self measureMetrics:[XCTestCase defaultPerformanceMetrics] automaticallyStartMeasuring:NO forBlock:^{
            [self startMeasuring];
            [ImageFilter resizeInNYXImagesKitWithImage:image size:resize trimToFit:trimToFit];
            [self stopMeasuring];
        }];
    }];
}

- (void)testGPUImageWithCatImage1000x1000to50x50
{
    CGSize resize = CGSizeMake(50.f, 50.f);
    BOOL trimToFit = NO;
    
    [self imageInGPUImageWithImageType:ImageTypeCat sourceSize:1000.f resize:resize trimToFit:trimToFit completion:^(UIImage *image) {
        [self measureMetrics:[XCTestCase defaultPerformanceMetrics] automaticallyStartMeasuring:NO forBlock:^{
            [self startMeasuring];
            [ImageFilter resizeInNYXImagesKitWithImage:image size:resize trimToFit:trimToFit];
            [self stopMeasuring];
        }];
    }];
}

- (void)testGPUImageWithTrimToFitWithSolidColorImage1000x1000to300x300
{
    CGSize resize = CGSizeMake(300.f, 300.f);
    BOOL trimToFit = YES;
    
    [self imageInGPUImageWithImageType:ImageTypeSolidColor sourceSize:1000.f resize:resize trimToFit:trimToFit completion:^(UIImage *image) {
        [self measureMetrics:[XCTestCase defaultPerformanceMetrics] automaticallyStartMeasuring:NO forBlock:^{
            [self startMeasuring];
            [ImageFilter resizeInNYXImagesKitWithImage:image size:resize trimToFit:trimToFit];
            [self stopMeasuring];
        }];
    }];
}

- (void)testGPUImageWithTrimToFitWithCatImage1000x1000to300x300
{
    CGSize resize = CGSizeMake(300.f, 300.f);
    BOOL trimToFit = YES;
    
    [self imageInGPUImageWithImageType:ImageTypeCat sourceSize:1000.f resize:resize trimToFit:trimToFit completion:^(UIImage *image) {
        [self measureMetrics:[XCTestCase defaultPerformanceMetrics] automaticallyStartMeasuring:NO forBlock:^{
            [self startMeasuring];
            [ImageFilter resizeInNYXImagesKitWithImage:image size:resize trimToFit:trimToFit];
            [self stopMeasuring];
        }];
    }];
}


#pragma mark - Utility

- (void)imageAndFilterInCoreGraphicsWithImageType:(ImageType)imageType
                                       sourceSize:(CGFloat)sourceSize
                                          quality:(CGInterpolationQuality)quality
                                           resize:(CGFloat)resize
                                        trimToFit:(BOOL)trimToFit
                                       completion:(void(^)(UIImage *image, YSImageFilter *filter))completion
{
    UIImage *image = [Utility imageWithSize:CGSizeMake(sourceSize, sourceSize) type:imageType];
    
    YSImageFilter *filter = [[YSImageFilter alloc] init];
    filter.mask = YSImageFilterMaskNone;
    
    filter.quality = quality;
    filter.size = CGSizeMake(resize, resize);
    filter.trimToFit = trimToFit;
    
    // Idling
    [image ys_filter:filter];
    
    completion(image, filter);
}

- (void)imageInCoreImageWithImageType:(ImageType)imageType
                           sourceSize:(CGFloat)sourceSize
                               resize:(CGSize)resize
                            trimToFit:(BOOL)trimToFit
                               useGPU:(BOOL)useGPU
                           completion:(void(^)(UIImage *image))completion
{
    UIImage *image = [Utility imageWithSize:CGSizeMake(sourceSize, sourceSize) type:imageType];
    
    [ImageFilter resizeInCoreImageWithImage:image size:resize useGPU:useGPU trimToFit:trimToFit];
    
    completion(image);
}

- (void)imageInNYXImagesKitWithImageType:(ImageType)imageType
                              sourceSize:(CGFloat)sourceSize
                                  resize:(CGSize)resize
                               trimToFit:(BOOL)trimToFit
                              completion:(void(^)(UIImage *image))completion
{
    UIImage *image = [Utility imageWithSize:CGSizeMake(sourceSize, sourceSize) type:imageType];
    
    [ImageFilter resizeInNYXImagesKitWithImage:image size:resize trimToFit:trimToFit];
    
    completion(image);
}

- (void)imageInGPUImageWithImageType:(ImageType)imageType
                              sourceSize:(CGFloat)sourceSize
                                  resize:(CGSize)resize
                               trimToFit:(BOOL)trimToFit
                              completion:(void(^)(UIImage *image))completion
{
    UIImage *image = [Utility imageWithSize:CGSizeMake(sourceSize, sourceSize) type:imageType];
    
    [ImageFilter resizeInGPUImageWithImage:image size:resize trimToFit:trimToFit];
    
    completion(image);
}

@end
