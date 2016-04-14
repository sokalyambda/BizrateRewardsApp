//
//  BZRShareCodeLabel.m
//  Bizrate Rewards
//
//  Created by Kate Chupova on 4/14/16.
//  Copyright © 2016 Connexity. All rights reserved.
//

#import "BZRShareCodeLabel.h"

#import "UIFont+Styles.h"

@implementation BZRShareCodeLabel

- (void)drawTextInRect:(CGRect)rect
{
    [self setFont:[UIFont shareCodeFont]];
    [super drawTextInRect:rect];
}

@end
