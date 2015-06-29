//
//  CSTBorderedTextField.m
//  CarusselSalesTool
//
//  Created by Eugenity on 02.06.15.
//  Copyright (c) 2015 ThinkMobiles. All rights reserved.
//

#import "BZRBorderedTextField.h"

static CGFloat kLeftViewWidth = 10.f;

@interface BZRBorderedTextField ()

@end

@implementation BZRBorderedTextField

#pragma mark - Lifecycle

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
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
    [self addTopBorder];
    [self addBottomBorder];
    [self addLeftView];
}

- (void)addLeftView
{
    self.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kLeftViewWidth, CGRectGetHeight(self.frame))];
    self.leftViewMode = UITextFieldViewModeAlways;
}

- (void)addTopBorder
{
    CALayer *topBorderLayer = [CALayer layer];
    topBorderLayer.frame = CGRectMake(0, 0, CGRectGetWidth(self.frame), 0.5f);
    topBorderLayer.backgroundColor = [UIColor lightGrayColor].CGColor;
    [self.layer addSublayer:topBorderLayer];
}

- (void)addBottomBorder
{
    CALayer *topBorderLayer = [CALayer layer];
    topBorderLayer.frame = CGRectMake(0, CGRectGetMaxY(self.frame) - 0.5f, CGRectGetWidth(self.frame), 0.5f);
    topBorderLayer.backgroundColor = [UIColor lightGrayColor].CGColor;
    [self.layer addSublayer:topBorderLayer];
}

@end
