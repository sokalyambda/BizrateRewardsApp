//
//  BZRTermsAndConditionsHelper.m
//  BizrateRewards
//
//  Created by Eugenity on 13.07.15.
//  Copyright (c) 2015 Connexity. All rights reserved.
//

#import "BZRRedirectionHelper.h"
#import "BZRCustomURLHandler.h"

#import "BZRPrivacyAndTermsController.h"
#import "BZRSuccessResettingController.h"
#import "BZRFailureResettingController.h"
#import "BZRBaseNavigationController.h"

#import "BZRProjectFacade.h"

#import "AppDelegate.h"

static NSString *const kStoryboardName = @"Main";

static NSString *const kIsResettingSuccess = @"isResettingSuccess";

static NSString *const kAppURLPrefix = @"com.bizraterewards://";

static NSString *const kTermsLink = @"http://www.bizraterewards.com/mobile-terms.html";
static NSString *const kPrivacyLink = @"http://www.bizraterewards.com/mobile-privacy.html";
static NSString *const kUserAgreementLink = @"http://www.bizraterewards.com/program-terms.html";

@implementation BZRRedirectionHelper

/**
 *  Show chosen privacy&terms controller
 *
 *  @param type                 Type of privacy
 *  @param navigationController Navigation controller that will push the privacy controller
 */
+ (void)showPrivacyAndTermsWithType:(BZRConditionsType)type andWithNavigationController:(UINavigationController *)navigationController
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:kStoryboardName bundle:[NSBundle mainBundle]];
    
    BZRPrivacyAndTermsController *controller = [storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([BZRPrivacyAndTermsController class])];
    
    NSString *currentURLString;
    
    switch (type) {
        case BZRConditionsTypePrivacyPolicy:
            controller.navigationItem.title = LOCALIZED(@"Privacy Policy");
            currentURLString = kPrivacyLink;
            break;
        case BZRConditionsTypeTermsAndConditions:
            controller.navigationItem.title = LOCALIZED(@"Terms and Conditions");
            currentURLString = kTermsLink;
            break;
        case BZRConditionsTypeUserAgreement:
            controller.navigationItem.title = LOCALIZED(@"User Agreement");
            currentURLString = kUserAgreementLink;
            break;
            
        default:
            break;
    }
    
    controller.currentURL = [NSURL URLWithString:currentURLString];
    [navigationController pushViewController:controller animated:YES];
}

/**
 *  When we get the url on app opening (after password reseting), we have to redirect the user to correctly finish reset password controller to show whether the result was success or failure.
 *
 *  @param redirectURL          URL which has to be parsed for determining destination controller
 */
+ (void)showResetPasswordResultControllerWithObtainedURL:(NSURL *)redirectURL
{
    if (!redirectURL || redirectURL.isFileURL || ![redirectURL.absoluteString containsString:kAppURLPrefix] || [redirectURL.absoluteString isEqualToString:kAppURLPrefix] || [BZRProjectFacade isUserSessionValid]) {
        return;
    }
    
    //app opened with URL
    [BZRStorageManager sharedStorage].appOpenedWithURL = YES;
    
    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    BZRBaseNavigationController *rootController = (BZRBaseNavigationController *)appDelegate.window.rootViewController;
    
    NSDictionary *parsedParameters = [BZRCustomURLHandler urlParsingParametersFromURL:redirectURL];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:kStoryboardName bundle:[NSBundle mainBundle]];
    
    if (parsedParameters.count) {
        BOOL isResetingSuccess = [parsedParameters[kIsResettingSuccess] boolValue];
        
        BZRBaseViewController *redirectedController;
        if (isResetingSuccess) {
            redirectedController = [storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([BZRSuccessResettingController class])];
        } else {
            redirectedController = [storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([BZRFailureResettingController class])];
            ((BZRFailureResettingController *)redirectedController).failReason = parsedParameters[@"failReasonMessage"];
        }
        
        //if modal controller was presented - dismiss it
        for (UIViewController *controller in rootController.viewControllers) {
            [controller.presentedViewController dismissViewControllerAnimated:YES completion:nil];
        }
        
        [rootController pushViewController:redirectedController animated:YES];
    }
}

@end