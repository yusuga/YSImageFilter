//
//  ExclusiveSelectionViewController.m
//  TestUIImageFiliters
//
//  Created by Yu Sugawara on 2014/03/31.
//  Copyright (c) 2014年 Yu Sugawara. All rights reserved.
//

#import "ExclusiveSelectionViewController.h"

@interface ExclusiveSelectionViewController ()

@end

@implementation ExclusiveSelectionViewController

- (void)setTargetImageView:(UIImageView *)targetImageView
{
    [super setTargetImageView:targetImageView];
    
    if (!self.isViewLoaded) {
        [self performSelector:@selector(view)];
    }
    
    if (self.disableExclusiveResize) {
        return;
    }
    
    YSImageFilter *filter = [[YSImageFilter alloc] init];
    filter.size = targetImageView.bounds.size;
    filter.quality = kCGInterpolationHigh;
    filter.trimToFit = YES;
    
    self.sourceImage = [self.sourceImage ys_filter:filter];    
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    cell.accessoryType = UITableViewCellAccessoryNone;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView reloadData];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryCheckmark;    
}

@end
