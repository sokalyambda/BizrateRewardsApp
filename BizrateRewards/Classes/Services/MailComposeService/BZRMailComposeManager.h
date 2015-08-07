//
//  BZRMailComposeService.h
//  BizrateRewards
//
//  Created by Eugenity on 07.08.15.
//  Copyright (c) 2015 Connexity. All rights reserved.
//

@import MessageUI;

typedef void(^MailComposeResult)(MFMailComposeViewController *mailController, MFMailComposeResult composeResult, NSError *error);

@interface BZRMailComposeManager : NSObject

+ (BZRMailComposeManager *)sharedManager;

- (void)showMailComposeControllerWithPresentingController:(UIViewController *)presentingController andResult:(MailComposeResult)result;

@end
