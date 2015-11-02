//
//  BZRTermsAndConditionsHelper.m
//  BizrateRewards
//
//  Created by Eugenity on 13.07.15.
//  Copyright (c) 2015 Connexity. All rights reserved.
//

typedef NS_ENUM(NSUInteger, BZRCustomURLPathType) {
    BZRCustomURLPathTypeIncorrect,
    BZRCustomURLPathTypeSurvey,
    BZRCustomURLPathTypeResetPassword
};

#import "BZRRedirectionHelper.h"
#import "BZRCustomURLHandler.h"

#import "BZRPrivacyAndTermsController.h"
#import "BZRSuccessResettingController.h"
#import "BZRFailureResettingController.h"
#import "BZRBaseNavigationController.h"
#import "BZRSurveyViewController.h"

#import "BZRProjectFacade.h"
#import "BZRSurveyService.h"
#import "BZRFacebookService.h"

#import "AppDelegate.h"

static NSString *const kStoryboardName = @"Main";

static NSString *const kIsResettingSuccess = @"isResettingSuccess";

static NSString *const kAppURLPrefix = @"com.bizraterewards://";

static NSString *const kTermsLink = @"http://www.bizraterewards.com/mobile-terms.html";

static NSString *const kSurveyId = @"surveyId";

static NSString *const kRedirectionError = @"redirectionError";
static NSString *const kErrorDomain = @"com.thinkmobiles";

static NSString *const kSurveyPath = @"survey";
static NSString *const kLatestPath = @"latest";
static NSString *const kResetPasswordPath = @"reset_password";

@implementation BZRRedirectionHelper

/**
 *  Show chosen privacy&terms controller
 *
 *  @param type                 Type of privacy
 *  @param navigationController Navigation controller that will push the privacy controller
 */
+ (void)showPrivacyAndTermsWithType:(BZRConditionsType)type andWithPresentingController:(UIViewController *)presentingController
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:kStoryboardName bundle:[NSBundle mainBundle]];
    
    BZRPrivacyAndTermsController *controller = [storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([BZRPrivacyAndTermsController class])];
    BZRBaseNavigationController *navigationController = [[BZRBaseNavigationController alloc] initWithRootViewController:controller];
    
    NSString *currentURLString;
    
    switch (type) {
        case BZRConditionsTypeTermsAndConditions:
            controller.navigationItem.title = LOCALIZED(@"Program Terms");
            currentURLString = kTermsLink;
            break;
        default:
            break;
    }
    
    controller.currentURL = [NSURL URLWithString:currentURLString];
    
    [presentingController presentViewController:navigationController animated:YES completion:nil];
}

/**
 *  When we get the url on app opening (after password reseting), we have to redirect the user to correctly finish reset password controller to show whether the result was success or failure.
 *
 *  @param redirectURL          URL which has to be parsed for determining destination controller
 */
+ (void)showResetPasswordResultControllerWithObtainedURL:(NSURL *)redirectURL
{
    if (redirectURL.isFileURL || ![redirectURL.absoluteString containsString:kAppURLPrefix] || [redirectURL.absoluteString isEqualToString:kAppURLPrefix] || [BZRProjectFacade isUserSessionValid]) {
        return;
    }
    
    //app opened with URL
    [BZRStorageManager sharedStorage].resetPasswordFlow = YES;
    
    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    BZRBaseNavigationController *rootController = (BZRBaseNavigationController *)appDelegate.window.rootViewController;
    
    NSDictionary *parsedParameters = [BZRCustomURLHandler urlParsingParametersForPasswordResetFromURL:redirectURL];
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

/**
 *  Application was opened by URL for survey presentation
 *
 *  @param redirectURL URL
 */
+ (void)showSurveyControllerWithObtainedURL:(NSURL *)redirectURL
{
    if (redirectURL.isFileURL || ![redirectURL.absoluteString containsString:kAppURLPrefix] || [redirectURL.absoluteString isEqualToString:kAppURLPrefix]) {
        return;
    }
    
    if (([BZRProjectFacade isAutologinNeeded] || [BZRFacebookService isFacebookSessionValid]) && ![BZRProjectFacade isUserSessionValid]) {
        [BZRStorageManager sharedStorage].redirectedSurveyURL = redirectURL;
        return;
    } else if (![BZRProjectFacade isUserSessionValid]) {
        return;
    }
    
    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    BZRBaseNavigationController *rootController = (BZRBaseNavigationController *)appDelegate.window.rootViewController;
    
    NSDictionary *parsingParameters = [BZRCustomURLHandler urlParsingParametersForSurveyFromURL:redirectURL];
    NSString *surveyId = parsingParameters[kSurveyId];
    
    BZRSurveyViewController *neededController = [rootController.storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([BZRSurveyViewController class])];
    
    [MBProgressHUD showHUDAddedTo:appDelegate.window animated:YES];
    [BZRSurveyService getEligibleSurveysOnSuccess:^(NSArray *eligibleSurveys) {
        [MBProgressHUD hideAllHUDsForView:appDelegate.window animated:YES];
        
        if ([surveyId isEqualToString:kLatestPath]) {
            
            if (eligibleSurveys.count) {
                neededController.currentSurvey = eligibleSurveys.firstObject;
            } else {
                [BZRAlertFacade showAlertWithMessage:LOCALIZED(@"There are no surveys for you") forController:nil withCompletion:nil];
                return;
            }
            
        } else if (surveyId.length && [surveyId rangeOfCharacterFromSet:[NSCharacterSet alphanumericCharacterSet]].location != NSNotFound) {
            
            if (eligibleSurveys.count) {
                BZRSurvey *neededSurvey = [BZRSurveyService findSurveyWithId:surveyId inArray:eligibleSurveys];
                if (neededSurvey) {
                    neededController.currentSurvey = neededSurvey;
                } else {
                    [BZRAlertFacade showAlertWithMessage:LOCALIZED(@"Survey with this id doesn't exist.") forController:nil withCompletion:nil];
                    return;
                }
            } else {
                [BZRAlertFacade showAlertWithMessage:LOCALIZED(@"There are no surveys for you") forController:nil withCompletion:nil];
                return;
            }
        } else {
            [BZRAlertFacade showAlertWithMessage:LOCALIZED(@"Survey not found.") forController:nil withCompletion:nil];
            return;
        }
        
        @autoreleasepool {
            
            for (BZRBaseViewController *controller in rootController.viewControllers) {
                if ([controller isKindOfClass:[BZRSurveyViewController class]]) {
                    return;
                }
            }
            
            for (UIViewController *controller in rootController.viewControllers) {
                [controller.presentedViewController dismissViewControllerAnimated:YES completion:nil];
            }
        }
        
        
        [rootController pushViewController:neededController animated:YES];
        
    } onFailure:^(NSError *error, BOOL isCanceled) {
        [MBProgressHUD hideAllHUDsForView:appDelegate.window animated:YES];
        
    }];

}

/**
 *  Check whether url is for reset password or for surveys
 *
 *  @param url URL for parsing
 */
+ (void)redirectWithURL:(NSURL *)url withError:(NSError * __autoreleasing *)error
{
    if (!url) {
        *error = [NSError errorWithDomain:kErrorDomain
                                     code:BZRRedirectionURLHandlingErrorCodeNullURL
                                 userInfo:@{kRedirectionError: LOCALIZED(@"URL doesn't exist.")}];
        return;
    }
    
    NSString *urlString = url.absoluteString;
    if (!urlString.length) {
        *error = [NSError errorWithDomain:kErrorDomain
                                     code:BZRRedirectionURLHandlingErrorCodeEmptyURL
                                 userInfo:@{kRedirectionError: LOCALIZED(@"URL is empty.")}];
        return;
    }
    
    NSArray *pathComponents = url.absoluteString.pathComponents;
    
    BZRCustomURLPathType pathType = [self checkPathComponents:pathComponents withError:error];
    
    switch (pathType) {
        case BZRCustomURLPathTypeIncorrect:
            return;
        case BZRCustomURLPathTypeResetPassword: {
            //reset
            [self showResetPasswordResultControllerWithObtainedURL:url];
            break;
        }
        case BZRCustomURLPathTypeSurvey: {
            //survey
            [self showSurveyControllerWithObtainedURL:url];
            break;
        }
        default:
            break;
    }
}

/**
 *  Check path components
 */
+ (BZRCustomURLPathType)checkPathComponents:(NSArray *)components withError:(NSError *__autoreleasing *)error
{
    if (!components.count) {
        *error = [NSError errorWithDomain:kErrorDomain
                                    code:BZRRedirectionURLHandlingErrorCodeEmptyPathComponents
                                userInfo:@{kRedirectionError: LOCALIZED(@"Empty path components.")}];
        return BZRCustomURLPathTypeIncorrect;
    }
    
    if ([components containsObject:kSurveyPath]) {
        return BZRCustomURLPathTypeSurvey;
    } else if ([components containsObject:kResetPasswordPath]) {
        return BZRCustomURLPathTypeResetPassword;
    } else {
        *error = [NSError errorWithDomain:kErrorDomain
                                    code:BZRRedirectionURLHandlingErrorCodeIncorrectPathComponents
                                userInfo:@{kRedirectionError: LOCALIZED(@"Incorrect path components.")}];
        return BZRCustomURLPathTypeIncorrect;
    }

}

/**
 *  Sign out: clean user data and move to root controller.
 */
+ (void)performSignOut
{
    [BZRProjectFacade signOutOnSuccess:^(BOOL isSuccess) {
        
        BZRBaseNavigationController *rootController = (BZRBaseNavigationController *)[UIApplication sharedApplication].keyWindow.rootViewController;
        
        [CATransaction begin];
        [CATransaction setCompletionBlock:^{
            for (UIViewController *controller in rootController.viewControllers) {
                [controller.presentedViewController dismissViewControllerAnimated:YES completion:nil];
            }
        }];
        [rootController popToRootViewControllerAnimated:YES];;
        [CATransaction commit];
        
    } onFailure:^(NSError *error, BOOL isCanceled) {
        
    }];
}

@end
