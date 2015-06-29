//
//  BZRUserProfile.h
//  BizrateRewards
//
//  Created by Eugenity on 24.06.15.
//  Copyright (c) 2015 ThinkMobiles. All rights reserved.
//

#import "BZRMappingProtocol.h"

@interface BZRUserProfile : NSObject<BZRMappingProtocol>

@property (strong, nonatomic) NSURL *avatarURL;

@property (strong, nonatomic) NSString *firstName;
@property (strong, nonatomic) NSString *lastName;
@property (strong, nonatomic) NSString *email;
@property (strong, nonatomic) NSDate *dateOfBirth;
@property (assign, nonatomic) BOOL isMale;

@property (assign, nonatomic, getter=isPushNotificationsEnabled) BOOL pushNotificationsEnabled;
@property (assign, nonatomic, getter=isGeolocationEnabled) BOOL geolocationEnabled;


@end
