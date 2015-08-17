//
//  BZRSecondTutorialController.m
//  BizrateRewards
//
//  Created by Eugenity on 07.07.15.
//  Copyright (c) 2015 Connexity. All rights reserved.
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

/**
 *  Adding the swipe gesture to controller's view
 */
- (void)addSwipeGesture
{
    UISwipeGestureRecognizer *leftSwipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleLeftSwipeGesture:)];
    [leftSwipe setDirection:UISwipeGestureRecognizerDirectionLeft];
    
    UISwipeGestureRecognizer *rightSwipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleRightSwipeGesture:)];
    [rightSwipe setDirection:UISwipeGestureRecognizerDirectionRight];
    
    [self.view addGestureRecognizer:leftSwipe];
    [self.view addGestureRecognizer:rightSwipe];
}

/**
 *  Handle the left swipe
 *
 *  @param swipe Left swipe gesture
 */
- (void)handleLeftSwipeGesture:(UISwipeGestureRecognizer *)swipe
{
    [self performSegueWithIdentifier:kGeolocationAccessSegueIdentifier sender:self];
}

/**
 *  Handle the right swipe
 *
 *  @param swipe Right swipe gesture
 */
- (void)handleRightSwipeGesture:(UISwipeGestureRecognizer *)swipe
{
    [self.navigationController popViewControllerAnimated:YES];
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
