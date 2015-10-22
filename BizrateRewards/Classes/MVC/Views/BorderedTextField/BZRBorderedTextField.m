//
//  CSTBorderedTextField.m
//  CarusselSalesTool
//
//  Created by Eugenity on 02.06.15.
//  Copyright (c) 2015 Connexity. All rights reserved.
//

#import "BZRBorderedTextField.h"

static CGFloat kLeftViewWidth = 10.f;

@interface BZRBorderedTextField ()

@property (strong, nonatomic) CALayer *bottomBorderLayer;
@property (strong, nonatomic) CALayer *topBorderLayer;

@end

@implementation BZRBorderedTextField

 - (void)drawRect:(CGRect)rect
{
    [self addTopBorder];
}

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
    [self addLeftView];
}

#pragma mark - Actions

- (void)addLeftView
{
    self.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kLeftViewWidth, CGRectGetHeight(self.frame))];
    self.leftViewMode = UITextFieldViewModeAlways;
}

- (void)addTopBorder
{
    self.topBorderLayer = [CALayer layer];
    self.topBorderLayer.frame = CGRectMake(0, 0, CGRectGetWidth(self.frame), 0.5f);
    self.topBorderLayer.backgroundColor = [UIColor lightGrayColor].CGColor;
    [self.layer addSublayer:self.topBorderLayer];
}

- (void)addBottomBorder
{
    self.bottomBorderLayer = [CALayer layer];
    self.bottomBorderLayer.frame = CGRectMake(0, CGRectGetHeight(self.frame) - 0.5f, CGRectGetWidth(self.frame), 0.5f);
    self.bottomBorderLayer.backgroundColor = [UIColor lightGrayColor].CGColor;
    [self.layer addSublayer:self.bottomBorderLayer];
}

@end
