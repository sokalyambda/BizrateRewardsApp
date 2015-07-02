//
//  ProgressView.m
//  AnimationView
//
//  Created by Admin on 02.07.15.
//  Copyright (c) 2015 Admin. All rights reserved.
//

#import "BZRProgressView.h"

@implementation BZRProgressView

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [UIColor colorWithRed:23.f/255.f green:155.f/255.f blue:94.f/255.f alpha:1.f].CGColor);
    UIRectFill(CGRectMake(0.f, 0.f, self.progress, CGRectGetHeight(self.frame)));
}

@end
