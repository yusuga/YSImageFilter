//
//  SelectView.h
//  TestUIImageFiliters
//
//  Created by Yu Sugawara on 2014/03/27.
//  Copyright (c) 2014年 Yu Sugawara. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SelectView : UIView

- (id)initWithDidPushSmallSizeButton:(void(^)(void))didPushSmallSizeButton
                didPushFitSizeButton:(void(^)(void))didPushFitSizeButton;

@end
