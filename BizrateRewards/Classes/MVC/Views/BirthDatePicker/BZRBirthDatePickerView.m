//
//  BZRDatePickerHolder.m
//  BizrateRewards
//
//  Created by Eugenity on 30.06.15.
//  Copyright (c) 2015 Connexity. All rights reserved.
//

#import "BZRBirthDatePickerView.h"

@interface BZRBirthDatePickerView ()

@end

@implementation BZRBirthDatePickerView

#pragma mark - Actions

- (IBAction)doneClick:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(birthPickerViewWillDismiss:withChosenDate:)]) {
        [self.delegate birthPickerViewWillDismiss:self withChosenDate:self.datePicker.date];
    } else {
        [self removeFromSuperview];
    }
    
}

@end
