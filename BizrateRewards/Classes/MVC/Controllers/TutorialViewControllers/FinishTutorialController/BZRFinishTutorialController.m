//
//  BZRFinishTutorialController.m
//  BizrateRewards
//
//  Created by Eugenity on 27.06.15.
//  Copyright (c) 2015 Connexity. All rights reserved.
//

#import "BZRFinishTutorialController.h"

static NSString *const kSignInSegueIdentifier = @"signInSegueIdentifier";
static NSString *const kGetStartedSegueIdentifier = @"getStartedSegueIdentifier";

@interface BZRFinishTutorialController ()

@end

@implementation BZRFinishTutorialController

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

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self setTutorialPassed];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

#pragma mark - Actions

- (IBAction)signInClick:(id)sender
{
    [self performSegueWithIdentifier:kSignInSegueIdentifier sender:self];
}

- (IBAction)getStartedClick:(id)sender
{
    [self performSegueWithIdentifier:kGetStartedSegueIdentifier sender:self];
}

/**
 *  If user has seen this screen - set 'tutorial passed' value to 'true' and save it to user defaults
 */
- (void)setTutorialPassed
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    BOOL isTutorialPassed = [defaults boolForKey:IsTutorialPassed];
    
    if (isTutorialPassed) {
        return;
    } else {
        [defaults setBool:YES forKey:IsTutorialPassed];
        [defaults synchronize];
    }
}

@end
