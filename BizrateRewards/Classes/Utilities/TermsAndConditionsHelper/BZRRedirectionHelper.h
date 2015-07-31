//
//  BZRTermsAndConditionsHelper.h
//  BizrateRewards
//
//  Created by Eugenity on 13.07.15.
//  Copyright (c) 2015 Connexity. All rights reserved.
//

typedef enum : NSUInteger {
    BZRConditionsTypePrivacyPolicy,
    BZRConditionsTypeTermsAndConditions,
    BZRConditionsTypeUserAgreement
} BZRConditionsType;

@interface BZRRedirectionHelper : NSObject

+ (void)showPrivacyAndTermsWithType:(BZRConditionsType)type andWithNavigationController:(UINavigationController *)navigationController;

+ (void)showResetPasswordResultControllerWithObtainedURL:(NSURL *)redirectURL andWithNavigationController:(UINavigationController *)navigationController;

@end
