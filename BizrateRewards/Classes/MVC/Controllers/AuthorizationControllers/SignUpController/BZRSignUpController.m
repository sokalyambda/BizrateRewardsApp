//
//  BZRSignUpController.m
//  BizrateRewards
//
//  Created by Eugenity on 23.06.15.
//  Copyright (c) 2015 ThinkMobiles. All rights reserved.
//

#import "BZRSignUpController.h"

#import "BZRDataManager.h"

#import "BZRLeftImageTextField.h"

@interface BZRSignUpController ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet BZRLeftImageTextField *userNameField;
@property (weak, nonatomic) IBOutlet BZRLeftImageTextField *passwordField;

@property (strong, nonatomic) BZRDataManager *dataManager;

@end

@implementation BZRSignUpController

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

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self customizeFields];
}

#pragma mark - Actions

- (IBAction)createAccountClick:(id)sender
{
    WEAK_SELF;
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self.dataManager getClientCredentialsOnSuccess:^(BOOL success, NSError *error) {
        if (success) {
            [weakSelf.dataManager signUpWithUserFirstName:@"firstNameTest" andUserLastName:@"lastNameTest" andEmail:@"qweqweqwe@gmail.com" withResult:^(BOOL success, NSError *error) {
                [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:YES];
                if (!success) {
                    ShowErrorAlert(error);
                }
                NSData *errorData = error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey];
                NSString *errorString = [[NSString alloc] initWithData:errorData encoding:NSUTF8StringEncoding];
                NSLog(@"error %@", errorString);
            }];
        }
    }];
}

- (void)customizeFields
{
    self.userNameField.imageName = @"email_icon";
    self.passwordField.imageName = @"password_icon";
    [self.passwordField addBottomBorder];
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
