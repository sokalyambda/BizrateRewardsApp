//
//  BZRSurveyPointsInscriptionLabel.m
//  BizrateRewards
//
//  Created by Admin on 20.07.15.
//  Copyright (c) 2015 Connexity. All rights reserved.
//

#import "BZRSurveyPointsInscriptionLabel.h"
#import "UIFont+Styles.h"

@implementation BZRSurveyPointsInscriptionLabel

- (void)drawTextInRect:(CGRect)rect
{
    [self setFont:[UIFont surveyPointsInscriptionFont]];
    [super drawTextInRect:rect];
}

@end
