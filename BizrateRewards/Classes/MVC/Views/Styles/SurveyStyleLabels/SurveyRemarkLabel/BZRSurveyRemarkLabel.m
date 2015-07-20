//
//  BZRSurveyRemarkLabel.m
//  BizrateRewards
//
//  Created by Admin on 20.07.15.
//  Copyright (c) 2015 Connexity. All rights reserved.
//

#import "BZRSurveyRemarkLabel.h"
#import "UIFont+Styles.h"

@implementation BZRSurveyRemarkLabel

- (void)drawTextInRect:(CGRect)rect
{
    [self setFont:[UIFont surveyRemarkFont]];
    [super drawTextInRect:rect];
}

@end
