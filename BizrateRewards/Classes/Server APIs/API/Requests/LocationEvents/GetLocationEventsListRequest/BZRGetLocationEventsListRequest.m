//
//  BZRGetLocationEventsListRequest.m
//  Bizrate Rewards
//
//  Created by Eugenity on 27.08.15.
//  Copyright (c) 2015 Connexity. All rights reserved.
//

#import "BZRGetLocationEventsListRequest.h"

#import "BZRLocationEvent.h"

static NSString *requestAction = @"user/location/event";

@implementation BZRGetLocationEventsListRequest

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self.customHeaders setObject:[NSString stringWithFormat:@"Bearer %@", [BZRStorageManager sharedStorage].userToken.accessToken] forKey:@"Authorization"];
        
        self.serializationType = BZRRequestSerializationTypeJSON;
        self.action = [self requestAction];
        _method = @"GET";
        
        _userAuthorizationRequired = YES;
        _applicationAuthorizationRequired = NO;
        
        [self setParametersWithParamsData:nil];
    }
    return self;
}

- (BOOL)parseJSONDataSucessfully:(id)responseObject error:(NSError *__autoreleasing *)error
{
    if (!responseObject) {
        return NO;
    } else {
        NSMutableArray *events = [NSMutableArray array];
        if ([responseObject isKindOfClass:[NSArray class]]) {
            for (NSDictionary *responseDict in responseObject) {
                BZRLocationEvent *event = [[BZRLocationEvent alloc] initWithServerResponse:responseDict];
                [events addObject:event];
            }
        }
        self.locationEventsList = [NSArray arrayWithArray:events];
        
        return !!self.locationEventsList;
    }
}

- (NSString *)requestAction
{
    return requestAction;
}

@end
