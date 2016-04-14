//
//  BZRShareTitleLabel.m
//  Bizrate Rewards
//
//  Created by Kate Chupova on 4/14/16.
//  Copyright © 2016 Connexity. All rights reserved.
//

#import "BZRShareTitleLabel.h"

#import "UIFont+Styles.h"

@implementation BZRShareTitleLabel

- (void)drawTextInRect:(CGRect)rect
{
    [self setFont:[UIFont shareTitleFont]];
    [super drawTextInRect:rect];
}

@end
