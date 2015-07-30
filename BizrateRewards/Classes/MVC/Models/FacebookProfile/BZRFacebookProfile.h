//
//  BZRFacebookProfile.h
//  BizrateRewards
//
//  Created by Eugenity on 30.07.15.
//  Copyright (c) 2015 Connexity. All rights reserved.
//

#import "BZRMappingProtocol.h"

@interface BZRFacebookProfile : NSObject<BZRMappingProtocol>

@property (strong, nonatomic) NSString *firstName;
@property (strong, nonatomic) NSString *lastName;
@property (strong, nonatomic) NSString *fullName;
@property (strong, nonatomic) NSString *email;
@property (strong, nonatomic) NSURL *avararURL;
@property (assign, nonatomic) long long userId;

- (void)setFacebookProfileToDefaultsForKey:(NSString *)key;
+ (BZRFacebookProfile *)facebookProfileFromDefaultsForKey:(NSString *)key;

@end
