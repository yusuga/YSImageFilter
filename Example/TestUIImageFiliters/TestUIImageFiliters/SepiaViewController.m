//
//  SepiaViewController.m
//  TestUIImageFiliters
//
//  Created by Yu Sugawara on 2014/03/29.
//  Copyright (c) 2014年 Yu Sugawara. All rights reserved.
//

#import "SepiaViewController.h"

typedef NS_ENUM(NSUInteger, Row) {
    RowSepiaCoreImage,
    RowSepiaNYXImagesKit,
    RowSepiaGPUImage,
};

@interface SepiaViewController ()

@end

@implementation SepiaViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)setTargetImageView:(UIImageView *)targetImageView
{
    [super setTargetImageView:targetImageView];
    if (!self.isViewLoaded) {
        [self performSelector:@selector(view)];
    }
    self.sourceImage = [ImageFilter resizeInCoreImageWithImage:self.sourceImage
                                                          size:targetImageView.bounds.size
                                                        useGPU:YES
                                                     trimToFit:YES];
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
    
    NSString *processName;
    SetImageProcess setImageProcess;
    switch (indexPath.row) {
        case RowSepiaCoreImage:
            processName = @"sepia CoreImage";
            setImageProcess = ^UIImage *(UIImage *sourceImage, CGSize size) {
                return [ImageFilter sepiaInCoreImageWithImage:sourceImage intensity:0.5f useGPU:YES];
            };
            break;
        case RowSepiaNYXImagesKit:
            processName = @"sepia NYXImagesKit";
            setImageProcess = ^UIImage *(UIImage *sourceImage, CGSize size) {
                return [ImageFilter sepiaInNYXImagesKitWithImage:sourceImage];
            };
            break;
        case RowSepiaGPUImage:
            processName = @"sepia GPUImage";
            setImageProcess = ^UIImage *(UIImage *sourceImage, CGSize size) {
                return [ImageFilter sepiaInGPUImageWithImage:sourceImage];
            };
            break;
        default:
            abort();
            break;
    }
    
    [self setImageWithProcessName:processName
                          process:setImageProcess
                             size:self.sourceImage.size];
}

@end
