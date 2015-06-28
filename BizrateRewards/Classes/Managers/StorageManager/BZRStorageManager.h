//
//  BZRStorageManager.h
//  BizrateRewards
//
//  Created by Eugenity on 24.06.15.
//  Copyright (c) 2015 ThinkMobiles. All rights reserved.
//

#import "BZRUserProfile.h"
#import "BZRToken.h"

@interface BZRStorageManager : NSObject

+ (instancetype)sharedStorage;

@property (strong, nonatomic) BZRToken *token;
@property (strong, nonatomic) BZRUserProfile *currentProfile;
@property (strong, nonatomic) NSString *deviceToken;

@end
