//
//  BZRGetStartedController.h
//  BizrateRewards
//
//  Created by Eugenity on 23.06.15.
//  Copyright (c) 2015 Connexity. All rights reserved.
//

#import "BZRBaseViewController.h"

@interface BZRGetStartedController : BZRBaseViewController

@property (assign, nonatomic, getter=isRedirectedFromFacebookSignInFlow) BOOL redirectedFromFacebookSignInFlow;

@property (strong, nonatomic) NSString *failedToSignInEmail;

@property (assign, nonatomic) BOOL hideEmailField;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *containerHeightConstraint;

@end
