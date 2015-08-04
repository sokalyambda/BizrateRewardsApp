//
//  BZRStorageManager.h
//  BizrateRewards
//
//  Created by Eugenity on 24.06.15.
//  Copyright (c) 2015 Connexity. All rights reserved.
//

#import "BZRUserProfile.h"
#import "BZRFacebookProfile.h"
#import "BZRUserToken.h"

@interface BZRStorageManager : NSObject

+ (instancetype)sharedStorage;

@property (strong, nonatomic) BZRApplicationToken *applicationToken;
@property (strong, nonatomic) BZRUserToken *userToken;
@property (strong, nonatomic) BZRUserProfile *currentProfile;
@property (strong, nonatomic) BZRFacebookProfile *facebookProfile;

@property (strong, nonatomic) NSString *deviceToken;
@property (strong, nonatomic) NSString *deviceUDID;
@property (strong, nonatomic) NSString *deviceName;

@property (assign, nonatomic) BOOL appOpenedWithURL;

@end
