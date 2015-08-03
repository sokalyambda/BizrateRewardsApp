//
//  BZRFailureResettingController.m
//  BizrateRewards
//
//  Created by Eugenity on 31.07.15.
//  Copyright (c) 2015 Connexity. All rights reserved.
//

#import "BZRFailureResettingController.h"

@interface BZRFailureResettingController ()

@end

@implementation BZRFailureResettingController

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
    
}

@end
