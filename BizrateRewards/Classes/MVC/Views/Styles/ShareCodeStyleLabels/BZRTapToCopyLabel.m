//
//  BZRTapToCopyLabel.m
//  Bizrate Rewards
//
//  Created by Kate Chupova on 4/14/16.
//  Copyright © 2016 Connexity. All rights reserved.
//

#import "BZRTapToCopyLabel.h"

#import "UIFont+Styles.h"

@implementation BZRTapToCopyLabel

- (void)drawTextInRect:(CGRect)rect
{
    [self setFont:[UIFont tapToCopyFont]];
    [super drawTextInRect:rect];
}

@end
