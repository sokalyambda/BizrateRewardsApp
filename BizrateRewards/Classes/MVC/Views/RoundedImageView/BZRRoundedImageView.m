//
//  RoundedImageView.m
//  DressCode
//
//  Created by Hedgehog on 16.04.15.
//  Copyright (c) 2015 ThinkMobiles. All rights reserved.
//

#import "BZRRoundedImageView.h"

@implementation BZRRoundedImageView

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    [self customize];
}

- (void)setBounds:(CGRect)bounds
{
    [super setBounds:bounds];
    [self customize];
}

- (void)customize
{
    self.layer.cornerRadius = CGRectGetHeight(self.bounds) / 2.f;
    self.layer.masksToBounds = YES;
    self.layer.borderColor = self.borderColor ? self.borderColor.CGColor : [UIColor lightGrayColor].CGColor;
    self.layer.borderWidth =  self.layer.borderWidth ?: 1.f;
}

- (void)setBorderColor:(UIColor *)borderColor
{
    _borderColor = borderColor;
    [self customize];
}

@end
