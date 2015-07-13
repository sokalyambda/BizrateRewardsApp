//
//  BZRBaseNavigationController.m
//  BizrateRewards
//
//  Created by Eugenity on 10.07.15.
//  Copyright (c) 2015 ThinkMobiles. All rights reserved.
//

#import "BZRBaseNavigationController.h"

@interface BZRBaseNavigationController ()

@end

@implementation BZRBaseNavigationController

#pragma mark - View Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self customizeNavigationBar];
}

#pragma mark - Actions

- (void)customizeNavigationBar
{
    [self.navigationBar setBarTintColor:UIColorFromRGB(0x12a9d6)];
    [self.navigationBar setTintColor:[UIColor whiteColor]];
    [self.navigationBar setTitleTextAttributes:@{NSFontAttributeName : [UIFont fontWithName:@"OpenSans" size:20.f], NSForegroundColorAttributeName : [UIColor whiteColor]}];
    self.navigationBar.translucent = NO;
}

@end
