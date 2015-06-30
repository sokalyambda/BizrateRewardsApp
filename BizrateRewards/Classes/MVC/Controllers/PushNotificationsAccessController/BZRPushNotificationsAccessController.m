//
//  BZRPushNotificationsAccessController.m
//  BizrateRewards
//
//  Created by Eugenity on 27.06.15.
//  Copyright (c) 2015 ThinkMobiles. All rights reserved.
//

#import "BZRPushNotificationsAccessController.h"

static NSString *const kFinalTutorialControllerSegueIdentifier = @"finalTutorialControllerSegue";

@interface BZRPushNotificationsAccessController ()

@end

@implementation BZRPushNotificationsAccessController

#pragma mark - View Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
}

#pragma mark - Actions

- (IBAction)enablePushNotificationsClick:(id)sender
{
    
}

- (IBAction)skipThisStepClick:(id)sender
{
    [self performSegueWithIdentifier:kFinalTutorialControllerSegueIdentifier sender:self];
}

@end
