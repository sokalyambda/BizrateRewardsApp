//
//  BZRFinishTutorialController.m
//  BizrateRewards
//
//  Created by Eugenity on 27.06.15.
//  Copyright (c) 2015 ThinkMobiles. All rights reserved.
//

#import "BZRFinishTutorialController.h"

static NSString *const kSignInSegueIdentifier = @"signInSegueIdentifier";

@interface BZRFinishTutorialController ()

@end

@implementation BZRFinishTutorialController

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

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

#pragma mark - Actions

- (IBAction)signInClick:(id)sender
{
    [self performSegueWithIdentifier:kSignInSegueIdentifier sender:self];
}

- (IBAction)getStartedClick:(id)sender
{
}

@end
