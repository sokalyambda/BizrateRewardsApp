//
//  BZRTermsAndConditionsHelper.h
//  BizrateRewards
//
//  Created by Eugenity on 13.07.15.
//  Copyright (c) 2015 ThinkMobiles. All rights reserved.
//

typedef enum : NSUInteger {
    BZRConditionsTypePrivacyPolicy,
    BZRConditionsTypeTermsAndConditions,
    BZRConditionsTypeUserAgreement
} BZRConditionsType;

@interface BZRTermsAndConditionsHelper : NSObject

+ (void)showPrivacyAndTermsWithType:(BZRConditionsType)type andWithNavigationController:(UINavigationController *)navigationController;

@end
