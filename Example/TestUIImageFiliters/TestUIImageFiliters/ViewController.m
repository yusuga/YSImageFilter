//
//  ViewController.m
//  TestUIImageFiliters
//
//  Created by Yu Sugawara on 2014/03/26.
//  Copyright (c) 2014年 Yu Sugawara. All rights reserved.
//

#import "ViewController.h"
#import "FiltersTopViewController.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    for (id vc in self.childViewControllers) {
        if ([vc isKindOfClass:[UINavigationController class]]) {
            FiltersTopViewController *topVC = (id)((UINavigationController*)vc).topViewController;
            if ([topVC isKindOfClass:[FiltersTopViewController class]]) {
                topVC.targetImageView = self.imageView;
            }
        }
    }
}

- (IBAction)imageViewDidTap:(id)sender
{
    if (self.imageView.contentMode == UIViewContentModeScaleAspectFit) {
        self.imageView.contentMode = UIViewContentModeCenter;
    } else {
        self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    }
}

@end
