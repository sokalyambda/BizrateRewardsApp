//
//  BZRBaseAuthController.h
//  BizrateRewards
//
//  Created by Eugenity on 23.06.15.
//  Copyright (c) 2015 Connexity. All rights reserved.
//

#import "BZRValidator.h"

#import "BZRAuthorizationField.h"

static NSString *const kEmailErrorIconName = @"email_icon_error";

@interface BZRBaseAuthController : UIViewController<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet BZRAuthorizationField *userNameField;
@property (weak, nonatomic) IBOutlet BZRAuthorizationField *passwordField;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (strong, nonatomic) UITextField *activeField;
@property (strong, nonatomic) BZRValidator *validator;

- (void)customizeFields;

@end
