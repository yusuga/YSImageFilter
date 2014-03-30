//
//  ResizeViewController.m
//  TestUIImageFiliters
//
//  Created by Yu Sugawara on 2014/03/27.
//  Copyright (c) 2014年 Yu Sugawara. All rights reserved.
//

#import "ResizeViewController.h"

typedef NS_ENUM(NSUInteger, Row) {
    RowResizeSimpleCoreGraphicsNone,
    RowResizeSimpleCoreGraphicsLow,
    RowResizeSimpleCoreGraphicsHigh,
    RowResizeNYXImagesKit,
    RowResizeGPUImage,
    RowResizeCoreImageCPU,
    RowResizeCoreImageGPU,
};

@interface ResizeViewController ()

@property (nonatomic) CGSize sizeSmall;
@property (nonatomic) CGSize sizeFit;

@property (nonatomic) UISwitch *trimSwitch;

@end

@implementation ResizeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.sizeSmall = CGSizeMake(50.f, 50.f);
    
    UILabel *trimLabel = [[UILabel alloc] init];
    trimLabel.text = @"trimToFit";
    trimLabel.textColor = [UIColor darkGrayColor];
    [trimLabel sizeToFit];
    
    UISwitch *trimSwitch = [[UISwitch alloc] init];
    trimSwitch.on = NO;
    [trimSwitch addTarget:self action:@selector(trimSwitchDidChange:) forControlEvents:UIControlEventValueChanged];
    self.trimSwitch = trimSwitch;
    
    self.navigationItem.rightBarButtonItems = @[[[UIBarButtonItem alloc] initWithCustomView:trimSwitch],
                                                [[UIBarButtonItem alloc] initWithCustomView:trimLabel]];
}

- (void)setTargetImageView:(UIImageView *)targetImageView
{
    [super setTargetImageView:targetImageView];
    self.sizeFit = targetImageView.bounds.size;
}

- (void)trimSwitchDidChange:(UISwitch*)trimSwitch
{
//    [self clearImageView];
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    BOOL trimToFit = self.trimSwitch.on;
    NSString *processName;
    SetImageProcess setImageProcess;
    switch (indexPath.row) {
        case RowResizeSimpleCoreGraphicsNone:
        case RowResizeSimpleCoreGraphicsLow:
        case RowResizeSimpleCoreGraphicsHigh:
        {
            CGInterpolationQuality quality;
            NSString *qualityStr;
            switch (indexPath.row) {
                case RowResizeSimpleCoreGraphicsNone:
                    quality = kCGInterpolationNone;
                    qualityStr = @"None";
                    break;
                case RowResizeSimpleCoreGraphicsLow:
                    quality = kCGInterpolationLow;
                    qualityStr = @"Low";
                    break;
                case RowResizeSimpleCoreGraphicsHigh:
                    quality = kCGInterpolationHigh;
                    qualityStr = @"High";
                    break;
                default:
                    abort();
                    break;
            }
            processName = [NSString stringWithFormat:@"set CoreGraphics(%@)", qualityStr];
            setImageProcess = ^UIImage *(UIImage *sourceImage, CGSize size) {
                return [YSImageFilter resizeWithImage:sourceImage size:size quality:quality trimToFit:trimToFit];
            };
        }
            break;
        case RowResizeNYXImagesKit:
        {
            processName = [NSString stringWithFormat:@"set NYXImagesKit"];
            setImageProcess = ^UIImage *(UIImage *sourceImage, CGSize size) {
                return [ImageFilter resizeInNYXImagesKitWithImage:sourceImage size:size trimToFit:trimToFit];
            };
        }
            break;
        case RowResizeGPUImage:
        {
            processName = [NSString stringWithFormat:@"set GPUImage"];
            setImageProcess = ^UIImage *(UIImage *sourceImage, CGSize size) {
                return [ImageFilter resizeInGPUImageWithImage:sourceImage size:size trimToFit:trimToFit];
            };
            break;
        }
        case RowResizeCoreImageCPU:
        case RowResizeCoreImageGPU:
        {
            BOOL useGPU = indexPath.row == RowResizeCoreImageGPU ? YES : NO;
            processName = [NSString stringWithFormat:@"set CoreImage(%@)", useGPU ? @"GPU" : @"CPU"];
            setImageProcess = ^UIImage *(UIImage *sourceImage, CGSize size) {
                return [ImageFilter resizeInCoreImageWithImage:sourceImage size:size useGPU:useGPU trimToFit:trimToFit];
            };
            break;
        }
        default:
            abort();
    }
    
    processName = [processName stringByAppendingFormat:@" - %@", trimToFit ? @"trimToFit" : @"aspect fit resize"];
    cell.accessoryView = [[SelectView alloc] initWithDidPushSmallSizeButton:^{
        [self setImageWithProcessName:[processName stringByAppendingString:@" - small size"]
                              process:setImageProcess
                                 size:self.sizeSmall];
    } didPushFitSizeButton:^{
        [self setImageWithProcessName:[processName stringByAppendingString:@" - fit size"]
                              process:setImageProcess
                                 size:self.sizeFit];
    }];
}

@end
