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

- (void)viewDidLoad {
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
    [self performSegueWithIdentifier:kGeolocationAccessSegueIdentifier sender:self];
}

@end
