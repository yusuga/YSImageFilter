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

- (void)testValidateImage
{
    CGSize size = CGSizeMake(100.f, 100.f);
    XCTAssertFalse([Utility validateImage:nil estimatedSize:size]);
    XCTAssertTrue([Utility validateImage:[Utility solidColorImageWithSize:size] estimatedSize:size]);
    XCTAssertFalse([Utility validateImage:[Utility solidColorImageWithSize:size] estimatedSize:CGSizeMake(50.f, 50.f)]);
}

- (void)testSolidColorImageSize
{
    CGSize size = CGSizeMake(100.f, 100.f);
    XCTAssertTrue([Utility validateImage:[Utility solidColorImageWithSize:size] estimatedSize:size]);
}

- (void)testSolidColorImageScale
{
    XCTAssertTrue([Utility validateImageScaleWithImage:[Utility solidColorImageWithSize:CGSizeMake(100.f, 100.f)]]);
}

- (void)testCatImageSize
{
    CGSize size = CGSizeMake(100.f, 100.f);
    XCTAssertTrue([Utility validateImage:[Utility catImageWithSize:size] estimatedSize:size]);
}

- (void)testCatImageScale
{
    XCTAssertTrue([Utility validateImageScaleWithImage:[Utility catImageWithSize:CGSizeMake(100.f, 100.f)]]);
}

@end
