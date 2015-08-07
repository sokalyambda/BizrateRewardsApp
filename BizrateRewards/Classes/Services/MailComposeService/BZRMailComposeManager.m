//
//  BZRMailComposeService.m
//  BizrateRewards
//
//  Created by Eugenity on 07.08.15.
//  Copyright (c) 2015 Connexity. All rights reserved.
//

#import "BZRMailComposeManager.h"

static NSString *const kBizrateEmailAddress = @"help@bizrate.com";
static NSString *const kMailSubject = @"Bizrate Rewards Mobile App Help";

@interface BZRMailComposeManager ()<MFMailComposeViewControllerDelegate>

@property (copy, nonatomic) MailComposeResult mailComposeResult;

@end

@implementation BZRMailComposeManager

#pragma mark - Lifecycle

+ (BZRMailComposeManager *)sharedManager
{
    static BZRMailComposeManager *manager = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[BZRMailComposeManager alloc] init];
    });
    
    return manager;
}

#pragma mark - Actions

- (void)showMailComposeControllerWithPresentingController:(UIViewController *)presentingController andResult:(MailComposeResult)result
{
    if ([MFMailComposeViewController canSendMail]) {
        
        self.mailComposeResult = result;
        
        MFMailComposeViewController *mailController = [[MFMailComposeViewController alloc] init];
        [mailController setMailComposeDelegate:self];
        [mailController setToRecipients:@[kBizrateEmailAddress]];
        [mailController setSubject:kMailSubject];
        
        [presentingController presentViewController:mailController animated:YES completion:nil];
        
    } else {
        ShowAlert(LOCALIZED(@"Unable to send the e-mail."));
    }
}

#pragma mark - MFMailComposeViewControllerDelegate

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    if (self.mailComposeResult) {
        self.mailComposeResult(controller, result, error);
    }
}

- (void)setupMailComposerAppearance
{

}

@end
