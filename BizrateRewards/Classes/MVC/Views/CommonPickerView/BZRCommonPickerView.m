//
//  BZRCommonPickerView.m
//  BizrateRewards
//
//  Created by Eugenity on 02.07.15.
//  Copyright (c) 2015 ThinkMobiles. All rights reserved.
//

#import "BZRCommonPickerView.h"

@implementation BZRCommonPickerView

- (IBAction)doneClick:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(commonPickerViewWillDissmiss:)]) {
        [self.delegate commonPickerViewWillDissmiss:self];
    } else {
        [self removeFromSuperview];
    }
}

@end

