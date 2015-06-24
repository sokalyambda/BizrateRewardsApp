//
//  BZRDashboardController.m
//  BizrateRewards
//
//  Created by Eugenity on 23.06.15.
//  Copyright (c) 2015 ThinkMobiles. All rights reserved.
//

#import "BZRLocationObserver.h"

#import "BZRDashboardController.h"

@interface BZRDashboardController ()

@end

@implementation BZRDashboardController

#pragma mark - View Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    [BZRLocationObserver sharedObserver];
}

#pragma mark - Actions

@end
