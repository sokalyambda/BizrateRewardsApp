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

@property (strong, nonatomic) CALayer *highlightedLayer;

@end

@implementation BZRHighlightedButton

#pragma mark - Accessors

- (CALayer *)highlightedLayer
{
    if (!_highlightedLayer) {
        _highlightedLayer = [CALayer layer];
        _highlightedLayer.frame = self.bounds;
        _highlightedLayer.backgroundColor = [UIColor colorWithWhite:.6f alpha:0.6f].CGColor;
    }
    return _highlightedLayer;
}

- (void)setHighlighted:(BOOL)highlighted
{
    if (highlighted) {
        [self.layer addSublayer:self.highlightedLayer];
    } else {
        [self.highlightedLayer removeFromSuperlayer];
    }
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
