//
//  BZRSecondTutorialController.m
//  BizrateRewards
//
//  Created by Eugenity on 07.07.15.
//  Copyright (c) 2015 ThinkMobiles. All rights reserved.
//

#import "BZRSecondTutorialController.h"

static NSString *const kGeolocationAccessSegueIdentifier = @"geolocationAccessSegueIdentifier";

@interface BZRSecondTutorialController ()

@end

@implementation BZRSecondTutorialController

#pragma mark - View Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self addSwipeGesture];
}

#pragma mark - Actions

- (void)addSwipeGesture
{
    UISwipeGestureRecognizer *leftSwipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleLeftSwipeGesture:)];
    [leftSwipe setDirection:UISwipeGestureRecognizerDirectionLeft];
    
    UISwipeGestureRecognizer *rightSwipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleRightSwipeGesture:)];
    [rightSwipe setDirection:UISwipeGestureRecognizerDirectionRight];
    
    [self.view addGestureRecognizer:leftSwipe];
    [self.view addGestureRecognizer:rightSwipe];
}

- (void)handleLeftSwipeGesture:(UISwipeGestureRecognizer *)swipe
{
    [self performSegueWithIdentifier:kGeolocationAccessSegueIdentifier sender:self];
}

- (void)handleRightSwipeGesture:(UISwipeGestureRecognizer *)swipe
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
