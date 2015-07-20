//
//  UIFont+Styles.m
//  BizrateRewards
//
//  Created by Eugenity on 18.07.15.
//  Copyright (c) 2015 Connexity. All rights reserved.
//

#import "UIFont+Styles.h"

static CGFloat const kTitelSmallFontSize = 18.f;
static CGFloat const kTitelMediumFontSize = 22.f;
static CGFloat const kTitelLargeFontSize = 26.f;

static CGFloat const kDescriptionSmallFontSize = 14.f;
static CGFloat const kDescriptionMediumFontSize = 16.f;
static CGFloat const kDescriptionLargeFontSize = 18.f;

static CGFloat const kPointsInscriptionSmallFontSize = 13.f;
static CGFloat const kPointsInscriptionMediumFontSize = 15.f;
static CGFloat const kPointsInscriptionLargeFontSize = 17.f;

static CGFloat const kPointsValueSmallFontSize = 16.f;
static CGFloat const kPointsValueMediumFontSize = 18.f;
static CGFloat const kPointsValueLargeFontSize = 20.f;

static CGFloat const kSurveyCongratsSmallFontSize = 12.f;
static CGFloat const kSurveyCongratsMediumFontSize = 14.f;
static CGFloat const kSurveyCongratsLargeFontSize = 16.f;

static CGFloat const kSurveyRemarkSmallFontSize = 11.f;
static CGFloat const kSurveyRemarkMediumFontSize = 13.f;
static CGFloat const kSurveyRemarkLargeFontSize = 15.f;




@implementation UIFont (Styles)

+ (UIFont *)tutorialTitleFont
{
    if (IS_IPHONE_5) {
        return [UIFont fontWithName:@"OpenSans" size:kTitelSmallFontSize];
    } else if (IS_IPHONE_6) {
        return [UIFont fontWithName:@"OpenSans" size:kTitelMediumFontSize];
    } else {
        return [UIFont fontWithName:@"OpenSans" size:kTitelLargeFontSize];
    }
}

+ (UIFont *)tutorialDesciptionFont
{
    if (IS_IPHONE_5) {
        return [UIFont fontWithName:@"OpenSans" size:kDescriptionSmallFontSize];
    } else if (IS_IPHONE_6) {
        return [UIFont fontWithName:@"OpenSans" size:kDescriptionMediumFontSize];
    } else {
        return [UIFont fontWithName:@"OpenSans" size:kDescriptionLargeFontSize];
    }
}

+ (UIFont *)surveyPointsInscriptionFont
{
    if (IS_IPHONE_5) {
        return [UIFont fontWithName:@"OpenSans-Semibold" size:kPointsInscriptionSmallFontSize];
    } else if (IS_IPHONE_6) {
        return [UIFont fontWithName:@"OpenSans-Semibold" size:kPointsInscriptionMediumFontSize];
    } else {
        return [UIFont fontWithName:@"OpenSans-Semibold" size:kPointsInscriptionLargeFontSize];
    }
}

+ (UIFont *)surveyPointsValueFont
{
    if (IS_IPHONE_5) {
        return [UIFont fontWithName:@"OpenSans-Bold" size:kPointsValueSmallFontSize];
    } else if (IS_IPHONE_6) {
        return [UIFont fontWithName:@"OpenSans-Bold" size:kPointsValueMediumFontSize];
    } else {
        return [UIFont fontWithName:@"OpenSans-Bold" size:kPointsValueLargeFontSize];
    }
}

+ (UIFont *)surveyCongratsFont
{
    if (IS_IPHONE_5) {
        return [UIFont fontWithName:@"OpenSans-Semibold" size:kSurveyCongratsSmallFontSize];
    } else if (IS_IPHONE_6) {
        return [UIFont fontWithName:@"OpenSans-Semibold" size:kSurveyCongratsMediumFontSize];
    } else {
        return [UIFont fontWithName:@"OpenSans-Semibold" size:kSurveyCongratsLargeFontSize];
    }
}

+ (UIFont *)surveyRemarkFont
{
    if (IS_IPHONE_5) {
        return [UIFont fontWithName:@"OpenSans" size:kSurveyRemarkSmallFontSize];
    } else if (IS_IPHONE_6) {
        return [UIFont fontWithName:@"OpenSans" size:kSurveyRemarkMediumFontSize];
    } else {
        return [UIFont fontWithName:@"OpenSans" size:kSurveyRemarkLargeFontSize];
    }
}



@end
