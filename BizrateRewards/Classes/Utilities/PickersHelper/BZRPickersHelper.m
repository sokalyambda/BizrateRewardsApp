//
//  BZRPickersHelper.m
//  BizrateRewards
//
//  Created by Eugenity on 02.07.15.
//  Copyright (c) 2015 Connexity. All rights reserved.
//

#import "BZRPickersHelper.h"

#import "BZRPickerHolder.h"
#import "BZRCommonPickerView.h"
#import "BZRBirthDatePickerView.h"

#import "UIView+MakeFromXib.h"
#import "UIView+ConfigureAnchorPoint.h"
#import "UIView+SoftRemoving.h"
#import "UIView+ConfigureAnchorPoint.h"

#import "BZREditProfileContainerController.h"

static NSInteger const kPickerHeight    = 218.f;
static CGFloat const kAnimationDuration = .25f;

static NSString *const kHidePickerAnimation = @"hidePickerAnimation";
static NSString *const kShowPickerAnimation = @"showPickerAnimation";

static NSString *const kAnimationName = @"animationName";
static NSString *const kCurrentPicker = @"currentPicker";

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

/**
 *  Constructor that includes parent view and container controller
 *
 *  @param parentView The view where picker should be showing.
 *  @param container  Container controller which manipulates current picker
 *
 *  @return self
 */
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

/**
 *  Showing the gender picker
 *
 *  @param result Result Block which takes the information of chosen gender
 */
- (void)showGenderPickerWithResult:(GenderResult)result
{
    self.genderResult = result;
    
    self.commonPickerView.pickerComponentsArray = @[@[@"Male", @"Female"]];
    
    if ([self isPickerExists:self.birthDatePicker]) {
        [self showHidePickerViewWithAnimation:self.birthDatePicker];
    }
    [self showHidePickerViewWithAnimation:self.commonPickerView];
}

/**
 *  Showing the date picker
 *
 *  @param result Result Block which takes the information of chosen date of birth
 */
- (void)showBirthDatePickerWithResult:(DateResult)result
{
    self.dateResult = result;
    
    if ([self isPickerExists:self.commonPickerView]) {
        [self showHidePickerViewWithAnimation:self.commonPickerView];
    }
    [self showHidePickerViewWithAnimation:self.birthDatePicker];
}

#pragma mark - Private methods

/**
 *  Check pickers for existing
 *
 *  @param pickerView Picker view that we shoud check
 *
 *  @return Returns 'YES' if picker exists
 */
- (BOOL)isPickerExists:(UIView *)pickerView
{
    return [self.parentView.subviews containsObject:pickerView];
}

#pragma mark - CAAnimation

/**
 *  Show chosen picker view with animations
 *
 *  @param pickerView Chosen picker view
 */
- (void)showHidePickerViewWithAnimation:(UIView *)pickerView
{
    if (![self isPickerExists:pickerView]) {
        //enable table scrolling when picker exists (if needed)
        if (self.containerController.scrollNeeded) {
            [self.containerController.tableView setScrollEnabled:YES];
        }
        
        [pickerView setFrame:CGRectMake(0, CGRectGetMaxY(self.parentView.bounds), CGRectGetWidth(self.parentView.frame), kPickerHeight)];
        [self.parentView addSubview:pickerView];
        
        CGPoint toPoint = CGPointMake(0, CGRectGetMaxY(self.parentView.bounds) - kPickerHeight);
        
        [pickerView setAnchorPoint:CGPointZero];
        
        CABasicAnimation * animationPosition = [CABasicAnimation animationWithKeyPath:@"position"];
        animationPosition.fromValue = [pickerView.layer valueForKey:@"position"];
        animationPosition.toValue = [NSValue valueWithCGPoint:toPoint];
        
        animationPosition.duration = kAnimationDuration;
        animationPosition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        
        animationPosition.delegate = self;
        [animationPosition setValue:kShowPickerAnimation forKey:kAnimationName];
        [animationPosition setValue:pickerView forKey:kCurrentPicker];
        
        animationPosition.removedOnCompletion = YES;
        
        pickerView.layer.position = toPoint;
        
        [pickerView.layer addAnimation:animationPosition forKey:kShowPickerAnimation];
    } else {
        //disable table scrolling when picker doesn't exist (if needed)
        if (self.containerController.scrollNeeded) {
            [self.containerController.tableView setScrollEnabled:NO];
        }
        
        CGPoint toPoint = CGPointMake(0.f, CGRectGetMaxY(self.parentView.bounds));
        
        CABasicAnimation *hideAnimation = [CABasicAnimation animationWithKeyPath:@"position"];
        hideAnimation.fromValue = [pickerView.layer valueForKey:@"position"];
        hideAnimation.toValue = [NSValue valueWithCGPoint:CGPointMake(0.f, CGRectGetMaxY(self.parentView.bounds))];
        
        hideAnimation.duration = kAnimationDuration;
        hideAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        
        hideAnimation.delegate = self;
        [hideAnimation setValue:kHidePickerAnimation forKey:kAnimationName];
        [hideAnimation setValue:pickerView forKey:kCurrentPicker];
        
        hideAnimation.removedOnCompletion = YES;
        
        pickerView.layer.position = toPoint;
        [pickerView.layer addAnimation:hideAnimation forKey:kHidePickerAnimation];
    }
    
    [self.containerController adjustTableViewInsetsWithPresentedRect:pickerView.frame];
}

/**
 *  Force removing of existed picker
 */
- (void)removeExistedPicker
{
    if ([self isPickerExists:self.commonPickerView]) {
        [self showHidePickerViewWithAnimation:self.commonPickerView];
    } else if ([self isPickerExists:self.birthDatePicker]) {
        [self showHidePickerViewWithAnimation:self.birthDatePicker];
    }
}

#pragma mark - CAAnimationDelegate

- (void)animationDidStart:(CAAnimation *)anim
{
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    if ([[anim valueForKey:kAnimationName] isEqualToString:kHidePickerAnimation]) {
        UIView *picker = [anim valueForKey:kCurrentPicker];
        [picker softRemove];
    }
}

#pragma mark - BZRBirthDatePickerDelegate

- (void)birthPickerViewWillDismiss:(BZRBirthDatePickerView *)datePickerView withChosenDate:(NSDate *)birthDate
{
    if (birthDate && self.dateResult) {
        self.dateResult(birthDate);
    }

    [self showHidePickerViewWithAnimation:datePickerView];
}

#pragma mark - BZRCommonPickerViewDelegate

- (void)commonPickerViewWillDismiss:(BZRCommonPickerView *)commonPickerView withChosenValue:(id)chosenValue
{
    if ([chosenValue isKindOfClass:[NSString class]]) {
        NSString *genderString = chosenValue;
        self.genderResult(genderString);
    }
    [self showHidePickerViewWithAnimation:commonPickerView];
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

/**
 *  Handle keyboard appearance
 *
 *  @param notification Keyboard will show notification
 */
- (void)keyboardWillShowNotification:(NSNotification *)notification
{
    [self removeExistedPicker];
    [self.containerController adjustTableViewInsetsWithPresentedRect:[self getKeyboardFrameFromNotification:notification]];
    
    //enable table view scrolling when keyboard exists (if needed)
    if (self.containerController.scrollNeeded) {
        [self.containerController.tableView setScrollEnabled:YES];
    }
}

/**
 *  Handle keyboard disappearance
 *
 *  @param notification Keyboard will hide notification
 */
- (void)keyboardWillHideNotification:(NSNotification *)notification
{
    [self.containerController adjustTableViewInsetsWithPresentedRect:[self getKeyboardFrameFromNotification:notification]];
    
    //disable table view scrolling when keyboard doesn't exist (if needed)
    if (self.containerController.scrollNeeded) {
        [self.containerController.tableView setScrollEnabled:NO];
    }
}

/**
 *  Get converted keyboard frame
 *
 *  @param notification Current keyboard notificatio
 *
 *  @return Relative keyboard rect value
 */
- (CGRect)getKeyboardFrameFromNotification:(NSNotification *)notification
{
    NSDictionary *userInfo = [notification userInfo];
    CGRect keyBoardFrame = [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    keyBoardFrame = [self.parentView convertRect:keyBoardFrame fromView:nil];
    
    return keyBoardFrame;
}

@end