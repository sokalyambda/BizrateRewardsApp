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

@end
