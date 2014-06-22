//
//  MonochromeViewController.m
//  TestUIImageFiliters
//
//  Created by Yu Sugawara on 2014/05/30.
//  Copyright (c) 2014年 Yu Sugawara. All rights reserved.
//

#import "MonochromeViewController.h"

@interface MonochromeViewController ()

@property (strong, nonatomic) IBOutlet UILabel *maskLabel;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *maskSwitchItem;
@property (weak, nonatomic) IBOutlet UISwitch *maskSwitch;

@property (strong, nonatomic) IBOutlet UILabel *borderLabel;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *borderSwitchItem;
@property (weak, nonatomic) IBOutlet UISwitch *borderSwitch;

@end

@implementation MonochromeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.rightBarButtonItems = @[self.maskSwitchItem,
                                                [[UIBarButtonItem alloc] initWithCustomView:self.maskLabel],
                                                self.borderSwitchItem,
                                                [[UIBarButtonItem alloc] initWithCustomView:self.borderLabel]];
    self.disableExclusiveResize = YES;
}

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
    
    __weak typeof(self) wself = self;
    [self setImageWithProcessName:processName
                             size:self.sourceImage.size
                          process:^UIImage *(UIImage *sourceImage, CGSize size) {
                              YSImageFilter *filter = [[YSImageFilter alloc] init];
                              if (wself.borderSwitch.on) {
                                  filter.borderWidth = 10.f;
                                  filter.borderColor = [UIColor redColor];
                              }
                              filter.mask = wself.maskSwitch.on ? YSImageFilterMaskCircle : YSImageFilterMaskNone;
                              
                              filter.colorEffectFilterAttributes = @[[YSImageFilter monochromeAttributesWithColor:color intensity:1.f]];
                              return [sourceImage ys_filter:filter];
                          }];
}

- (IBAction)switchDidChange:(UISwitch *)sender
{
    [self.tableView reloadData];
}

@end
