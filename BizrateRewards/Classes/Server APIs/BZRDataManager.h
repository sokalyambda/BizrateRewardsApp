//
//  BZRDataManager.h
//  CarusselSalesTool
//
//  Created by AnatoliyDalekorey on 29.05.15.
//  Copyright (c) 2015 ThinkMobiles. All rights reserved.
//

#import "BZRNetworkManager.h"
#import "BZRStorageManager.h"

#import "BZRApiConstants.h"

@interface BZRDataManager : NSObject

+ (BZRDataManager *)sharedInstance;

- (void)signInWithUserName:(NSString *)userName password:(NSString *)password withResult:(SuccessBlock)result;
- (void)signUpWithUserName:(NSString *)userName password:(NSString *)password withResult:(SuccessBlock)result;

- (void)signInWithFacebookWithResult:(SuccessBlock)result;
- (void)signUpWithFacebookWithResult:(SuccessBlock)result;

@end
