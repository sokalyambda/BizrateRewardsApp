//
//  BZRUserProfile.h
//  BizrateRewards
//
//  Created by Eugenity on 24.06.15.
//  Copyright (c) 2015 Connexity. All rights reserved.
//

#import "BZRMappingProtocol.h"

@interface BZRUserProfile : NSObject

@property (strong, nonatomic) NSURL     *avatarURL;

@property (strong, nonatomic) NSString  *firstName;
@property (strong, nonatomic) NSString  *lastName;
@property (strong, nonatomic) NSString  *fullName;
@property (strong, nonatomic) NSString  *email;
@property (strong, nonatomic) NSDate    *dateOfBirth;
@property (strong, nonatomic) NSString  *contactID;
@property (strong, nonatomic) NSString  *shareCode;

@property (assign, nonatomic) long long userId;

@property (strong, nonatomic) NSURL *redemptionURL;
@property (assign, nonatomic) BOOL allowRedemption;

@property (strong, nonatomic) NSString *genderString;

@property (assign, nonatomic) NSInteger pointsAmount;
@property (assign, nonatomic) NSInteger pointsRequired;

@property (assign, nonatomic, getter=isTestUser) BOOL testUser;

@property (strong, nonatomic) NSArray *eligibleSurveys;

@property (assign, nonatomic) BOOL isMale;

@property (assign, nonatomic, getter=isRemoteNotificationsEnabled) BOOL remoteNotificationsEnabled;
@property (assign, nonatomic, getter=isGeolocationAccessGranted) BOOL geolocationAccessGranted;

@end
