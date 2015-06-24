//
//  BZRDataManager.h
//  CarusselSalesTool
//
//  Created by AnatoliyDalekorey on 29.05.15.
//  Copyright (c) 2015 ThinkMobiles. All rights reserved.
//

#import "BZRNetworkManager.h"

#import "BZRApiConstants.h"

@interface BZRDataManager : NSObject

@property (strong, atomic, readonly) BZRUserProfile *userProfile;

+ (BZRDataManager *)sharedInstance;

- (void)signInWithUserName:(NSString *)userName password:(NSString *)password withResult:(SuccessBlock)result;

@end
