//
//  TestUtility.m
//  TestUIImageFiliters
//
//  Created by Yu Sugawara on 2014/03/28.
//  Copyright (c) 2014年 Yu Sugawara. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "Utility.h"

@interface TestUtility : XCTestCase

@end

@implementation TestUtility

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

- (void)testImageSize
{
    CGSize size = CGSizeMake(50.f, 50.f);
    UIImage *img = [Utility imageWithSize:size];
    XCTAssertTrue(CGSizeEqualToSize(size, img.size), @"size: %@, img size: %@", NSStringFromCGSize(size), NSStringFromCGSize(img.size));
}

- (void)testImageScale
{
    XCTAssertTrue([Utility validateImageScaleWithImage:[Utility imageWithSize:CGSizeMake(50.f, 50.f)]]);
}

- (void)testValidateImage
{
    CGSize size = CGSizeMake(100.f, 100.f);
    XCTAssertFalse([Utility validateImage:nil estimatedSize:size]);
    XCTAssertTrue([Utility validateImage:[Utility imageWithSize:size] estimatedSize:size]);
    XCTAssertFalse([Utility validateImage:[Utility imageWithSize:size] estimatedSize:CGSizeMake(50.f, 50.f)]);
}

- (void)testCatImage
{
    UIImage *cat500x500 = [Utility catImage500x500];
    XCTAssertTrue([Utility validateImage:cat500x500 estimatedSize:CGSizeMake(500.f, 500.f)]);
    XCTAssertTrue([Utility validateImageScaleWithImage:cat500x500]);
    
    UIImage *cat50x50 = [Utility catImage50x50];
    XCTAssertTrue([Utility validateImage:cat50x50 estimatedSize:CGSizeMake(50.f, 50.f)]);
    XCTAssertTrue([Utility validateImageScaleWithImage:cat50x50]);
}

@end
