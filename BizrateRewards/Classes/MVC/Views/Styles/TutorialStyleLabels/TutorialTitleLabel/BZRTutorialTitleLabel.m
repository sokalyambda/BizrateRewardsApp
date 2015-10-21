//
//  BZRTutorialTitleLabel.m
//  BizrateRewards
//
//  Created by Eugenity on 20.07.15.
//  Copyright (c) 2015 Connexity. All rights reserved.
//

#import "BZRTutorialTitleLabel.h"

#import "UIFont+Styles.h"

@implementation BZRTutorialTitleLabel

- (void)drawTextInRect:(CGRect)rect
{
    [self setFont:[UIFont tutorialTitleFont]];
    [super drawTextInRect:rect];
}

@end
