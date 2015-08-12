//
//  BZRErrorHandler.h
//  BizrateRewards
//
//  Created by Eugenity on 23.07.15.
//  Copyright (c) 2015 Connexity. All rights reserved.
//

@interface BZRErrorHandler : NSObject

+ (NSString *)stringFromNetworkError:(NSError *)error;

+ (BOOL)errorIsNetworkError:(NSError *)error;

+ (BOOL)isEmailRegisteredFromError:(NSError *)error;
+ (BOOL)isFacebookUserExistsFromError:(NSError *)error;

@end
