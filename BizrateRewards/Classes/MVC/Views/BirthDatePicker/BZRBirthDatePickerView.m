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

- (void)awakeFromNib
{
    NSDate *now = [NSDate date];
    NSDateComponents *minusHundredYears = [NSDateComponents new];
    minusHundredYears.year = -120;
    NSDate *hundredYearsAgo = [[NSCalendar currentCalendar] dateByAddingComponents:minusHundredYears
                                                                            toDate:now
                                                                           options:0];
    [self.datePicker setMinimumDate:hundredYearsAgo];
    [self.datePicker setMaximumDate:now];
}

#pragma mark - Actions

- (IBAction)doneClick:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(birthPickerViewWillDismiss:withChosenDate:)]) {
        NSDate *selectedDate = self.datePicker.date;
        [self.delegate birthPickerViewWillDismiss:self withChosenDate:selectedDate];
    } else {
        [self removeFromSuperview];
    }
}

@end
