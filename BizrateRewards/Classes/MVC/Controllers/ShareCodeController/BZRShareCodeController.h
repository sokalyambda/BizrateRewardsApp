//
//  BZRShareCodeController.h
//  Bizrate Rewards
//
//  Created by Eugenity on 23.10.15.
//  Copyright © 2015 Connexity. All rights reserved.
//

#import "BZRBaseAuthController.h"

@interface BZRShareCodeController : BZRBaseAuthController

@property (strong, nonatomic) BZRUserProfile *temporaryProfile;

@property (assign, nonatomic, getter=isFacebookFlow) BOOL facebookFlow;

@end
