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

@property (assign, nonatomic) BOOL isReachable;

+ (BZRDataManager *)sharedInstance;

//signIn/Up
- (void)getClientCredentialsOnSuccess:(SuccessBlock)completion;

- (void)signInWithUserName:(NSString *)userName password:(NSString *)password withResult:(SuccessBlock)result;

- (void)signUpWithUserFirstName:(NSString *)firstName andUserLastName:(NSString *)lastName andEmail:(NSString *)email withResult:(SuccessBlock)result;

- (void)authorizeWithFacebookWithResult:(SuccessBlock)result;

//get User
- (void)getCurrentUserWithCompletion:(SuccessBlock)completion;

//send device token
- (void)sendDeviceAPNSTokenAndDeviceIdentifierWithResult:(SuccessBlock)result;

@end
