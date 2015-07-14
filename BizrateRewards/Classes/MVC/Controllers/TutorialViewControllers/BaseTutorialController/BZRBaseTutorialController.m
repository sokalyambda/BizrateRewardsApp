//
//  BZRTutorialViewController.m
//  BizrateRewards
//
//  Created by Eugenity on 23.06.15.
//  Copyright (c) 2015 Connexity. All rights reserved.
//

#import "BZRBaseTutorialController.h"
#import "BZRStartTutorialController.h"

#import "BZRDataManager.h"

static NSString *const kStartTutorialSegueIdentirier = @"startTutorialSegue";

@interface BZRBaseTutorialController ()

@end

@implementation BZRBaseTutorialController

#pragma mark - View Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    [BZRDataManager sharedInstance];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self performSegueWithIdentifier:kStartTutorialSegueIdentirier sender:self];
}

#pragma mark - Actions

@end
