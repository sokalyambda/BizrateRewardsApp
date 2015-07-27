//
//  BZRApiConstants.h
//  CarusselSalesTool
//
//  Created by AnatoliyDalekorey on 08.06.15.
//  Copyright (c) 2015 Connexity. All rights reserved.
//

#ifndef BizrateRewards_BZRApiConstants_h
#define BizrateRewards_BZRApiConstants_h

//parameters keys

//API actions

static NSString *const AuthActionKey        = @"oauth/token";
static NSString *const CreateUserKey        = @"user/create";
static NSString *const UserMeKey            = @"user/me";
static NSString *const EligibleSurveysKey   = @"user/survey/eligible";
static NSString *const DeviceKey            = @"user/device";
static NSString *const UserFacebook         = @"user/facebook";

//
static NSString *const GrantTypeKey = @"grant_type";
static NSString *const ClientIdKey = @"client_id";
static NSString *const ClientSecretKey = @"client_secret";

static NSString *const GrantTypeClientCredentials = @"client_credentials";
static NSString *const GrantTypeRefreshToken = @"refresh_token";
static NSString *const GrantTypePassword = @"password";

#endif
