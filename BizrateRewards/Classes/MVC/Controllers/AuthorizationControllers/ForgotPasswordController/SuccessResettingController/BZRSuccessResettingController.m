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
    WEAK_SELF;
    [BZRProjectFacade signOutOnSuccess:^(BOOL isSuccess) {
        [[BZRStorageManager sharedStorage] swapTokens];
        BZRDashboardController *controller = [weakSelf.storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([BZRDashboardController class])];
        controller.updateNeeded = YES;
        [weakSelf.navigationController pushViewController:controller animated:YES];
    } onFailure:^(NSError *error, BOOL isCanceled) {
        
    }];
}

- (IBAction)closeClick:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
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
