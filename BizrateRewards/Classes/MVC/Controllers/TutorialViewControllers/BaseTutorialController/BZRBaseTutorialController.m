//
//  BZRTutorialViewController.m
//  BizrateRewards
//
//  Created by Eugenity on 23.06.15.
//  Copyright (c) 2015 ThinkMobiles. All rights reserved.
//

#import "BZRBaseTutorialController.h"
#import "BZRStartTutorialController.h"

@interface BZRBaseTutorialController ()

@end

@implementation BZRBaseTutorialController

#pragma mark - View Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self performSegueWithIdentifier:@"startTutorialSegue" sender:self];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
//    [self.navigationController setNavigationBarHidden:NO];
}

#pragma mark - Actions

@end
