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

#import "BZREditProfileContainerController.h"

static NSInteger const kPickerHeight = 218.f;
static CGFloat const kAnimationDuration = .25f;
static NSInteger const kValidAge = 13.f;

@interface BZRPickersHelper ()<BZRBirthDatePickerDelegate, BZRCommonPickerViewDelegate, UIPickerViewDelegate>

@property (strong, nonatomic) IBOutlet BZRCommonPickerView    *commonPickerView;
@property (strong, nonatomic) IBOutlet BZRBirthDatePickerView *birthDatePicker;

@property (strong, nonatomic) UIView *parentView;
@property (weak, nonatomic) BZREditProfileContainerController *containerController;

@property (copy, nonatomic) DateResult   dateResult;
@property (copy, nonatomic) GenderResult genderResult;

@end

@implementation BZRPickersHelper

#pragma mark - Lifecycle

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype)initWithParentView:(UIView *)parentView andContainerController:(BZREditProfileContainerController *)container;
{
    self = [super init];
    if (self) {
        _parentView = parentView;
        _containerController = container;
        
        _commonPickerView = [BZRCommonPickerView makeFromXibWithFileOwner:self];
        _commonPickerView.delegate = self;
        
        _birthDatePicker = [BZRBirthDatePickerView makeFromXibWithFileOwner:self];
        _birthDatePicker.delegate = self;
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShowNotification:) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHideNotification:) name:UIKeyboardWillHideNotification object:nil];
    }
    return self;
}

#pragma mark - Actions

#pragma mark  Public methods

- (void)showGenderPickerWithResult:(GenderResult)result
{
    self.genderResult = result;
    
    self.commonPickerView.pickerComponentsArray = @[@[@"Male", @"Female"]];
    
    if ([self isPickerExists:self.birthDatePicker]) {
        [self showHidePickerView:self.birthDatePicker];
    }
    [self showHidePickerView:self.commonPickerView];
}

- (void)showBirthDatePickerWithResult:(DateResult)result
{
    self.dateResult = result;
    
    if ([self isPickerExists:self.commonPickerView]) {
        [self showHidePickerView:self.commonPickerView];
    }
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
                              delay:0.f
                            options:UIViewAnimationOptionCurveEaseIn
                         animations:^{
                             [currentPickerView setFrame:CGRectMake(0, CGRectGetMaxY(weakSelf.parentView.bounds) - kPickerHeight, CGRectGetWidth(weakSelf.parentView.frame), kPickerHeight)];
                             [weakSelf.containerController adjustTableViewInsetsWithPresentedRect:currentPickerView.frame];
                         }
                         completion:nil];
    } else {
        [UIView animateWithDuration:kAnimationDuration
                              delay:0.f
                            options:UIViewAnimationOptionCurveEaseOut
                         animations:^{
                             [currentPickerView setFrame:CGRectMake(0, CGRectGetMaxY(weakSelf.parentView.bounds), CGRectGetWidth(weakSelf.parentView.frame), kPickerHeight)];
                             
                             [weakSelf.containerController adjustTableViewInsetsWithPresentedRect:currentPickerView.frame];
                         }
                         completion:^(BOOL finished) {
                             if (finished) {
                                 [currentPickerView removeFromSuperview];
                             }
                         }];
    }
}

- (BOOL)isPickerExists:(UIView *)pickerView
{
    return [self.parentView.subviews containsObject:pickerView];
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
        
        self.dateResult(birthDate, age > kValidAge);
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
        [self showHidePickerView:self.commonPickerView];
    } else if ([self isPickerExists:self.birthDatePicker]) {
        [self showHidePickerView:self.birthDatePicker];
    }
    
    NSDictionary* info = [notification userInfo];
    CGRect keyBoardFrame = [self getKeyboardFrameFromUserInfo:info];
    
    [self.containerController adjustTableViewInsetsWithPresentedRect:keyBoardFrame];
}

- (void)keyboardWillHideNotification:(NSNotification*) notification
{
    NSDictionary* info = [notification userInfo];
    CGRect keyBoardFrame = [self getKeyboardFrameFromUserInfo:info];
    
    [self.containerController adjustTableViewInsetsWithPresentedRect:keyBoardFrame];
}

- (CGRect)getKeyboardFrameFromUserInfo:(NSDictionary *)userInfo
{
    CGRect keyBoardFrame = [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    keyBoardFrame = [self.parentView convertRect:keyBoardFrame fromView:nil];
    return keyBoardFrame;
}

@end