//
//  BZRPageContentController.m
//  BizrateRewards
//
//  Created by Eugenity on 23.06.15.
//  Copyright (c) 2015 Connexity. All rights reserved.
//

#import "BZRStartTutorialController.h"

static NSString *const kSecondTutorialSegueIdentifier = @"secondTutorialSegue";

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

/**
 *  Add swipe gesture to controller's view
 */
- (void)addSwipeGesture
{
    UISwipeGestureRecognizer *swipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeGesture:)];
    [swipe setDirection:UISwipeGestureRecognizerDirectionLeft];
    [self.view addGestureRecognizer:swipe];
}

/**
 *  Handle swipe gecture
 *
 *  @param swipe Swipe Gesture
 */
- (void)handleSwipeGesture:(UISwipeGestureRecognizer *)swipe
{
    [self performSegueWithIdentifier:kSecondTutorialSegueIdentifier sender:self];
}

/**
 *  Set default status bar style because the background is white
 *
 *  @return UIStatusBarStyleDefault
 */
- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleDefault;
}

@end
