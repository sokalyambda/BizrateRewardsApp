//
//  BZRPageContentController.m
//  BizrateRewards
//
//  Created by Eugenity on 23.06.15.
//  Copyright (c) 2015 ThinkMobiles. All rights reserved.
//

#import "BZRStartTutorialController.h"

@interface BZRStartTutorialController ()

@end

@implementation BZRStartTutorialController

#pragma mark - View Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self addSwipeGesture];
}

#pragma mark - Actions

- (void)addSwipeGesture
{
    UISwipeGestureRecognizer *swipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeGesture:)];
    [swipe setDirection:UISwipeGestureRecognizerDirectionLeft];
    [self.view addGestureRecognizer:swipe];
}

- (void)handleSwipeGesture:(UISwipeGestureRecognizer *)swipe
{
    [self performSegueWithIdentifier:@"geolocationAccessSegueIdentifier" sender:self];
}

@end
