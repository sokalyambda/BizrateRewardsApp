//
//  BZRGetStartedController.m
//  BizrateRewards
//
//  Created by Eugenity on 23.06.15.
//  Copyright (c) 2015 ThinkMobiles. All rights reserved.
//

#import "BZRGetStartedController.h"
#import "BZRPrivacyAndTermsController.h"

typedef enum : NSUInteger {
    BZRConditionsTypePrivacyPolicy,
    BZRConditionsTypeTermsAndConditions
} BZRPrivacyAndTermsType;

@interface BZRGetStartedController ()<UITextFieldDelegate>

@end

@implementation BZRGetStartedController

#pragma mark - View Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.view layoutIfNeeded];
}

- (void)showPrivacyAndTermsWithType:(BZRPrivacyAndTermsType)type
{
    BZRPrivacyAndTermsController *controller = [self.storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([BZRPrivacyAndTermsController class])];
    
    NSString *currentURLString = [NSString string];
    
    switch (type) {
        case BZRConditionsTypePrivacyPolicy:
            currentURLString = @"urlForPrivacyPolicy";
            break;
        case BZRConditionsTypeTermsAndConditions:
            currentURLString = @"urlForTermsAndConditions";
            break;
            
        default:
            break;
    }
    
    controller.currentURL = [NSURL URLWithString:currentURLString];
    [self.navigationController pushViewController:controller animated:YES];
}

#pragma mark - IBActions

- (IBAction)privacyPolicyClick:(id)sender
{
    [self showPrivacyAndTermsWithType:BZRConditionsTypePrivacyPolicy];
}

- (IBAction)termsAndConditionsClick:(id)sender
{
    [self showPrivacyAndTermsWithType:BZRConditionsTypeTermsAndConditions];
}

@end
