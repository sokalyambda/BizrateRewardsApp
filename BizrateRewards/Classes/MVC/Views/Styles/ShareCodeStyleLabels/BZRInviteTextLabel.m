//
//  BZRInviteTextLabel.m
//  Bizrate Rewards
//
//  Created by Kate Chupova on 4/13/16.
//  Copyright © 2016 Connexity. All rights reserved.
//

#import "BZRInviteTextLabel.h"

#import "UIFont+Styles.h"

@implementation BZRInviteTextLabel

#pragma mark - Lifecycle

- (void)drawTextInRect:(CGRect)rect
{
    [self setFont:[UIFont inviteTextFont]];
    [super drawTextInRect:rect];
}

@end
