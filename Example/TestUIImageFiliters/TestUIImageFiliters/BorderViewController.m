//
//  BorderViewController.m
//  TestUIImageFiliters
//
//  Created by Yu Sugawara on 2014/04/01.
//  Copyright (c) 2014年 Yu Sugawara. All rights reserved.
//

#import "BorderViewController.h"

typedef NS_ENUM(NSUInteger, Row) {
    RowMaskNone,
    RowMaskRoundedCorners,
    RowMaskRoundedCornersIOS7RadiusRatio,
    RowMaskCircle,
};

@implementation BorderViewController

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
        case RowMaskRoundedCornersIOS7RadiusRatio:
            processName = @"mask rounded corners - iOS7 radisu ratio";
            mask = YSImageFilterMaskRoundedCornersIOS7RadiusRatio;
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
                                                               mask:mask
                                                        borderWidth:5.f
                                                        borderColor:[UIColor redColor]
                                                   maskCornerRadius:10.f];
                          }];
    
}

@end
