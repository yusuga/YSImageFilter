//
//  FiltersViewController.m
//  TestUIImageFiliters
//
//  Created by Yu Sugawara on 2014/03/26.
//  Copyright (c) 2014年 Yu Sugawara. All rights reserved.
//

#import "FiltersViewController.h"
#import "ResizeViewController.h"
#import <YSUIKitAdditions/UIImage+YSUIKitAdditions.h>

@interface FiltersViewController ()

@end

@implementation FiltersViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.sourceImage = [UIImage imageNamed:@"cat"];
}

- (void)clearImageView
{
    self.targetImageView.image = nil;
}

- (void)setImageWithProcessName:(NSString *)processName size:(CGSize)size process:(SetImageProcess)process
{    
    __block UIImage *img;
    [YSProcessTimer startWithProcessName:processName process:^{
        if (process) {
            img = process(self.sourceImage, size);
        }
    }];
    NSLog(@"processed image size: %@", NSStringFromCGSize(img.size));
    self.targetImageView.image = img;
}

@end
