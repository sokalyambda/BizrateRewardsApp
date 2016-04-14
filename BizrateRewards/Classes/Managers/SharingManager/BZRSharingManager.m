//
//  BZRSharingManager.m
//  Bizrate Rewards
//
//  Created by Kate Chupova on 4/11/16.
//  Copyright © 2016 Connexity. All rights reserved.
//

#import "BZRSharingManager.h"
#import <Social/Social.h>
#import <FBSDKShareKit/FBSDKShareKit.h>

static NSString * const kMailSubject = @"Bizrate Rewards. Get up to 350 extra points!";

@interface BZRSharingManager () <MFMailComposeViewControllerDelegate, MFMessageComposeViewControllerDelegate>

@end

@implementation BZRSharingManager

#pragma mark - Lifecycle

+ (BZRSharingManager *)sharedManager
{
    static BZRSharingManager *manager = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[BZRSharingManager alloc] init];
    });
    
    return manager;
}

#pragma mark - public

/*
 * Share with Facebook using Facebook SDK
 */

- (void)shareWithFacebookFromController:(UIViewController*)fromController contentTitle:(NSString*)contentTitle contentDescription:(NSString*)contentDescription
{
    FBSDKShareLinkContent *content = [FBSDKShareLinkContent new];
    content.contentTitle = contentTitle;
    content.contentDescription = contentDescription;
    
    FBSDKShareDialog *dialog = [[FBSDKShareDialog alloc] init];
    dialog.fromViewController = fromController;
    dialog.shareContent = content;
    
    dialog.mode = FBSDKShareDialogModeFeedWeb;
    if (![dialog canShow]) {
        dialog.mode = FBSDKShareDialogModeFeedBrowser;
    }
    
    [dialog show];
}

/*
 * Share with Facebook using Social Framework
 */

- (void)shareWithFacebookFromController:(UIViewController*)fromController inviteCode:(NSString*)inviteCode
{
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook]) {
        SLComposeViewController  *fbSLComposeViewController = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
        [fbSLComposeViewController setInitialText:ShareBody(inviteCode)];
        [fromController presentViewController:fbSLComposeViewController animated:YES completion:nil];
        
        fbSLComposeViewController.completionHandler = ^(SLComposeViewControllerResult result) {
            switch(result) {
                case SLComposeViewControllerResultCancelled:
                    [self sharingWasCanceledForType:BZRSharingFacebook];
                    break;
                case SLComposeViewControllerResultDone:
                    [self sharingDoneForType:BZRSharingFacebook];
                    break;
            }
        };
    } else {
        [BZRAlertFacade showNoSocialAccountAlertForController:fromController socialType:BZRSocialFacebook andCompletion:^(UIAlertAction *action, BOOL isCanceled) {
        }];
    }
}

/*
 * Share with Twitter using Social Framework
 */

- (void)shareWithTwitterFromController:(UIViewController*)fromController inviteCode:(NSString*)inviteCode
{
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter]) {
        SLComposeViewController  *twSLComposeViewController = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
        [twSLComposeViewController setInitialText:ShareBody(inviteCode)];
        [fromController presentViewController:twSLComposeViewController animated:YES completion:nil];
        
        twSLComposeViewController.completionHandler = ^(SLComposeViewControllerResult result) {
            switch(result) {
                case SLComposeViewControllerResultCancelled:
                    [self sharingWasCanceledForType:BZRSharingFacebook];
                    break;
                case SLComposeViewControllerResultDone:
                    [self sharingDoneForType:BZRSharingFacebook];
                    break;
            }
        };
    } else {
        [BZRAlertFacade showNoSocialAccountAlertForController:fromController socialType:BZRSocialTwitter andCompletion:^(UIAlertAction *action, BOOL isCanceled) {
        }];
    }
}

/*
 * Share with Email
 */

- (void)shareWithEmailFromController:(UIViewController*)fromController inviteCode:(NSString*)inviteCode
{
    if ([MFMailComposeViewController canSendMail]) {
        
        [self setupMailMessageComposerAppearance];
        
        MFMailComposeViewController *mailController = [[MFMailComposeViewController alloc] init];
        [mailController setMailComposeDelegate:self];
        [mailController setSubject:kMailSubject];
        [mailController setMessageBody:ShareBody(inviteCode) isHTML:NO];
        
        [fromController presentViewController:mailController animated:YES completion:nil];
        
    } else {
        [BZRAlertFacade showAlertWithMessage:LOCALIZED(@"Unable to send the e-mail.") forController:nil withCompletion:^{
        }];
    }
}

/*
 * Share with Message
 */

- (void)shareWithMessageFromController:(UIViewController*)fromController inviteCode:(NSString*)inviteCode
{
    if ([MFMessageComposeViewController canSendText]) {
        
        [self setupMailMessageComposerAppearance];
        
        MFMessageComposeViewController *messageController = [[MFMessageComposeViewController alloc] init];
        [messageController setMessageComposeDelegate:self];
        [messageController setBody:ShareBody(inviteCode)];
        
        [fromController presentViewController:messageController animated:YES completion:NULL];
        
    } else {
        [BZRAlertFacade showAlertWithMessage:LOCALIZED(@"Unable to send the message.") forController:nil withCompletion:^{
        }];
    }
}

#pragma mark - private

- (void)setupMailMessageComposerAppearance
{
    [[UINavigationBar appearance] setBarTintColor:UIColorFromRGB(0x12a9d6)];
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSFontAttributeName : [UIFont fontWithName:@"OpenSans" size:20.f], NSForegroundColorAttributeName : [UIColor whiteColor]}];
    [[UIBarButtonItem appearanceWhenContainedIn:[UINavigationBar class], nil] setTintColor:[UIColor whiteColor]];
}

- (void)sharingWasCanceledForType:(BZRSharingType)sharingType
{
    if ([self.delegate respondsToSelector:@selector(sharingWasCanceledForType:)]) {
        [self.delegate sharingWasCanceledForType:sharingType];
    }
}

- (void)sharingDoneForType:(BZRSharingType)sharingType
{
    if ([self.delegate respondsToSelector:@selector(sharingDoneForType:)]) {
        [self.delegate sharingDoneForType:sharingType];
    }
}

#pragma mark - MFMailComposeViewControllerDelegate

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    [controller dismissViewControllerAnimated:YES completion:NULL];
}

#pragma mark - MFMessageComposeViewControllerDelegate

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{
    [controller dismissViewControllerAnimated:YES completion:NULL];
}

@end
