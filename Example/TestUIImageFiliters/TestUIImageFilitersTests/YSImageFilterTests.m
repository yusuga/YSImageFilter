//
//  YSImageFilterTests.m
//  TestUIImageFiliters
//
//  Created by Yu Sugawara on 2015/12/02.
//  Copyright © 2015年 Yu Sugawara. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "UIImage+YSImageFilter.h"

@interface YSImageFilterTests : XCTestCase

@end

@implementation YSImageFilterTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testHash
{
    YSImageFilter *(^createFilter)(void) = ^{
        YSImageFilter *filter = [[YSImageFilter alloc] init];
        filter.size = CGSizeMake(100., 100.);
        filter.maxResolution = 200.;
        filter.quality = kCGInterpolationHigh;
        filter.trimToFit = YES;
        
        filter.borderWidth = 3.;
        filter.borderColor = [UIColor darkGrayColor];
        
        filter.mask = YSImageFilterMaskCircle;
        filter.maskCornerRadius = 6.;
        
        filter.backgroundColor = [UIColor greenColor];
        
        return filter;
    };
    
    YSImageFilter *filter1 = createFilter();
    YSImageFilter *filter2 = createFilter();
    
    XCTAssertTrue([filter1 hasUniqueHash]);
    XCTAssertEqual(filter1.hash, filter2.hash);
    NSLog(@"%tu - %tu", filter1.hash, filter2.hash);
    XCTAssertEqual(filter1.hash, [[filter1 copy] hash]);    
}

@end
