//
//  BZRSurveyPointsValueLabel.m
//  BizrateRewards
//
//  Created by Admin on 20.07.15.
//  Copyright (c) 2015 Connexity. All rights reserved.
//

#import "BZRSurveyPointsValueLabel.h"
#import "UIFont+Styles.h"

@implementation BZRSurveyPointsValueLabel

- (void)drawTextInRect:(CGRect)rect
{
    [self setFont:[UIFont surveyPointsValueFont]];
    [super drawTextInRect:rect];
}

@end
