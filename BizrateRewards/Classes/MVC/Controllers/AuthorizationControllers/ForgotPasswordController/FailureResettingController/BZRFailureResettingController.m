//
//  BZRFailureResettingController.m
//  BizrateRewards
//
//  Created by Eugenity on 31.07.15.
//  Copyright (c) 2015 Connexity. All rights reserved.
//

#import "BZRFailureResettingController.h"

@interface BZRFailureResettingController ()

@property (strong, nonatomic) NSUserDefaults *defaults;

@end

@implementation BZRFailureResettingController

#pragma mark - Accessors

- (NSUserDefaults *)defaults
{
    if (!_defaults) {
        _defaults = [NSUserDefaults standardUserDefaults];
    }
    return _defaults;
}

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

- (IBAction)requestNewLinkClick:(id)sender
{
    [self addNewResettingPasswordRequirementToDefaults];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

/**
 *  If user clicks the 'requestNewLink' button he has to be redirected to forgot password screen. This value setted to determine this situation when autologin controller will perform redirection.
 */
- (void)addNewResettingPasswordRequirementToDefaults
{
    [self.defaults setBool:YES forKey:IsNewResettingLinkRequested];
    [self.defaults synchronize];
}

@end
