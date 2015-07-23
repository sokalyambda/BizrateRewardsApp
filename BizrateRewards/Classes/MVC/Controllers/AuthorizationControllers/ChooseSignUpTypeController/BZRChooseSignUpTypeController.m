//
//  BZRChooseSignUpTypeController.m
//  BizrateRewards
//
//  Created by Eugenity on 23.06.15.
//  Copyright (c) 2015 Connexity. All rights reserved.
//

#import "BZRChooseSignUpTypeController.h"
#import "BZRSignUpController.h"

static NSString *const kSignUpWithEmailSegueIdentifier = @"signUpWithEmailSegue";

@interface BZRChooseSignUpTypeController ()

@end

@implementation BZRChooseSignUpTypeController

#pragma mark - View Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    [BZRMixpanelService trackEventWithType:BZRMixpanelEventCreateAccountPage properties:nil];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

#pragma mark - Actions

- (IBAction)signUpWithFacebookClick:(id)sender
{
    [BZRMixpanelService trackEventWithType:BZRMixpanelEventCreateAcountClicked properties:@{Type : Facebook}];
}

- (IBAction)signUpWithEmailClick:(id)sender
{
    [BZRMixpanelService trackEventWithType:BZRMixpanelEventCreateAcountClicked properties: @{Type : Email}];
    [self performSegueWithIdentifier:kSignUpWithEmailSegueIdentifier sender:self];

}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:kSignUpWithEmailSegueIdentifier]) {
        BZRSignUpController *controller = (BZRSignUpController *)segue.destinationViewController;
        controller.temporaryProfile = self.temporaryProfile;
    }
}

@end
