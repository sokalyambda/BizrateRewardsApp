//
//  BZRCommonPickerView.m
//  BizrateRewards
//
//  Created by Eugenity on 02.07.15.
//  Copyright (c) 2015 Connexity. All rights reserved.
//

#import "BZRCommonPickerView.h"

#import "BZRPickerHolder.h"

@interface BZRCommonPickerView ()

@property (weak, nonatomic) IBOutlet BZRPickerHolder *pickerHolder;

@end

@implementation BZRCommonPickerView

#pragma mark - Accessors

- (void)setPickerComponentsArray:(NSArray *)pickerComponentsArray
{
    _pickerComponentsArray = pickerComponentsArray;
    self.pickerHolder.componentsArray = _pickerComponentsArray;
    [self.pickerHolder reloadAllComponents];
}

#pragma mark - Actions

- (IBAction)doneClick:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(commonPickerViewWillDismiss:withChosenValue:)]) {
        [self.delegate commonPickerViewWillDismiss:self withChosenValue:[self.pickerHolder selectedValueInComponent:0]];
    } else {
        [self removeFromSuperview];
    }
}

@end

