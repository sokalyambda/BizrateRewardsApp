//
//  BZRGetStartedController.m
//  BizrateRewards
//
//  Created by Eugenity on 23.06.15.
//  Copyright (c) 2015 ThinkMobiles. All rights reserved.
//

#import "BZRGetStartedController.h"
#import "BZRPrivacyAndTermsController.h"
#import "BZREditProfileContainerController.h"

typedef enum : NSUInteger {
    BZRConditionsTypePrivacyPolicy,
    BZRConditionsTypeTermsAndConditions
} BZRPrivacyAndTermsType;

static NSString *const kEditProfileContainerSegueIdentifier = @"editProfileContainerSegue";
static NSString *const kChooseSignUpTypeSegueIdentifier = @"сhooseSignUpTypeSegue";

@interface BZRGetStartedController ()<UITextFieldDelegate>

@property (weak, nonatomic) BZREditProfileContainerController *editProfileTableViewController;

@end

@implementation BZRGetStartedController

#pragma mark - View Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
}

#pragma mark - Actions

- (IBAction)privacyPolicyClick:(id)sender
{
    [self showPrivacyAndTermsWithType:BZRConditionsTypePrivacyPolicy];
}

- (IBAction)termsAndConditionsClick:(id)sender
{
    [self showPrivacyAndTermsWithType:BZRConditionsTypeTermsAndConditions];
}

- (void)showPrivacyAndTermsWithType:(BZRPrivacyAndTermsType)type
{
    BZRPrivacyAndTermsController *controller = [self.storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([BZRPrivacyAndTermsController class])];
    
    NSString *currentURLString;
    
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

- (IBAction)submitButtonClick:(id)sender {
    
    if([self.validator validateFirstNameField:self.editProfileTableViewController.firstNameField
                                lastNameField:self.editProfileTableViewController.lastNameField
                                   emailField:self.editProfileTableViewController.emailField
                             dateOfBirthField:self.editProfileTableViewController.dateOfBirthField
                                  genderField:self.editProfileTableViewController.genderField]) {
        [self performSegueWithIdentifier:kChooseSignUpTypeSegueIdentifier sender:self];
        
    } else {
        ShowAlert(self.validator.validationErrorString);
        [self.validator cleanValidationErrorString];
    }
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:kEditProfileContainerSegueIdentifier]) {
        self.editProfileTableViewController = (BZREditProfileContainerController *)segue.destinationViewController;
    }
}

@end
