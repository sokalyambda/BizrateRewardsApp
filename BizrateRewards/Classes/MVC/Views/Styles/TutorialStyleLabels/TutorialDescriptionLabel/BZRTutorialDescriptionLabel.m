//
//  BZRTutorialDescriptionLabel.m
//  BizrateRewards
//
//  Created by Eugenity on 20.07.15.
//  Copyright (c) 2015 Connexity. All rights reserved.
//

#import "BZRTutorialDescriptionLabel.h"
#import "UIFont+Styles.h"

@implementation BZRTutorialDescriptionLabel

- (void)drawTextInRect:(CGRect)rect
{
    [self setFont:[UIFont tutorialDesciptionFont]];
    [super drawTextInRect:rect];
}

@end
