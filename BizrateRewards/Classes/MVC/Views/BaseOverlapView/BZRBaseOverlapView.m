//
//  BZRBaseOverlapView.m
//  BizrateRewards
//
//  Created by Eugenity on 31.07.15.
//  Copyright (c) 2015 Connexity. All rights reserved.
//

#import "BZRBaseOverlapView.h"

#import "UIView+MakeFromXib.h"

@interface BZRBaseOverlapView ()

@property (copy, nonatomic) OverlapCompletion completion;

@end

@implementation BZRBaseOverlapView

+ (void)showWithCompletion:(OverlapCompletion)completion
{
    BZRBaseOverlapView *view = [self makeFromXib];
    view.frame = [[[UIApplication sharedApplication] delegate] window].bounds;
    
    view.completion = completion;
    
    [view setAlpha:0];
    [[UIApplication sharedApplication].keyWindow addSubview:view];
    
    [view setTransform:CGAffineTransformMakeScale(0.1f, 0.1f)];
    [UIView animateWithDuration:0.2f animations:^{
        [view setTransform:CGAffineTransformMakeScale(1, 1)];
        [view setAlpha:1];
    }];
}

- (void)dismiss
{
    WEAK_SELF;
    [UIView animateWithDuration:0.2f animations:^{
        [weakSelf setTransform:CGAffineTransformMakeScale(2, 2)];
        weakSelf.alpha = 0;
    }completion:^(BOOL finished) {
        [weakSelf setTransform:CGAffineTransformMakeScale(1, 1)];
        [weakSelf removeFromSuperview];
    }];
}

#pragma mark - Actions

- (IBAction)buttonCancelAction:(id)sender
{
    [self dismiss];
    
    if (self.completion) {
        self.completion(self, YES);
    }
}

- (IBAction)buttonApplyAction:(id)sender
{
    [self dismiss];
    
    if (self.completion) {
        self.completion(self, NO);
    }
}

@end
