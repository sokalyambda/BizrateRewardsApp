//
//  BZRAccountSettingsController.m
//  BizrateRewards
//
//  Created by Eugenity on 27.06.15.
//  Copyright (c) 2015 ThinkMobiles. All rights reserved.
//

#import "BZRAccountSettingsController.h"
#import "BZRSignInController.h"
#import "BZRDashboardController.h"

@interface BZRAccountSettingsController ()

@end

@implementation BZRAccountSettingsController

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

- (IBAction)exitClick:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)signOutAction:(id)sender
{
    BZRDashboardController *dashboard = (BZRDashboardController *)[self.navigationController.presentingViewController.childViewControllers lastObject];
    [self dismissViewControllerAnimated:YES completion:nil];
    [dashboard.navigationController popViewControllerAnimated:NO];
}

@end
