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

static NSInteger const kPickerHeight = 218.f;
static CGFloat const kAnitmationDuration = .5f;

static NSString *const kAnimationName = @"animationName";
static NSString *const kShowPickerAnimation = @"showPickerAnimation";
static NSString *const kHidePickerAnimation = @"hidePickerAnimation";

@interface BZRPickersHelper ()<BZRBirthDatePickerDelegate, BZRCommonPickerViewDelegate, UIPickerViewDelegate>

@property (strong, nonatomic) IBOutlet BZRCommonPickerView *commonPickerView;
@property (strong, nonatomic) IBOutlet BZRBirthDatePickerView *birthDatePicker;

@property (strong, nonatomic) UIView *currentParentView;

@property (assign, nonatomic) BOOL isPickerExpanded;

@property (copy, nonatomic) Completion completion;
@property (copy, nonatomic) AnimationCompletion animationCompletion;

@end

@implementation BZRPickersHelper

#pragma mark - Lifecycle

- (instancetype)init
{
    self = [super init];
    if (self) {
        _commonPickerView = [BZRCommonPickerView makeFromXibWithFileOwner:self];
        _commonPickerView.delegate = self;
        
        _birthDatePicker = [BZRBirthDatePickerView makeFromXibWithFileOwner:self];
        _birthDatePicker.delegate = self;
    }
    return self;
}

#pragma mark - Actions

#pragma mark  Public methods

- (void)showCommonPickerViewInView:(UIView *)view  withComponentsArray:(NSArray *)componentsArray withCompletion:(Completion)completion
{
    self.currentParentView = view;
    self.completion = completion;
    
    if (componentsArray)
        self.commonPickerView.pickerComponentsArray = @[componentsArray];

    [self showCurrentPickerView:self.commonPickerView];
}

- (void)showBirthDatePickerInView:(UIView *)view withCompletion:(Completion)completion
{
    self.currentParentView = view;
    self.completion = completion;
    
    [self showCurrentPickerView:self.birthDatePicker];
}

#pragma mark - Private methods

- (void)showCurrentPickerView:(UIView *)currentPickerView
{
    [currentPickerView setFrame:CGRectMake(0, CGRectGetMaxY(self.currentParentView.bounds), CGRectGetWidth(self.currentParentView.frame), kPickerHeight)];
    
    if (![self.currentParentView.subviews containsObject:currentPickerView] && !self.isPickerExpanded) {
        [self.currentParentView addSubview:currentPickerView];
        [self showPickerView:currentPickerView inView:self.currentParentView];
    } else {
        [self hidePickerView:currentPickerView inView:self.currentParentView withCompletion:^{
            [currentPickerView removeFromSuperview];
        }];
    }
}

#pragma mark - CAAnimation

- (void)showPickerView:(UIView *)pickerView inView:(UIView *)parentView
{
    CGPoint toPoint = CGPointMake(0, CGRectGetMaxY(parentView.bounds) - kPickerHeight);
    
    [self setAnchorPoint:CGPointZero forView:pickerView];

    CABasicAnimation * animationPosition = [CABasicAnimation animationWithKeyPath:@"position"];
    animationPosition.fromValue = [pickerView.layer valueForKey:@"position"];
    animationPosition.toValue = [NSValue valueWithCGPoint:toPoint];
    
    animationPosition.duration = kAnitmationDuration;
    animationPosition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    
    pickerView.layer.position = toPoint;
    [pickerView.layer addAnimation:animationPosition forKey:kShowPickerAnimation];
}

- (void)hidePickerView:(UIView *)pickerView inView:(UIView *)parentView withCompletion:(AnimationCompletion)completion
{
    self.animationCompletion = completion;
    
    CGPoint toPoint = CGPointMake(0, CGRectGetMaxY(parentView.bounds));
    
    CABasicAnimation *hideAnimation = [CABasicAnimation animationWithKeyPath:@"position"];
    hideAnimation.fromValue = [pickerView.layer valueForKey:@"position"];
    hideAnimation.toValue = [NSValue valueWithCGPoint:toPoint];
    
    hideAnimation.duration = kAnitmationDuration;
    hideAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    
    hideAnimation.delegate = self;
    [hideAnimation setValue:kHidePickerAnimation forKey:kAnimationName];
    
    pickerView.layer.position = toPoint;
    [pickerView.layer addAnimation:hideAnimation forKey:kHidePickerAnimation];
}

#pragma mark - BZRBirthDatePickerDelegate

- (void)birthPickerViewWillDismiss:(BZRBirthDatePickerView *)datePickerView
{
    WEAK_SELF;
    [self hidePickerView:datePickerView inView:self.currentParentView withCompletion:^{
        [datePickerView removeFromSuperview];
        weakSelf.isPickerExpanded = NO;
    }];
}

#pragma mark - BZRCommonPickerViewDelegate

- (void)commonPickerViewWillDismiss:(BZRCommonPickerView *)commonPickerView
{
    WEAK_SELF;
    [self hidePickerView:commonPickerView inView:self.currentParentView withCompletion:^{
        [commonPickerView removeFromSuperview];
        weakSelf.isPickerExpanded = NO;
    }];
}

#pragma mark - UIPickerViewDelegate

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    id value =  [((BZRPickerHolder*)pickerView) valueForRow:row forComponent:component];
    if ([value isKindOfClass:[NSString class]]) {
        return value;
    }
    return nil;
}

#pragma mark - CAAnimationDelegate

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    if (self.animationCompletion) {
        self.animationCompletion();
    }
}

#pragma mark - CALayer

- (void)setAnchorPoint:(CGPoint)anchorPoint forView:(UIView *)view
{
    CGPoint newPoint = CGPointMake(view.bounds.size.width * anchorPoint.x,
                                   view.bounds.size.height * anchorPoint.y);
    CGPoint oldPoint = CGPointMake(view.bounds.size.width * view.layer.anchorPoint.x,
                                   view.bounds.size.height * view.layer.anchorPoint.y);
    
    newPoint = CGPointApplyAffineTransform(newPoint, view.transform);
    oldPoint = CGPointApplyAffineTransform(oldPoint, view.transform);
    
    CGPoint position = view.layer.position;
    
    position.x -= oldPoint.x;
    position.x += newPoint.x;
    
    position.y -= oldPoint.y;
    position.y += newPoint.y;
    
    view.layer.position = position;
    view.layer.anchorPoint = anchorPoint;
}

@end
