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

@end

@implementation BZRProgressView

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
    return self.isMaxPointsEarned ? UIColorFromRGB(0xf9105e) : UIColorFromRGB(0x19cb86);
}

#pragma mark - Actions

- (void)recalculateProgressWithCurrentPoints:(NSInteger)currentPoints requiredPoints:(NSInteger)requiredPoints withCompletion:(void(^)(BOOL maxPointsEarned))completion
{
    CGFloat progress = (CGFloat)currentPoints / (CGFloat)requiredPoints;
    
    self.maxPointsEarned = (currentPoints >= requiredPoints && requiredPoints != 0.f);
    
    if (!isnan(progress)) {
        [self setProgress:progress animated:YES];
        [self setProgressTintColor:self.currentColor];
    }
    
    if (completion) {
        completion(self.maxPointsEarned);
    }
}

@end
