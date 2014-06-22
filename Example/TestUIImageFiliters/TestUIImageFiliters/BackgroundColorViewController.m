//
//  BackgroundColorViewController.m
//  TestUIImageFiliters
//
//  Created by Yu Sugawara on 2014/06/22.
//  Copyright (c) 2014年 Yu Sugawara. All rights reserved.
//

#import "BackgroundColorViewController.h"
#import "ImageFilterStyleKit.h"

@interface BackgroundColorViewController ()

@property (strong, nonatomic) IBOutlet UIBarButtonItem *maskSwitchItem;
@property (strong, nonatomic) IBOutlet UILabel *maskLabel;

@property (weak, nonatomic) IBOutlet UISwitch *maskSwitch;

@end

@implementation BackgroundColorViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.rightBarButtonItems = @[self.maskSwitchItem, [[UIBarButtonItem alloc] initWithCustomView:self.maskLabel]];
    
    self.sourceImage = [ImageFilterStyleKit imageOfEarth];
    self.disableExclusiveResize = YES;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [super tableView:tableView didSelectRowAtIndexPath:indexPath];
    
    NSString *processName;
    UIColor *color;
    switch (indexPath.row) {
        case 0:
            processName = @"Red";
            color = [UIColor redColor];
            break;
        case 1:
            processName = @"Green";
            color = [UIColor greenColor];
            break;
        case 2:
            processName = @"Blue";
            color = [UIColor blueColor];
            break;
        default:
            abort();
            break;
    }
    
    __weak typeof(self) wself = self;
    [self setImageWithProcessName:processName
                             size:self.sourceImage.size
                          process:^UIImage *(UIImage *sourceImage, CGSize size) {
                              YSImageFilter *filter = [[YSImageFilter alloc] init];                              
                              filter.backgroundColor = color;
                              filter.mask = wself.maskSwitch.on ? YSImageFilterMaskCircle : YSImageFilterMaskNone;
                              
                              return [sourceImage ys_filter:filter];
                          }];
}

- (IBAction)maskSwitchDidChange:(UISwitch *)sender
{
    [self.tableView reloadData];
}

@end
