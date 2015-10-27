//
//  ProgressView.m
//  AnimationView
//
//  Created by Eugenity on 02.07.15.
//  Copyright (c) 2015 Connexity. All rights reserved.
//

#import "BZRProgressView.h"

#import <math.h>

@interface BZRProgressView ()

@property (assign, nonatomic, getter=isMaxPointsEarned) BOOL maxPointsEarned;

@property (strong, nonatomic) UIColor *currentColor;

@property (assign, nonatomic) CGFloat savedProgress;

@end

@implementation BZRProgressView

#pragma mark - Accessors

- (void)setSavedProgress:(CGFloat)savedProgress
{
    if (fabs(_savedProgress - savedProgress) > FLT_EPSILON) {
        _savedProgress = savedProgress;
        [self setProgress:_savedProgress animated:YES];
        [self setProgressTintColor:self.currentColor];
    }
}

#pragma mark - Lifecycle

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (void)commonInit
{
    self.progressViewStyle = UIProgressViewStyleBar;
    
    self.trackTintColor = UIColorFromRGB(0xe7e7e7);
}

#pragma mark - Accessors

- (UIColor *)currentColor
{
    return self.isMaxPointsEarned ? UIColorFromRGB(0x1bc886) : UIColorFromRGB(0x1e91d2); //if earned color will be green, otherwise - blue
}

#pragma mark - Actions

- (void)recalculateProgressWithCurrentPoints:(NSInteger)currentPoints requiredPoints:(NSInteger)requiredPoints withCompletion:(void(^)(BOOL maxPointsEarned))completion
{
    CGFloat progress = (CGFloat)currentPoints / (CGFloat)requiredPoints;
    
    self.maxPointsEarned = (currentPoints >= requiredPoints && requiredPoints != 0.f);
    
    if (!isnan(progress)) {
        self.savedProgress = progress;
    }
    
    if (completion) {
        completion(self.maxPointsEarned);
    }
}

@end
