//
//  BZRSignInController.m
//  BizrateRewards
//
//  Created by Eugenity on 23.06.15.
//  Copyright (c) 2015 ThinkMobiles. All rights reserved.
//

#import "BZRSignInController.h"
#import "BZRGetStartedController.h"

#import "BZRDataManager.h"

static NSString *const kDashboardSegueIdentifier = @"dashboardSegue";

//const for auth error code
//static NSInteger const kNotAuthorizedErrorCode = 401.f;

@interface BZRSignInController ()

@property (weak, nonatomic) IBOutlet UIView *incorrectEmailView;

@property (strong, nonatomic) BZRDataManager *dataManager;

@end

@implementation BZRSignInController

#pragma mark - Accessors

- (BZRDataManager *)dataManager
{
    if (!_dataManager) {
        _dataManager = [BZRDataManager sharedInstance];
    }
    return _dataManager;
}

#pragma mark - View Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
}

#pragma mark - Actions

//facebook
- (IBAction)facebookLoginClick:(id)sender
{
    
}

//email
- (IBAction)signInClick:(id)sender
{
    [self.incorrectEmailView setHidden:YES];
    WEAK_SELF;
    if ([self.validator validateEmailField:self.userNameField andPasswordField:self.passwordField]) {
        [BZRReachabilityHelper checkConnectionOnSuccess:^{
            [MBProgressHUD showHUDAddedTo:weakSelf.view animated:YES];
            [weakSelf.dataManager signInWithUserName:weakSelf.userNameField.text password:weakSelf.passwordField.text withResult:^(BOOL success, NSError *error) {
                [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:YES];
                if (!success) {
//                    ShowErrorAlert(error);
#warning need to detect if an error indeed relative to auth
//                    if (error.code == 400) {
                    [weakSelf.incorrectEmailView setHidden:NO];
                    weakSelf.userNameField.errorImageName = kEmailErrorIconName;
//                    }
                } else {
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

- (IBAction)rememberMeClick:(id)sender
{

}

- (IBAction)forgotPasswordClick:(id)sender
{
    
}

- (IBAction)goToCreateNewAccountClick:(id)sender
{
//    BZRGetStartedController *controller = [self.storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([BZRGetStartedController class])];
//    [self.navigationController pushViewController:controller animated:YES];
}

- (void)customizeFields
{
    [super customizeFields];
    if (!self.incorrectEmailView.isHidden) {
        self.incorrectEmailView.hidden = YES;
    }
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
