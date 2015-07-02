//
//  BZRPickersHelper.m
//  BizrateRewards
//
//  Created by Eugenity on 02.07.15.
//  Copyright (c) 2015 ThinkMobiles. All rights reserved.
//

#import "BZRPickersHelper.h"

#import "BZRCommonPickerView.h"
#import "BZRBirthDatePickerView.h"

#import "UIView+MakeFromXib.h"

static NSInteger const kPickerHeight = 218.f;
static CGFloat const kAnitmationDuration = .5f;

static NSString *const kAnimationName = @"animationName";
static NSString *const kShowPickerAnimation = @"showPickerAnimation";
static NSString *const kHidePickerAnimation = @"hidePickerAnimation";

@interface BZRPickersHelper ()<BZRBirthDatePickerDelegate>

@property (strong, nonatomic) IBOutlet BZRCommonPickerView *commonPickerView;
@property (strong, nonatomic) IBOutlet BZRBirthDatePickerView *birthDatePicker;

@property (strong, nonatomic) UIView *currentParentView;

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
        _birthDatePicker = [BZRBirthDatePickerView makeFromXibWithFileOwner:self];
        _birthDatePicker.delegate = self;
    }
    return self;
}

#pragma mark - Actions

- (void)showCommonPickerViewInView:(UIView *)view withCompletion:(Completion)completion
{
    
}

- (void)showBirthDatePickerInView:(UIView *)view withCompletion:(Completion)completion
{
    self.currentParentView = view;
    self.completion = completion;
    
    [self.birthDatePicker setFrame:CGRectMake(0, CGRectGetMaxY(view.frame), view.frame.size.width, kPickerHeight)];
    
    if (![view.subviews containsObject:self.birthDatePicker]) {
        [view addSubview:self.birthDatePicker];
        [self showPickerView:self.birthDatePicker inView:view];
    } else {
        [self hidePickerView:self.birthDatePicker inView:view withCompletion:^{
            [self.birthDatePicker removeFromSuperview];
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
    hideAnimation.toValue = [NSValue valueWithCGPoint:CGPointMake(0, CGRectGetMaxY(parentView.bounds))];
    
    hideAnimation.duration = kAnitmationDuration;
    hideAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    
    hideAnimation.delegate = self;
    [hideAnimation setValue:kHidePickerAnimation forKey:kAnimationName];
    
    pickerView.layer.position = toPoint;
    [pickerView.layer addAnimation:hideAnimation forKey:kHidePickerAnimation];
}

#pragma mark - BZRBirthDatePickerDelegate

- (void)birthPickerViewWillDissmiss:(BZRBirthDatePickerView *)datePickerView
{
    [self hidePickerView:self.birthDatePicker inView:self.currentParentView withCompletion:^{
        [datePickerView removeFromSuperview];
    }];
}

#pragma mark

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
