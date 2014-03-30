//
//  TestSepia.m
//  TestUIImageFiliters
//
//  Created by Yu Sugawara on 2014/03/29.
//  Copyright (c) 2014年 Yu Sugawara. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "Utility.h"
#import "YSImageFilter.h"
#import "ImageFilter.h"

@interface TestSepia : XCTestCase

@end

@implementation TestSepia

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

- (void)testSepiaInCoreImage
{
    UIImage *cat500x500 = [Utility catImage500x500];
    CGSize size500x500 = CGSizeMake(500.f, 500.f);
    UIImage *cat50x50 = [Utility catImage50x50];
    CGSize size50x50 = CGSizeMake(50.f, 50.f);
    
    XCTAssertTrue([Utility validateImage:[ImageFilter sepiaInCoreImageWithImage:cat500x500 intensity:1.f useGPU:NO] estimatedSize:size500x500]);
    XCTAssertTrue([Utility validateImage:[ImageFilter sepiaInCoreImageWithImage:cat50x50 intensity:1.f useGPU:NO] estimatedSize:size50x50]);
    
    XCTAssertTrue([Utility validateImage:[ImageFilter sepiaInCoreImageWithImage:cat500x500 intensity:1.f useGPU:YES] estimatedSize:size500x500]);
    XCTAssertTrue([Utility validateImage:[ImageFilter sepiaInCoreImageWithImage:cat50x50 intensity:1.f useGPU:YES] estimatedSize:size50x50]);
}

- (void)testSepiaInNYXImagesKit
{
//    XCTAssertTrue([Utility validateImage:[ImageFilter sepiaInNYXImagesKitWithImage:self.image] estimatedSize:self.size]);
}

- (void)testSepiaInGPUImage
{
//    XCTAssertTrue([Utility validateImage:[ImageFilter sepiaInGPUImageWithImage:self.image] estimatedSize:self.size]);
}

@end
