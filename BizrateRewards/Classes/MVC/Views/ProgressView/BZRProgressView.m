//
//  ProgressView.m
//  AnimationView
//
//  Created by Admin on 02.07.15.
//  Copyright (c) 2015 Admin. All rights reserved.
//

#import "BZRProgressView.h"

@implementation BZRProgressView


- (void)drawRect:(CGRect)rect {
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [UIColor colorWithRed:23.0/255.0f green:155.0/255.0f blue:94.0/255.0f alpha:1.0].CGColor);
    UIRectFill(CGRectMake(0, 0, self.progress, CGRectGetHeight(self.frame)));
    
}


@end
