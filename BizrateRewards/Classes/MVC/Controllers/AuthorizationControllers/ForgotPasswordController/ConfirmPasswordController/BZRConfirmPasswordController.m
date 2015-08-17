//
//  BZRConfirmPasswordController.m
//  BizrateRewards
//
//  Created by Eugenity on 04.08.15.
//  Copyright (c) 2015 Connexity. All rights reserved.
//

#import "BZRConfirmPasswordController.h"

@interface BZRConfirmPasswordController ()

@end

@implementation BZRConfirmPasswordController

#pragma mark - View Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

#pragma mark - Actions

- (IBAction)closeClick:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

/**
 *  Set default status bar style because the background is white
 *
 *  @return UIStatusBarStyleDefault
 */
- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleDefault;
}

@end
