//
//  BZRNetworkManager.h
//  CarusselSalesTool
//
//  Created by AnatoliyDalekorey on 29.05.15.
//  Copyright (c) 2015 ThinkMobiles. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>

typedef void(^SuccessBlock)(BOOL success, NSError *error);

@interface BZRNetworkManager : AFHTTPSessionManager

@end
