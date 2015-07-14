//
//  BZRUserProfile.h
//  BizrateRewards
//
//  Created by Eugenity on 24.06.15.
//  Copyright (c) 2015 Connexity. All rights reserved.
//

#import "BZRMappingProtocol.h"

@interface BZRUserProfile : NSObject<BZRMappingProtocol>

@property (strong, nonatomic) NSURL     *avatarURL;
@property (strong, nonatomic) UIImage   *avatarImage;

@property (strong, nonatomic) NSString  *firstName;
@property (strong, nonatomic) NSString  *lastName;
@property (strong, nonatomic) NSString  *fullName;
@property (strong, nonatomic) NSString  *email;
@property (strong, nonatomic) NSDate    *dateOfBirth;

@property (strong, nonatomic) NSString *genderString;

@property (assign, nonatomic) NSInteger pointsAmount;
@property (assign, nonatomic) NSInteger pointsRequired;

@property (assign, nonatomic) BOOL isMale;

@property (assign, nonatomic, getter=isPushNotificationsEnabled) BOOL pushNotificationsEnabled;
@property (assign, nonatomic, getter=isGeolocationEnabled) BOOL geolocationEnabled;

- (void)setUserProfileToDefaultsForKey:(NSString *)key;
+ (BZRUserProfile *)getUserProfileFromDefaultsForKey:(NSString *)key;

@end
