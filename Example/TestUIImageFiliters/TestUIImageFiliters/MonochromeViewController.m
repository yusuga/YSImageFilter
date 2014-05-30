//
//  MonochromeViewController.m
//  TestUIImageFiliters
//
//  Created by Yu Sugawara on 2014/05/30.
//  Copyright (c) 2014年 Yu Sugawara. All rights reserved.
//

#import "MonochromeViewController.h"

@interface MonochromeViewController ()

@end

@implementation MonochromeViewController

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [super tableView:tableView didSelectRowAtIndexPath:indexPath];
    
    NSString *processName;
    UIColor *color;
    switch (indexPath.row) {
        case 0:
            processName = @"white 0.75";
            color = [UIColor colorWithWhite:0.75f alpha:1.f];
            break;
        case 1:
            processName = @"white 0.25";
            color = [UIColor colorWithWhite:0.25f alpha:1.f];
            break;
        case 2:
            processName = @"red";
            color = [UIColor redColor];
            break;
        case 3:
            processName = @"blue";
            color = [UIColor blueColor];
            break;
        default:
            abort();
            break;
    }
    
    [self setImageWithProcessName:processName
                             size:self.sourceImage.size
                          process:^UIImage *(UIImage *sourceImage, CGSize size) {
                              return [YSImageFilter monochromeImageWithImage:sourceImage color:color intensity:1.f];
                          }];
}

@end
