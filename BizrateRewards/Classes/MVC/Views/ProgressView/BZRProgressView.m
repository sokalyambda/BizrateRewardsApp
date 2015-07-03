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
    CGContextSetFillColorWithColor(context, UIColorFromRGB(0x179B40).CGColor);
    UIRectFill(CGRectMake(0.f, 0.f, self.progress, CGRectGetHeight(self.frame)));
}

@end
