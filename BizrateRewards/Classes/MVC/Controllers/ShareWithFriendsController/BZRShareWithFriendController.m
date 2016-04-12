//
//  BZRShareWithFriendController.m
//  Bizrate Rewards
//
//  Created by Myroslava Polovka on 11/25/15.
//  Copyright © 2015 Connexity. All rights reserved.
//

#import "BZRShareWithFriendController.h"
#import "BZRFacebookService.h"
#import "BZRSharingManager.h"
#import "BZRAlertFacade.h"

@interface BZRShareWithFriendController () <BZRSharingManagerDelegate>

@property (weak, nonatomic) IBOutlet UILabel *shareCodeLabel;

@end

@implementation BZRShareWithFriendController

#pragma mark - View Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.shareCodeLabel.text = self.shareCode;
}

#pragma mark - Actions

- (IBAction)shareWithFacebook:(id)sender
{
    [[BZRSharingManager sharedManager] shareWithFacebookFromController:self inviteCode:self.shareCode];
}

- (IBAction)shareWithTwitter:(id)sender
{
    [[BZRSharingManager sharedManager] shareWithTwitterFromController:self inviteCode:self.shareCode];
}

- (IBAction)shareWithMessage:(id)sender
{
    [[BZRSharingManager sharedManager] shareWithMessageFromController:self inviteCode:self.shareCode];
}

- (IBAction)shareWithEmail:(id)sender
{
    [[BZRSharingManager sharedManager] shareWithEmailFromController:self inviteCode:self.shareCode];
}

/**
 *  Customize navigation bar appearance
 */
- (void)customizeNavigationItem
{
    [super customizeNavigationItem];
    //set navigation title
    self.navigationItem.title = LOCALIZED(@"Share Code");
    
    //Show navigation bar
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

#pragma mark - BZRSharingManagerDelegate

- (void)sharingWasCanceledForType:(BZRSharingType)sharingType
{
    [BZRAlertFacade showAlertWithMessage:@"Invite code was successfully shared." forController:self withCompletion:NULL];
}

@end
