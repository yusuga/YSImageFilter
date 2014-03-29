//
//  FiltersViewController.h
//  TestUIImageFiliters
//
//  Created by Yu Sugawara on 2014/03/26.
//  Copyright (c) 2014年 Yu Sugawara. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ImageFilter.h"
#import "YSImageFilter.h"
#import "SelectView.h"

#import <YSProcessTimer/YSProcessTimer.h>

typedef UIImage*(^SetImageProcess)(UIImage *sourceImage, CGSize size);

@interface FiltersViewController : UITableViewController

@property (nonatomic) UIImage *sourceImage;

@property (weak, nonatomic) UIImageView *targetImageView;

- (void)setImageWithProcessName:(NSString*)processName process:(SetImageProcess)process size:(CGSize)size;

- (void)clearImageView;

@end
