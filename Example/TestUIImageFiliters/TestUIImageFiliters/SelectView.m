//
//  SelectView.m
//  TestUIImageFiliters
//
//  Created by Yu Sugawara on 2014/03/27.
//  Copyright (c) 2014年 Yu Sugawara. All rights reserved.
//

#import "SelectView.h"

@interface SelectView ()

@property (weak, nonatomic) IBOutlet UIButton *smallButton;
@property (weak, nonatomic) IBOutlet UIButton *fitButton;

@property (copy, nonatomic) void(^didPushSmallSizeButton)(void);
@property (copy, nonatomic) void(^didPushFitSizeButton)(void);

@end

@implementation SelectView

- (id)initWithDidPushSmallSizeButton:(void (^)(void))didPushSmallSizeButton
                didPushFitSizeButton:(void (^)(void))didPushFitSizeButton
{
    UINib *nib = [UINib nibWithNibName:NSStringFromClass([self class]) bundle:nil];
    self = [[nib instantiateWithOwner:self options:nil] objectAtIndex:0];

    self.didPushSmallSizeButton = didPushSmallSizeButton;
    self.didPushFitSizeButton = didPushFitSizeButton;
    
    return self;
}

- (IBAction)smallButtonDidPush:(id)sender
{
    if (self.didPushSmallSizeButton) self.didPushSmallSizeButton();
}

- (IBAction)fitButtonDidPush:(id)sender
{
    if (self.didPushFitSizeButton) self.didPushFitSizeButton();
}

@end
