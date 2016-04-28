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

static CGFloat const kHudAnimationDelay = 1.f;

@interface BZRShareWithFriendController () <BZRSharingManagerDelegate>

@property (weak, nonatomic) IBOutlet UILabel *shareCodeLabel;

@end

@implementation BZRShareWithFriendController

#pragma mark - View Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.shareCodeLabel.text = [NSString stringWithFormat:@"USER CODE: %@", self.shareCode];
}

#pragma mark - Actions

- (IBAction)copyShareCode:(id)sender
{
    UIPasteboard *pb = [UIPasteboard generalPasteboard];
    [pb setString:ShareBody(self.shareCode)];
    [self showHudView];
}

- (IBAction)shareWithFacebook:(id)sender
{
    [BZRMixpanelService trackEventWithType:BZRMixpanelEventShareWithFacebookClicked propertyValue:nil];
    [[BZRSharingManager sharedManager] shareWithFacebookFromController:self inviteCode:self.shareCode];
}

- (IBAction)shareWithTwitter:(id)sender
{
    [BZRMixpanelService trackEventWithType:BZRMixpanelEventShareWithTwitterClicked propertyValue:nil];
    [[BZRSharingManager sharedManager] shareWithTwitterFromController:self inviteCode:self.shareCode];
}

- (IBAction)shareWithMessage:(id)sender
{
    [BZRMixpanelService trackEventWithType:BZRMixpanelEventShareWithMessageClicked propertyValue:nil];
    [[BZRSharingManager sharedManager] shareWithMessageFromController:self inviteCode:self.shareCode];
}

- (IBAction)shareWithEmail:(id)sender
{
    [BZRMixpanelService trackEventWithType:BZRMixpanelEventShareWithEmailClicked propertyValue:nil];
    [[BZRSharingManager sharedManager] shareWithEmailFromController:self inviteCode:self.shareCode];
}

#pragma mark - Private

- (void)showHudView
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeCustomView;
    UIImage *image = [[UIImage imageNamed:@"checkmark"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    hud.customView = [[UIImageView alloc] initWithImage:image];
    hud.square = YES;
    hud.labelText = @"Copied";
    [hud hide:YES afterDelay:kHudAnimationDelay];
}

/**
 *  Customize navigation bar appearance
 */
- (void)customizeNavigationItem
{
    [super customizeNavigationItem];
    //set navigation title
    self.navigationItem.title = LOCALIZED(@"Extra Gift Cards");
    
    //Show navigation bar
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

#pragma mark - BZRSharingManagerDelegate

- (void)sharingWasCanceledForType:(BZRSharingType)sharingType
{
    [BZRAlertFacade showAlertWithMessage:@"Invite code was successfully shared." forController:self withCompletion:NULL];
}

@end
