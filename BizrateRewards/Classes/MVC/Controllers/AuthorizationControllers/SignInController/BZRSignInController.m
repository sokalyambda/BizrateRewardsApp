//
//  BZRSignInController.m
//  BizrateRewards
//
//  Created by Eugenity on 23.06.15.
//  Copyright (c) 2015 ThinkMobiles. All rights reserved.
//

#import "BZRSignInController.h"

@interface BZRSignInController ()

@property (weak, nonatomic) IBOutlet UITextField *userNameField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;

@end

@implementation BZRSignInController

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

#pragma mark - Actions

//facebook
- (IBAction)facebookLoginClick:(id)sender
{
}

//email
- (IBAction)signInClick:(id)sender
{
}

- (IBAction)rememberMeClick:(id)sender
{
}

@end
