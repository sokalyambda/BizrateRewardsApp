//
//  BZRErrorHandler.h
//  BizrateRewards
//
//  Created by Eugenity on 23.07.15.
//  Copyright (c) 2015 Connexity. All rights reserved.
//

typedef void(^ErrorParsingCompletion)(NSString *alertTitle, NSString *alertMessage);

@interface BZRErrorHandler : NSObject

+ (BOOL)errorIsNetworkError:(NSError *)error;

+ (BOOL)isEmailRegisteredFromError:(NSError *)error;
+ (BOOL)isFacebookUserExistsFromError:(NSError *)error;

+ (BOOL)isEmailAlreadyExistFromError:(NSError *)error;
+ (BOOL)isFacebookEmailAlreadyExistFromError:(NSError *)error;

+ (BOOL)isShareCodeValidFormatFromError:(NSError*)error;

+ (void)parseError:(NSError *)error withCompletion:(ErrorParsingCompletion)completion;

@end
