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

typedef NS_ENUM(NSInteger, BZRRedirectionURLHandlingErrorCode) {
    BZRRedirectionURLHandlingErrorCodeEmptyURL = -1992,
    BZRRedirectionURLHandlingErrorCodeNullURL,
    BZRRedirectionURLHandlingErrorCodeEmptyPathComponents,
    BZRRedirectionURLHandlingErrorCodeIncorrectPathComponents,
};

@interface BZRRedirectionHelper : NSObject

+ (void)showPrivacyAndTermsWithType:(BZRConditionsType)type andWithPresentingController:(UIViewController *)presentingController;

+ (void)redirectWithURL:(NSURL *)url withError:(NSError * __autoreleasing *)error;

+ (void)performSignOut;

+ (void)redirectToDashboardController;

@end
