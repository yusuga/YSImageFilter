//
//  MaskViewController.m
//  TestUIImageFiliters
//
//  Created by Yu Sugawara on 2014/03/31.
//  Copyright (c) 2014年 Yu Sugawara. All rights reserved.
//

#import "MaskViewController.h"
#import "YSImageFilter.h"

typedef NS_ENUM(NSUInteger, Row) {
    RowMaskNone,
    RowMaskRoundedCorners,
    RowMaskCircle,
};

@implementation MaskViewController

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [super tableView:tableView didSelectRowAtIndexPath:indexPath];
    
    NSString *processName;
    YSImageFilterMask mask;
    switch (indexPath.row) {
        case RowMaskNone:
            processName = @"mask none";
            mask = YSImageFilterMaskNone;
            break;
        case RowMaskRoundedCorners:
            processName = @"mask rounded corners";
            mask = YSImageFilterMaskRoundedCorners;
            break;
        case RowMaskCircle:
            processName = @"mask circle";
            mask = YSImageFilterMaskCircle;
            break;
        default:
            abort();
            break;
    }
    
    UIImage *sourceImage = self.sourceImage;
    CGFloat minSize = MIN(sourceImage.size.width, sourceImage.size.height);
    [self setImageWithProcessName:processName
                             size:CGSizeMake(minSize, minSize)
                          process:^UIImage *(UIImage *sourceImage, CGSize size) {
                              return [YSImageFilter resizeWithImage:sourceImage
                                                               size:size
                                                            quality:kCGInterpolationHigh
                                                          trimToFit:YES
                                                               mask:mask];
                          }];

}

@end
