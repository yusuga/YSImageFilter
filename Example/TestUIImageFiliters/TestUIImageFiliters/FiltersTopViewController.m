//
//  FilterTopViewController.m
//  TestUIImageFiliters
//
//  Created by Yu Sugawara on 2014/03/27.
//  Copyright (c) 2014年 Yu Sugawara. All rights reserved.
//

#import "FiltersTopViewController.h"
#import "FiltersViewController.h"

@implementation FiltersTopViewController

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    FiltersViewController *vc = (id)segue.destinationViewController;    
    if ([vc isKindOfClass:[FiltersViewController class]]) {
        vc.targetImageView = self.targetImageView;
    }
}

@end
