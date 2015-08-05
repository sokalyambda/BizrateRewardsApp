//
//  BZRSuccessResettingController.m
//  BizrateRewards
//
//  Created by Eugenity on 31.07.15.
//  Copyright (c) 2015 Connexity. All rights reserved.
//

#import "BZRSuccessResettingController.h"

#import "BZRDashboardController.h"

#import "BZRProjectFacade.h"

@interface BZRSuccessResettingController ()

@end

@implementation BZRSuccessResettingController

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

- (IBAction)continueClick:(id)sender
{
    [self resetUserData];
    
    BZRDashboardController *controller = [self.storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([BZRDashboardController class])];
    controller.updateNeeded = YES;
    [self.navigationController pushViewController:controller animated:YES];
}

- (IBAction)closeClick:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

/**
 *  Clear user data if it exists
 */
- (void)resetUserData
{
    [BZRProjectFacade signOutOnSuccess:nil onFailure:nil];
}

@end
