//
//  BZRIncreaseableButton.m
//  BizrateRewards
//
//  Created by Eugenity on 14.08.15.
//  Copyright (c) 2015 Connexity. All rights reserved.
//

#import "BZRIncreaseableButton.h"

@implementation BZRIncreaseableButton

- (void)setHighlighted:(BOOL)highlighted
{
    if (highlighted) {
        self.transform = CGAffineTransformMakeScale(1.1f, 1.1f);
    } else {
        self.transform = CGAffineTransformIdentity;
    }
}

@end
