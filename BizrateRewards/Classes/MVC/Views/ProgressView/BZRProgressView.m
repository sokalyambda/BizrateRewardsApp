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

@end

@implementation BZRProgressView

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, UIColorFromRGB(0x19cb86).CGColor);
    UIRectFill(CGRectMake(0.f, 0.f, self.progress, CGRectGetHeight(self.frame)));
}

- (void)recalculateProgressWithCurrentPoints:(NSInteger)currentPoints requiredPoints:(NSInteger)requiredPoints
{
    self.progress  = (CGFloat)currentPoints * CGRectGetWidth(self.frame) / (CGFloat)requiredPoints;
    [self setNeedsDisplay];
}

@end
