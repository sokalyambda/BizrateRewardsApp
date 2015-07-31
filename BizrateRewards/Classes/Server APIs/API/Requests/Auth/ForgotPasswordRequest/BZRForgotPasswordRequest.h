//
//  BZRForgotPasswordRequest.h
//  BizrateRewards
//
//  Created by Eugenity on 31.07.15.
//  Copyright (c) 2015 Connexity. All rights reserved.
//

#import "BZRNetworkRequest.h"

@interface BZRForgotPasswordRequest : BZRNetworkRequest

- (instancetype)initWithUserName:(NSString *)userName andNewPassword:(NSString *)newPassword;

@end
