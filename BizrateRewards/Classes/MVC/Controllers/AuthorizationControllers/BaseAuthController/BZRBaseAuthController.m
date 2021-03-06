//
//  BZRBaseAuthController.m
//  BizrateRewards
//
//  Created by Eugenity on 23.06.15.
//  Copyright (c) 2015 Connexity. All rights reserved.
//

#import "BZRBaseAuthController.h"

static NSString *const kEmailActiveIconName         = @"email_icon_prepop";
static NSString *const kEmailNotActiveIconName      = @"email_icon";
static NSString *const kPasswordActiveIconName      = @"password_icon_prepop";
static NSString *const kPasswordNotActiveIconName   = @"password_icon";

@interface BZRBaseAuthController ()

@end

@implementation BZRBaseAuthController

#pragma mark - View Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self registerForKeyboardNotifications];
    [self.view layoutIfNeeded];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self customizeFields];
    });
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Keyboard methods

/**
 *  Handle keyboard showing
 *
 *  @param notification KeyboardWillShowNotification
 */
- (void)keyboardWillShow:(NSNotification*) notification
{
    NSDictionary* info = [notification userInfo];
    CGRect keyBoardFrame = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    keyBoardFrame = [self.view convertRect:keyBoardFrame fromView:nil];
    
    CGSize kbSize = keyBoardFrame.size;
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbSize.height, 0.0);
    self.scrollView.contentInset = contentInsets;
    self.scrollView.scrollIndicatorInsets = contentInsets;
    
    CGRect aRect = self.view.frame;
    aRect.size.height -= kbSize.height;
    
    if (!CGRectContainsPoint(aRect, self.activeField.frame.origin) ) {
        [self.scrollView scrollRectToVisible:self.activeField.frame animated:YES];
    }
}

/**
 *  Handle keyboard hiding
 *
 *  @param notification KeyboardWillHideNotification
 */
- (void)keyboardWillHide:(NSNotification*) notification
{
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    self.scrollView.contentInset = contentInsets;
    self.scrollView.scrollIndicatorInsets = contentInsets;
    
    [self.scrollView setContentOffset:CGPointZero animated:YES];
}

#pragma mark - Actions

/**
 *  Registering for keyboard notifications
 */
- (void)registerForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

/**
 *  Base fields customization
 */
- (void)customizeFields
{
    self.userNameField.activeImageName      = kEmailActiveIconName;
    self.userNameField.notActiveImageName   = kEmailNotActiveIconName;
    
    self.passwordField.activeImageName      = kPasswordActiveIconName;
    self.passwordField.notActiveImageName   = kPasswordNotActiveIconName;
}

/**
 *  Resign first responder from any active field from auth outlet collection
 */
- (void)resignIfFirstResponder
{
    for (UITextField *field in self.authFields) {
        [field resignFirstResponder];
    }
}

#pragma mark - UITextFieldDelegate

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    self.activeField = textField;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    self.activeField = nil;
}

@end
