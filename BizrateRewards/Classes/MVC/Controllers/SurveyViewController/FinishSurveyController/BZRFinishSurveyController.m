//
//  BZRFinishSurveyController.m
//  BizrateRewards
//
//  Created by Eugenity on 07.07.15.
//  Copyright (c) 2015 Connexity. All rights reserved.
//

#import "BZRFinishSurveyController.h"
#import "BZRDashboardController.h"

@interface BZRFinishSurveyController ()

@end

@implementation BZRFinishSurveyController

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

- (IBAction)homeClick:(id)sender
{
    BZRDashboardController *controller = [self.storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([BZRDashboardController class])];
    [self.navigationController popToViewController:controller animated:YES];
}

@end
