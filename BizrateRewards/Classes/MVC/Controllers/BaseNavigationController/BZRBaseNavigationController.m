//
//  BZRBaseNavigationController.m
//  BizrateRewards
//
//  Created by Eugenity on 10.07.15.
//  Copyright (c) 2015 Connexity. All rights reserved.
//

#import "BZRBaseNavigationController.h"

#import "BZRSerialViewConstructor.h"

#import "BZRProjectFacade.h"

@interface BZRBaseNavigationController ()

@end

@implementation BZRBaseNavigationController

#pragma mark - Accessors

- (UIBarButtonItem *)customBackButton
{
    if (!_customBackButton) {
        _customBackButton = [BZRSerialViewConstructor backButtonForController:self withAction:@selector(backClick:)];
    }
    return _customBackButton;
}

#pragma mark - View Lifecycle

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self customizeNavigationBar];
}

#pragma mark - Actions

/**
 *  Customize navigation bar
 */
- (void)customizeNavigationBar
{
    [self.navigationBar setBarTintColor:UIColorFromRGB(0x12a9d6)];
    [self.navigationBar setTintColor:[UIColor whiteColor]];
    [self.navigationBar setTitleTextAttributes:@{NSFontAttributeName : [UIFont fontWithName:@"OpenSans" size:20.f], NSForegroundColorAttributeName : [UIColor whiteColor]}];
    self.navigationBar.translucent = NO;
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return self.topViewController.preferredStatusBarStyle;
}

/**
 *  Custom back action
 *
 *  @param sender Back button
 */
- (void)backClick:(UIBarButtonItem *)sender
{
    if ([BZRProjectFacade isOperationInProcess]) {
        return;
    }
    [self popViewControllerAnimated:YES];
}

@end
