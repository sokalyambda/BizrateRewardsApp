//
//  BZRDatePickerHolder.m
//  BizrateRewards
//
//  Created by Eugenity on 30.06.15.
//  Copyright (c) 2015 ThinkMobiles. All rights reserved.
//

#import "BZRBirthDatePickerView.h"

@implementation BZRBirthDatePickerView

#pragma mark - Actions

- (IBAction)doneClick:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(birthPickerViewWillDissmiss:)]) {
        [self.delegate birthPickerViewWillDissmiss:self];
    } else {
        [self removeFromSuperview];
    }
    
}

@end
