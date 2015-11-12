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

@class BZRServerAPIEntity, FacebookProfile;

@interface BZRStorageManager : NSObject

+ (instancetype)sharedStorage;

@property (strong, nonatomic) BZRApplicationToken *applicationToken;
@property (strong, nonatomic) BZRUserToken *userToken;
@property (strong, nonatomic) BZRUserToken *temporaryUserToken;

@property (strong, nonatomic) BZRUserProfile *currentProfile;
@property (strong, nonatomic) FacebookProfile *facebookProfile;

@property (strong, nonatomic) BZRServerAPIEntity *currentServerAPIEntity;

@property (strong, nonatomic) BZRLocationEvent *lastReceivedLocationEvent;

@property (strong, nonatomic) NSString *deviceToken;
@property (strong, nonatomic) NSString *deviceUDID;
@property (strong, nonatomic) NSString *deviceName;

@property (assign, nonatomic) BOOL resetPasswordFlow;
@property (assign, nonatomic) BOOL resettingPasswordRepeatNeeded;

//url for redirection, it will be saved and if session will become valid after authorization - user will be redirected
@property (strong, nonatomic) NSURL *redirectedSurveyURL;

- (void)swapTokens;

@end
