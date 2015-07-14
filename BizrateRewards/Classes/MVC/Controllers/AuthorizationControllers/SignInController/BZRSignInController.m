//
//  BZRSignInController.m
//  BizrateRewards
//
//  Created by Eugenity on 23.06.15.
//  Copyright (c) 2015 Connexity. All rights reserved.
//

#import "BZRSignInController.h"
#import "BZRGetStartedController.h"
#import "KeychainItemWrapper.h"

#import "BZRDataManager.h"

static NSString *const kDashboardSegueIdentifier = @"dashboardSegue";

static NSString *const kIsRememberMe = @"isRememberMe";
static NSString *const kUserCredentials = @"UserCredentials";

//const for auth error code
static NSInteger const kNotAuthorizedErrorCode = 400.f;

@interface BZRSignInController ()

@property (weak, nonatomic) IBOutlet UIView *incorrectEmailView;

@property (weak, nonatomic) IBOutlet UISwitch *rememberMeSwitch;

@property (strong, nonatomic) BZRDataManager *dataManager;

@property (assign, nonatomic, getter=isRememberMe) BOOL rememberMe;

@property (strong, nonatomic) NSUserDefaults *defaults;

@end

@implementation BZRSignInController

@synthesize rememberMe = _rememberMe;

#pragma mark - Accessors

- (BZRDataManager *)dataManager
{
    if (!_dataManager) {
        _dataManager = [BZRDataManager sharedInstance];
    }
    return _dataManager;
}

- (BOOL)isRememberMe
{
    return [self.defaults boolForKey:kIsRememberMe];
}

- (void)setRememberMe:(BOOL)rememberMe
{
    _rememberMe = rememberMe;
    [self.defaults setBool:_rememberMe forKey:kIsRememberMe];
    [self.defaults synchronize];
}

- (NSUserDefaults *)defaults
{
    if (!_defaults) {
        _defaults = [NSUserDefaults standardUserDefaults];
    }
    return _defaults;
}

#pragma mark - View Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
//    [self getUserDataFromKeychain];
    [self.rememberMeSwitch setOn:self.isRememberMe];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

#pragma mark - Actions

//facebook
- (IBAction)facebookLoginClick:(id)sender
{
//    WEAK_SELF;
//    [BZRReachabilityHelper checkConnectionOnSuccess:^{
//        [MBProgressHUD showHUDAddedTo:weakSelf.view animated:YES];
//        [weakSelf.dataManager authorizeWithFacebookWithResult:^(BOOL success, NSError *error, NSInteger responseStatusCode) {
//            [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:YES];
//            if (success) {
//                [weakSelf performSegueWithIdentifier:kDashboardSegueIdentifier sender:weakSelf];
//            }
//        }];
//    } failure:^{
//        ShowAlert(InternetIsNotReachableString);
//    }];
}

//email
- (IBAction)signInClick:(id)sender
{
   [self performSegueWithIdentifier:kDashboardSegueIdentifier sender:self];
    [self.incorrectEmailView setHidden:YES];
    WEAK_SELF;
    if ([self.validator validateEmailField:self.userNameField andPasswordField:self.passwordField]) {
        [BZRReachabilityHelper checkConnectionOnSuccess:^{
            [MBProgressHUD showHUDAddedTo:weakSelf.view animated:YES];
            [weakSelf.dataManager signInWithUserName:weakSelf.userNameField.text password:weakSelf.passwordField.text withResult:^(BOOL success, NSError *error, NSInteger responseStatusCode) {
                [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:YES];
                if (!success) {
                    if (responseStatusCode == kNotAuthorizedErrorCode) {
                        [weakSelf.incorrectEmailView setHidden:NO];
                        weakSelf.userNameField.errorImageName = kEmailErrorIconName;
                    } else {
                        ShowErrorAlert(error);
                    }
                } else {
                    if (weakSelf.isRememberMe) {
                        [weakSelf saveUserDataToKeychain];
                    }
                    [weakSelf performSegueWithIdentifier:kDashboardSegueIdentifier sender:weakSelf];
                }
            }];
        } failure:^{
            ShowAlert(InternetIsNotReachableString);
        }];
        
    } else {
//        ShowAlert(self.validator.validationErrorString);
        [self.validator cleanValidationErrorString];
    }
}

- (IBAction)forgotPasswordClick:(id)sender
{
    
}

- (IBAction)goToCreateNewAccountClick:(id)sender
{
//    BZRGetStartedController *controller = [self.storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([BZRGetStartedController class])];
//    [self.navigationController pushViewController:controller animated:YES];
}

- (IBAction)rememberMeValueChanged:(id)sender
{
    self.rememberMe = !self.isRememberMe;
}

- (void)customizeFields
{
    [super customizeFields];
    if (!self.incorrectEmailView.isHidden) {
        self.incorrectEmailView.hidden = YES;
    }
}

#pragma mark - Private methods

- (void)saveUserDataToKeychain
{
    KeychainItemWrapper *wrapper = [[KeychainItemWrapper alloc] initWithIdentifier:kUserCredentials accessGroup:nil];
    [wrapper setObject:self.passwordField.text forKey:(__bridge id)(kSecValueData)];
    [wrapper setObject:self.userNameField.text forKey:(__bridge id)(kSecAttrAccount)];
}

- (void)getUserDataFromKeychain
{
    KeychainItemWrapper *wrapper = [[KeychainItemWrapper alloc] initWithIdentifier:kUserCredentials accessGroup:nil];
    self.passwordField.text = [wrapper objectForKey:(__bridge id)(kSecValueData)];
    self.userNameField.text = [wrapper objectForKey:(__bridge id)(kSecAttrAccount)];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if ([self.userNameField isFirstResponder]) {
        [self.passwordField becomeFirstResponder];
    } else if ([self.passwordField isFirstResponder]) {
        [self.passwordField resignFirstResponder];
    }
    return YES;
}

@end
