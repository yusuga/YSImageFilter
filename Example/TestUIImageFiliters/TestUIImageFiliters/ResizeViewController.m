//
//  ResizeViewController.m
//  TestUIImageFiliters
//
//  Created by Yu Sugawara on 2014/03/27.
//  Copyright (c) 2014年 Yu Sugawara. All rights reserved.
//

#import "ResizeViewController.h"
#import <NSRunLoop+PerformBlock/NSRunLoop+PerformBlock.h>

typedef NS_ENUM(NSUInteger, Row) {
    RowResizeSimpleCoreGraphicsNone,
    RowResizeSimpleCoreGraphicsLow,
    RowResizeSimpleCoreGraphicsMedium,
    RowResizeSimpleCoreGraphicsHigh,
    RowResizeNYXImagesKit,
    RowResizeGPUImage,
    RowResizeCoreImageCPU,
    RowResizeCoreImageGPU,
};

@interface ResizeViewController ()

@property (nonatomic) CGSize sizeSmall;
@property (nonatomic) CGSize sizeFit;

@property (nonatomic) UISwitch *backgroundSwitch;
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
    
    UILabel *bgLabel = [[UILabel alloc] init];
    bgLabel.text = @"BG";
    [bgLabel sizeToFit];
    
    UILabel *trimLabel = [[UILabel alloc] init];
    trimLabel.text = @"trimToFit";
    [trimLabel sizeToFit];
    
    bgLabel.textColor = trimLabel.textColor = [UIColor darkGrayColor];
    
    UISwitch *bgSwitch = [[UISwitch alloc] init];
    bgSwitch.on = NO;
    [bgSwitch addTarget:self action:@selector(backgroundSwitchDidChange:) forControlEvents:UIControlEventValueChanged];
    self.backgroundSwitch = bgSwitch;
    
    UISwitch *trimSwitch = [[UISwitch alloc] init];
    trimSwitch.on = NO;
    [trimSwitch addTarget:self action:@selector(trimSwitchDidChange:) forControlEvents:UIControlEventValueChanged];
    self.trimSwitch = trimSwitch;
    
    self.navigationItem.rightBarButtonItems = @[[[UIBarButtonItem alloc] initWithCustomView:trimSwitch],
                                                [[UIBarButtonItem alloc] initWithCustomView:trimLabel],
                                                [[UIBarButtonItem alloc] initWithCustomView:bgSwitch],
                                                [[UIBarButtonItem alloc] initWithCustomView:bgLabel]];
}

- (void)setTargetImageView:(UIImageView *)targetImageView
{
    [super setTargetImageView:targetImageView];
    self.sizeFit = targetImageView.bounds.size;
}

- (void)trimSwitchDidChange:(id)sender
{
//    [self clearImageView];
    [self.tableView reloadData];
}

- (void)backgroundSwitchDidChange:(id)sender
{
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
    switch (indexPath.section) {
        case 0:
            switch (indexPath.row) {
                case RowResizeSimpleCoreGraphicsNone:
                case RowResizeSimpleCoreGraphicsLow:
                case RowResizeSimpleCoreGraphicsMedium:
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
                        case RowResizeSimpleCoreGraphicsMedium:
                            quality = kCGInterpolationMedium;
                            qualityStr = @"Medium";
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
                    BOOL async = self.backgroundSwitch.on;
                    setImageProcess = ^UIImage *(UIImage *sourceImage, CGSize size) {
                        YSImageFilter *filter = [[YSImageFilter alloc] init];
                        filter.size = size;
                        filter.quality = quality;
                        filter.trimToFit = trimToFit;
                        
                        __block UIImage *resizedImage;
                        if (async) {
                            [[NSRunLoop currentRunLoop] performBlockAndWait:^(BOOL *finish) {
                                [sourceImage ys_filter:filter withCompletion:^(UIImage *filterdImage) {
                                    resizedImage = filterdImage;
                                    *finish = YES;
                                }];
                            } timeoutInterval:DBL_MAX];
                        } else {
                            resizedImage = [sourceImage ys_filter:filter];
                        }
                        return resizedImage;
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
            break;
        case 1:
        {
            CGFloat maxResolution = 10.f;
            if (indexPath.row) {
                for (NSUInteger i = 0; i < indexPath.row; i++) {
                    maxResolution *= 10;
                }
            }
            
            processName = [NSString stringWithFormat:@"set MaxResolution(%.0f)", maxResolution];
            BOOL async = self.backgroundSwitch.on;
            setImageProcess = ^UIImage *(UIImage *sourceImage, CGSize size) {
                YSImageFilter *filter = [[YSImageFilter alloc] init];
                filter.maxResolution = maxResolution;
                
                __block UIImage *resizedImage;
                if (async) {
                    [[NSRunLoop currentRunLoop] performBlockAndWait:^(BOOL *finish) {
                        [sourceImage ys_filter:filter withCompletion:^(UIImage *filterdImage) {
                            resizedImage = filterdImage;
                            *finish = YES;
                        }];
                    } timeoutInterval:DBL_MAX];
                } else {
                    resizedImage = [sourceImage ys_filter:filter];
                }
                return resizedImage;
            };
            break;
        }
        default:
            abort();
    }
    
    processName = [processName stringByAppendingFormat:@" - %@", trimToFit ? @"trimToFit" : @"aspect fit resize"];
    cell.accessoryView = [[SelectView alloc] initWithDidPushSmallSizeButton:^{
        [self setImageWithProcessName:[processName stringByAppendingString:@" - small size"]
                                 size:self.sizeSmall
                              process:setImageProcess];
    } didPushFitSizeButton:^{
        [self setImageWithProcessName:[processName stringByAppendingString:@" - fit size"]
                                 size:self.sizeFit
                              process:setImageProcess];
    }];
}

@end
