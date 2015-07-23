//
//  BZRAuhorizationService.m
//  BizrateRewards
//
//  Created by Eugenity on 21.07.15.
//  Copyright (c) 2015 Connexity. All rights reserved.
//

#import "BZRAuthorizationService.h"

#import "BZRDataManager.h"

@implementation BZRAuthorizationService

+ (void)getClientCredentialsOnSuccess:(AuthorizationSuccessBlock)success onFailure:(AuthorizationFailureBlock)failure
{
    [[BZRDataManager sharedInstance] validateSessionWithType:BZRSessionTypeApplication withCompletion:^(BOOL isValid, NSError *error) {
        
        if (error) {
            return failure(error);
        }
        
        if (!isValid) {
            [BZRReachabilityHelper checkConnectionOnSuccess:^{
                [[BZRDataManager sharedInstance] getClientCredentialsOnSuccess:^(id responseObject) {
                    
                    BZRApplicationToken *token = [[BZRApplicationToken alloc] initWithServerResponse:responseObject];
                    [BZRStorageManager sharedStorage].applicationToken = token;
                    success(token);
                    
                } onFailure:^(NSError *error) {
                    failure(error);
                }];
            } failure:^{
                ShowAlert(InternetIsNotReachableString);
                failure(nil);
            }];
        } else {
            success([BZRStorageManager sharedStorage].applicationToken);
        }
    }];
}

+ (void)signInWithUserName:(NSString *)userName password:(NSString *)password onSuccess:(AuthorizationSuccessBlock)success onFailure:(AuthorizationFailureBlock)failure
{
    [BZRReachabilityHelper checkConnectionOnSuccess:^{
        [[BZRDataManager sharedInstance] signInWithUserName:userName password:password onSuccess:^(id responseObject) {
            
            BZRUserToken *token = [[BZRUserToken alloc] initWithServerResponse:responseObject];
            [BZRStorageManager sharedStorage].userToken = token;
            
            success(token);
            
        } onFailure:^(NSError *error) {
            failure(error);
        }];
    } failure:^{
        ShowAlert(InternetIsNotReachableString);
        failure(nil);
    }];
}

+ (void)signUpWithUserFirstName:(NSString *)firstName
                andUserLastName:(NSString *)lastName
                       andEmail:(NSString *)email
                    andPassword:(NSString *)password
                 andDateOfBirth:(NSString *)birthDate
                      andGender:(NSString *)gender
                      onSuccess:(AuthorizationSuccessBlock)success
                      onFailure:(AuthorizationFailureBlock)failure
{
    WEAK_SELF;
    [BZRReachabilityHelper checkConnectionOnSuccess:^{
        
        [weakSelf getClientCredentialsOnSuccess:^(BZRApplicationToken *token) {
            
            [[BZRDataManager sharedInstance] signUpWithUserFirstName:firstName andUserLastName:lastName andEmail:email andPassword:password andDateOfBirth:birthDate andGender:gender onSuccess:^(id responseObject) {
                BZRUserToken *token = [[BZRUserToken alloc] initWithServerResponse:responseObject];
                [BZRStorageManager sharedStorage].userToken = token;
                
                success(token);
            } onFailure:^(NSError *error) {
                failure(error);
            }];
            
        } onFailure:^(NSError *error) {
            failure(error);
        }];
    } failure:^{
        ShowAlert(InternetIsNotReachableString);
        failure(nil);
    }];
}

+ (void)authorizeWithFacebookAccountOnSuccess:(AuthorizationSuccessBlock)success onFailure:(AuthorizationFailureBlock)failure
{
    [BZRReachabilityHelper checkConnectionOnSuccess:^{
        [[BZRDataManager sharedInstance] authorizeWithFacebookOnSuccess:^(id responseObject) {
            
            BZRUserToken *token = [[BZRUserToken alloc] initWithServerResponse:responseObject];
            [BZRStorageManager sharedStorage].userToken = token;
            
            success(token);
            
        } onFailure:^(NSError *error) {
            failure(error);
        }];
    } failure:^{
        ShowAlert(InternetIsNotReachableString);
        failure(nil);
    }];
}

@end
