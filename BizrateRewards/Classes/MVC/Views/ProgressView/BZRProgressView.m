//
//  ProgressView.m
//  AnimationView
//
//  Created by Admin on 02.07.15.
//  Copyright (c) 2015 Admin. All rights reserved.
//

#import "BZRProgressView.h"

@interface BZRProgressView ()

@property (assign, nonatomic) CGFloat progress;

@property (assign, nonatomic, getter=isMaxPointsEarned) BOOL maxPointsEarned;

@property (strong, nonatomic) UIColor *currentColor;

@end

@implementation BZRProgressView

#pragma mark - Accessors

- (UIColor *)currentColor
{
    return self.isMaxPointsEarned ? UIColorFromRGB(0xf9105e) : UIColorFromRGB(0x19cb86);
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, self.currentColor.CGColor);
    UIRectFill(CGRectMake(0.f, 0.f, self.progress, CGRectGetHeight(self.frame)));
}

#pragma mark - Actions

- (void)recalculateProgressWithCurrentPoints:(NSInteger)currentPoints requiredPoints:(NSInteger)requiredPoints withCompletion:(void(^)(BOOL maxPointsEarned))completion
{
    self.progress = (CGFloat)currentPoints * CGRectGetWidth(self.frame) / (CGFloat)requiredPoints;
    [self setNeedsDisplay];
    
    self.maxPointsEarned = (currentPoints >= requiredPoints && requiredPoints != 0.f);
    
    if (completion) {
        completion(self.maxPointsEarned);
    }
}

@end
