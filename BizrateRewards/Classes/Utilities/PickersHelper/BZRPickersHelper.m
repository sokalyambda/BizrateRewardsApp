//
//  BZRPickersHelper.m
//  BizrateRewards
//
//  Created by Eugenity on 02.07.15.
//  Copyright (c) 2015 ThinkMobiles. All rights reserved.
//

#import "BZRPickersHelper.h"

#import "BZRPickerHolder.h"

#import "BZRCommonPickerView.h"
#import "BZRBirthDatePickerView.h"

#import "UIView+MakeFromXib.h"
#import "UIView+ConfigureAnchorPoint.h"
#import "UIView+SoftRemoving.h"

static NSInteger const kPickerHeight    = 218.f;
static CGFloat const kAnimationDuration = .25f;

@interface BZRPickersHelper ()<BZRBirthDatePickerDelegate, BZRCommonPickerViewDelegate, UIPickerViewDelegate>

@property (strong, nonatomic) IBOutlet BZRCommonPickerView      *commonPickerView;
@property (strong, nonatomic) IBOutlet BZRBirthDatePickerView   *birthDatePicker;

@property (strong, nonatomic) UIView *parentView;

@property (copy, nonatomic) DateResult              dateResult;
@property (copy, nonatomic) GenderResult            genderResult;
@property (copy, nonatomic) AnimaionCompletionBlock animationCompletion;

@end

@implementation BZRPickersHelper

#pragma mark - Lifecycle

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype)initWithParentView:(UIView *)parentView;
{
    self = [super init];
    if (self) {
        _parentView = parentView;
        
        _commonPickerView = [BZRCommonPickerView makeFromXibWithFileOwner:self];
        _commonPickerView.delegate = self;
        
        _birthDatePicker = [BZRBirthDatePickerView makeFromXibWithFileOwner:self];
        _birthDatePicker.delegate = self;
        
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShowNotification:) name:UIKeyboardWillShowNotification object:nil];
    }
    return self;
}

#pragma mark - Actions

#pragma mark  Public methods

- (void)showGenderPickerWithResult:(GenderResult)result withAnimationCompletion:(AnimaionCompletionBlock)animationCompletion
{
    self.genderResult = result;
    
    self.commonPickerView.pickerComponentsArray = @[@[@"Male", @"Female"]];
    
    if ([self isPickerExists:self.birthDatePicker]) {
        [self.birthDatePicker softRemove];
    }
    
    self.animationCompletion = animationCompletion;
    [self showHidePickerView:self.commonPickerView];
}

- (void)showBirthDatePickerWithResult:(DateResult)result withAnimationCompletion:(AnimaionCompletionBlock)animationCompletion
{
    self.dateResult = result;
    
    if ([self isPickerExists:self.commonPickerView]) {
        [self.commonPickerView softRemove];
    }
    
    self.animationCompletion = animationCompletion;
    [self showHidePickerView:self.birthDatePicker];
}

#pragma mark - Private methods

- (void)showHidePickerView:(UIView *)currentPickerView
{
    WEAK_SELF;
    if (![self isPickerExists:currentPickerView]) {
        [currentPickerView setFrame:CGRectMake(0, CGRectGetMaxY(self.parentView.bounds), CGRectGetWidth(self.parentView.frame), kPickerHeight)];
        
        [self.parentView addSubview:currentPickerView];
        
        [UIView animateWithDuration:kAnimationDuration
                              delay:0.1f
                            options:UIViewAnimationOptionCurveEaseIn
                         animations:^{
                             [currentPickerView setFrame:CGRectMake(0, CGRectGetMaxY(weakSelf.parentView.bounds) - kPickerHeight, CGRectGetWidth(weakSelf.parentView.frame), kPickerHeight)];
                         }
                         completion:^(BOOL finished){
                             if (finished && weakSelf.animationCompletion) {
                                 weakSelf.animationCompletion(YES, currentPickerView);
                             }
                         }];
    } else {
        [UIView animateWithDuration:kAnimationDuration
                              delay:0.1f
                            options:UIViewAnimationOptionCurveEaseOut
                         animations:^{
                             [currentPickerView setFrame:CGRectMake(0, CGRectGetMaxY(weakSelf.parentView.bounds), CGRectGetWidth(weakSelf.parentView.frame), kPickerHeight)];
                             
                             if (weakSelf.animationCompletion) {
                                 weakSelf.animationCompletion(NO, currentPickerView);
                             }
                         }
                         completion:^(BOOL finished){
                             if (finished) {
                                 [currentPickerView removeFromSuperview];
                             }
                         }];
    }
}

- (BOOL)isPickerExists:(UIView *)pickerView
{
    if (![self.parentView.subviews containsObject:pickerView]) {
        return NO;
    }
    return YES;
}

#pragma mark - BZRBirthDatePickerDelegate

- (void)birthPickerViewWillDismiss:(BZRBirthDatePickerView *)datePickerView withChosenDate:(NSDate *)birthDate
{
    if (birthDate && self.dateResult) {
        NSDate* now = [NSDate date];
        NSDateComponents* ageComponents = [[NSCalendar currentCalendar]
                                           components:NSCalendarUnitYear
                                           fromDate:birthDate
                                           toDate:now
                                           options:0];
        NSInteger age = [ageComponents year];
        
        self.dateResult(birthDate, age > 13.f);
    }

    [self showHidePickerView:datePickerView];
}

#pragma mark - BZRCommonPickerViewDelegate

- (void)commonPickerViewWillDismiss:(BZRCommonPickerView *)commonPickerView withChosenValue:(id)chosenValue
{
    if ([chosenValue isKindOfClass:[NSString class]]) {
        NSString *genderString = chosenValue;
        BOOL isMale = [[genderString substringToIndex:1] isEqualToString:@"M"] ? YES : NO;
        self.genderResult(isMale, genderString);
    }
    [self showHidePickerView:commonPickerView];
}

#pragma mark - UIPickerViewDelegate

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    id value = [((BZRPickerHolder *)pickerView) valueForRow:row forComponent:component];
    if ([value isKindOfClass:[NSString class]]) {
        return value;
    }
    return nil;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    
}

#pragma mark - Keyboard methods

- (void)keyboardWillShowNotification:(NSNotification *)notification
{
    if ([self isPickerExists:self.commonPickerView]) {
        [ self showHidePickerView:self.commonPickerView];
    } else if ([self isPickerExists:self.birthDatePicker]) {
        [self showHidePickerView:self.birthDatePicker];
    }
}

@end