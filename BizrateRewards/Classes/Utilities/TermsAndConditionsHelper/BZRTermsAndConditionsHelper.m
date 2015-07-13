//
//  BZRTermsAndConditionsHelper.m
//  BizrateRewards
//
//  Created by Eugenity on 13.07.15.
//  Copyright (c) 2015 ThinkMobiles. All rights reserved.
//

#import "BZRTermsAndConditionsHelper.h"
#import "BZRPrivacyAndTermsController.h"

static NSString *const kStoryboardName = @"Main";

@implementation BZRTermsAndConditionsHelper


+ (void)showPrivacyAndTermsWithType:(BZRConditionsType)type andWithNavigationController:(UINavigationController *)navigationController
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:kStoryboardName bundle:[NSBundle mainBundle]];
    
    BZRPrivacyAndTermsController *controller = [storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([BZRPrivacyAndTermsController class])];
    
    NSString *currentURLString;
    
    switch (type) {
        case BZRConditionsTypePrivacyPolicy:
            controller.navigationItem.title = NSLocalizedString(@"Privacy Policy", nil);
            currentURLString = @"urlForPrivacyPolicy";
            break;
        case BZRConditionsTypeTermsAndConditions:
            controller.navigationItem.title = NSLocalizedString(@"Terms and Conditions", nil);
            currentURLString = @"urlForTermsAndConditions";
            break;
        case BZRConditionsTypeUserAgreement:
            controller.navigationItem.title = NSLocalizedString(@"User Agreement", nil);
            currentURLString = @"urlForUserAgreement";
            break;
            
        default:
            break;
    }
    
    controller.currentURL = [NSURL URLWithString:currentURLString];
    [navigationController pushViewController:controller animated:YES];
}

@end
