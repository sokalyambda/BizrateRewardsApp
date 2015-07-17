//
//  BZRChooseSignUpTypeController.h
//  BizrateRewards
//
//  Created by Eugenity on 23.06.15.
//  Copyright (c) 2015 Connexity. All rights reserved.
//

#import "BZRBaseAuthController.h"

@class BZRUserProfile;

@interface BZRChooseSignUpTypeController : BZRBaseAuthController

@property (strong, nonatomic) BZRUserProfile *temporaryProfile;

@end
