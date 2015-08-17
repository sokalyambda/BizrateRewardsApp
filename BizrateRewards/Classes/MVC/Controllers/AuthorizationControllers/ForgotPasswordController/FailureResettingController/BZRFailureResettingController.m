//
//  BZRFailureResettingController.m
//  BizrateRewards
//
//  Created by Eugenity on 31.07.15.
//  Copyright (c) 2015 Connexity. All rights reserved.
//

#import "BZRFailureResettingController.h"

#import "BZRTutorialDescriptionLabel.h"

@interface BZRFailureResettingController ()

@property (weak, nonatomic) IBOutlet BZRTutorialDescriptionLabel *failReasonLabel;

@end

@implementation BZRFailureResettingController

#pragma mark - View Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [self updateFailReasonMessage];
}

#pragma mark - Actions

- (IBAction)requestNewLinkClick:(id)sender
{
    [self addNewResettingPasswordRequirement];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (IBAction)closeClick:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

/**
 *  Updating text in failResonLabel
 */
- (void)updateFailReasonMessage
{
    self.failReasonLabel.text = self.failReason;
}

/**
 *  If user clicks the 'requestNewLink' button he has to be redirected to forgot password screen. This value setted to determine this situation when autologin controller will perform redirection.
 */
- (void)addNewResettingPasswordRequirement
{
    [BZRStorageManager sharedStorage].resettingPasswordRepeatNeeded = YES;
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
