//
//  BZRGetStartedController.m
//  BizrateRewards
//
//  Created by Eugenity on 23.06.15.
//  Copyright (c) 2015 Connexity. All rights reserved.
//

#import "BZRGetStartedController.h"
#import "BZRPrivacyAndTermsController.h"
#import "BZREditProfileContainerController.h"
#import "BZRChooseSignUpTypeController.h"
#import "BZRDashboardController.h"

#import "BZRFacebookService.h"

#import "BZRRedirectionHelper.h"
#import "BZRCommonDateFormatter.h"

#import "BZRCheckBoxButton.h"
#import "BZREditProfileField.h"

#import "UIView+Flashable.h"

#import "BZRProjectFacade.h"

static NSString *const kEditProfileContainerSegueIdentifier = @"editProfileContainerSegue";
static NSString *const kChooseSignUpTypeSegueIdentifier = @"сhooseSignUpTypeSegue";

@interface BZRGetStartedController ()<UITextFieldDelegate>

@property (weak, nonatomic) BZREditProfileContainerController *editProfileTableViewController;

@property (strong, nonatomic) IBOutletCollection(BZRCheckBoxButton) NSArray *checkboxes;

@property (strong, nonatomic) BZRUserProfile *temporaryProfile;

@end

@implementation BZRGetStartedController

#pragma mark - View Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    //track mixpanel event
    [BZRMixpanelService trackEventWithType:BZRMixpanelEventSignupPage propertyValue:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    self.navigationItem.title = NSLocalizedString(@"Get Started", nil);
    
    [self prefillUserDataIfExists];
}

#pragma mark - Actions

- (IBAction)privacyPolicyClick:(id)sender
{
    [self showProgramTerms];
}

- (IBAction)termsAndConditionsClick:(id)sender
{
    [self showProgramTerms];
}

- (IBAction)submitButtonClick:(UIButton *)sender
{
    if (!self.isRedirectedFromFacebookSignInFlow) {
        [self submitUserData];
    } else {
        [self signUpWithFacebook];
    }
}

/**
 *  Creation of temporary profile
 */
- (void)createNewTemporaryProfile
{
    //first step in user creation
    self.temporaryProfile = [[BZRUserProfile alloc] init];
    
    self.temporaryProfile.firstName     = self.editProfileTableViewController.firstNameField.text;
    self.temporaryProfile.lastName      = self.editProfileTableViewController.lastNameField.text;
    self.temporaryProfile.genderString  = self.editProfileTableViewController.genderField.text;
    self.temporaryProfile.email         = self.editProfileTableViewController.emailField.text;
    self.temporaryProfile.dateOfBirth   = [[BZRCommonDateFormatter commonDateFormatter] dateFromString:self.editProfileTableViewController.dateOfBirthField.text];
}

/**
 *  Validation of entered user date and creation temporary user profile for registration.
 */
- (void)submitUserData
{
    WEAK_SELF;
    [BZRValidator validateFirstNameField:self.editProfileTableViewController.firstNameField
                           lastNameField:self.editProfileTableViewController.lastNameField
                              emailField:nil
                        dateOfBirthField:self.editProfileTableViewController.dateOfBirthField
                             genderField:self.editProfileTableViewController.genderField
                           andCheckboxes:self.checkboxes
                               onSuccess:^{
                                   
                                   [weakSelf createNewTemporaryProfile];
                                   
                                   [weakSelf performSegueWithIdentifier:kChooseSignUpTypeSegueIdentifier sender:weakSelf];
                               }
                               onFailure:^(NSMutableDictionary *errorDict) {
                                   [BZRValidator cleanValidationErrorDict];
                               }];
}

/**
 *  This method has to be called when user has been redirected from facebook signIn flow. When user with these credentials does not exist.
 */
- (void)signUpWithFacebook
{
    WEAK_SELF;
    [BZRValidator validateFirstNameField:self.editProfileTableViewController.firstNameField
                           lastNameField:self.editProfileTableViewController.lastNameField
                              emailField:nil
                        dateOfBirthField:self.editProfileTableViewController.dateOfBirthField
                             genderField:self.editProfileTableViewController.genderField
                           andCheckboxes:self.checkboxes
                               onSuccess:^{
                                   
                                   [weakSelf createNewTemporaryProfile];
                                   
                                   [MBProgressHUD showHUDAddedTo:weakSelf.view animated:YES];
                                   [BZRProjectFacade signUpWithFacebookWithUserFirstName:weakSelf.temporaryProfile.firstName andUserLastName:weakSelf.temporaryProfile.lastName andEmail:weakSelf.temporaryProfile.email andDateOfBirth:[[BZRCommonDateFormatter commonDateFormatter] stringFromDate:weakSelf.temporaryProfile.dateOfBirth] andGender:[weakSelf.temporaryProfile.genderString substringToIndex:1] onSuccess:^(BOOL isSuccess) {
                                       
                                       [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:YES];
                                       
                                       //detect success login with facebook
                                       [BZRFacebookService setLoginSuccess:YES];
                                       
                                       //change redirected state to 'NO' cause we have already registered success
                                       weakSelf.redirectedFromFacebookSignInFlow = NO;
                                       
                                       //go to dashboard
                                       BZRDashboardController *controller = [weakSelf.storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([BZRDashboardController class])];
                                       controller.updateNeeded = YES;
                                       [weakSelf.navigationController pushViewController:controller animated:YES];
                                       
                                   } onFailure:^(NSError *error, BOOL isCanceled) {
                                       [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:YES];
                                       
                                   }];
                               } onFailure:^(NSMutableDictionary *errorDict) {
                                   [BZRValidator cleanValidationErrorDict];
                               }];
}

/**
 *  If user has come from facebook signIn flow, we can prefill his information
 */
- (void)prefillDataFromSavedFacebookProfile
{
    BZRFacebookProfile *currentFacebookProfile = [BZRStorageManager sharedStorage].facebookProfile;
    
    self.editProfileTableViewController.firstNameField.text = currentFacebookProfile.firstName;
    self.editProfileTableViewController.lastNameField.text  = currentFacebookProfile.lastName;
    self.editProfileTableViewController.emailField.text     = currentFacebookProfile.email;
    self.editProfileTableViewController.genderField.text    = currentFacebookProfile.genderString;
}

/**
 *  Prefill user data (it could be the facebook profile or unregistered email).
 */
- (void)prefillUserDataIfExists
{
    if (self.isRedirectedFromFacebookSignInFlow) {
        [self prefillDataFromSavedFacebookProfile];
    } else if (self.failedToSignInEmail.length) {
        self.editProfileTableViewController.emailField.text = self.failedToSignInEmail;
    }
}

- (void)showProgramTerms
{
    [BZRRedirectionHelper showPrivacyAndTermsWithType:BZRConditionsTypeTermsAndConditions andWithPresentingController:self];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:kEditProfileContainerSegueIdentifier]) {
        self.editProfileTableViewController = (BZREditProfileContainerController *)segue.destinationViewController;
        
        self.editProfileTableViewController.scrollNeeded = YES;
        
        self.editProfileTableViewController.hideEmailField = YES;
        
        [self.editProfileTableViewController viewWillAppear:YES];
    } else if ([segue.identifier isEqualToString:kChooseSignUpTypeSegueIdentifier]) {
        BZRChooseSignUpTypeController *controller = (BZRChooseSignUpTypeController *)segue.destinationViewController;
        controller.temporaryProfile = self.temporaryProfile;
    }
}

@end
