//
//  BZRSurveyCongratsLabel.m
//  BizrateRewards
//
//  Created by Admin on 20.07.15.
//  Copyright (c) 2015 Connexity. All rights reserved.
//

#import "BZRSurveyCongratsLabel.h"
#import "UIFont+Styles.h"

@implementation BZRSurveyCongratsLabel

- (void)drawTextInRect:(CGRect)rect
{
    [self setFont:[UIFont surveyCongratsFont]];
    [super drawTextInRect:rect];
}

@end
