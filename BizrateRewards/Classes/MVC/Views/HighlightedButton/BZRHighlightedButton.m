//
//  BZRHighlightedButton.m
//  BizrateRewards
//
//  Created by Eugenity on 21.07.15.
//  Copyright (c) 2015 Connexity. All rights reserved.
//

#import "BZRHighlightedButton.h"

@interface BZRHighlightedButton ()

@property (strong, nonatomic) UIColor *savedBackgroundColor;

@property (strong, nonatomic) UIColor *currentBackgroundColor;
@property (strong, nonatomic) UIColor *currentTitleTextColor;

@property (strong, nonatomic) CALayer *highlightedLayer;

@end

@implementation BZRHighlightedButton

#pragma mark - Accessors

- (CALayer *)highlightedLayer
{
    if (!_highlightedLayer) {
        _highlightedLayer = [CALayer layer];
        _highlightedLayer.frame = self.bounds;
        _highlightedLayer.backgroundColor = [UIColor colorWithWhite:.5f alpha:0.4f].CGColor;
    }
    return _highlightedLayer;
}

- (UIColor *)currentBackgroundColor
{
    return self.enabled ? self.savedBackgroundColor : UIColorFromRGB(0xD7D7D7);
}

- (UIColor *)currentTitleTextColor
{
    return self.enabled ? [UIColor whiteColor] : UIColorFromRGB(0x878787);
}

- (void)setHighlighted:(BOOL)highlighted
{
    [super setHighlighted:highlighted];
    if (highlighted) {
        [self.layer addSublayer:self.highlightedLayer];
    } else {
        [self.highlightedLayer removeFromSuperlayer];
    }
}

- (void)setEnabled:(BOOL)enabled
{
    [super setEnabled:enabled];
    
    if (!enabled) {
        [self setTitle:LOCALIZED(@"Please check back later!") forState:UIControlStateNormal];
    } else {
        [self setTitle:LOCALIZED(@"TAKE A SURVEY") forState:UIControlStateNormal];
    }
    
    self.backgroundColor = self.currentBackgroundColor;
    [self setTitleColor:self.currentTitleTextColor forState:UIControlStateNormal];
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
    self.savedBackgroundColor = self.backgroundColor;
}

@end
