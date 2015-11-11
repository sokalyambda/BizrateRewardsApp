//
//  BZRCustomURLHandler.h
//  BizrateRewards
//
//  Created by Eugenity on 31.07.15.
//  Copyright (c) 2015 Connexity. All rights reserved.
//

@interface BZRCustomURLHandler : NSObject

//parsed parameters for password resetting
+ (NSDictionary *)urlParsingParametersForPasswordResetFromURL:(NSURL *)url;

//parsed parameters for survey
+ (NSDictionary *)urlParsingParametersForSurveyFromURL:(NSURL *)url;

@end
