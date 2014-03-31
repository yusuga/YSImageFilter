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

@implementation SepiaViewController

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [super tableView:tableView didSelectRowAtIndexPath:indexPath];
    
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
                             size:self.sourceImage.size
                          process:setImageProcess];
}

@end
