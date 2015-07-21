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

@end

@implementation BZRHighlightedButton

#pragma mark - Accessors

- (void)setHighlighted:(BOOL)highlighted
{
    [UIView animateWithDuration:0.1f animations:^{
        self.backgroundColor = highlighted ? [UIColor colorWithWhite:.6f alpha:0.4f] : self.savedBackgroundColor;
    }];
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
