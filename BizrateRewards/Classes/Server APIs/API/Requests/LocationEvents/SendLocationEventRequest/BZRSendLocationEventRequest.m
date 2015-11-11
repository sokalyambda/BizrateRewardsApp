//
//  BZRSendLocationEventRequest.m
//  BizrateRewards
//
//  Created by Eugenity on 31.07.15.
//  Copyright (c) 2015 Connexity. All rights reserved.
//

#import "BZRSendLocationEventRequest.h"

#import "BZRLocationEvent.h"

#import "BZRLocationEventService.h"

static NSString *const requestAction = @"user/location/event";

static NSString *const kLocation    = @"location";
static NSString *const kId          = @"id";
static NSString *const kLatitude    = @"lat";
static NSString *const kLongitude   = @"long";
static NSString *const kCustomerId  = @"ref_eyc_customer_id";
static NSString *const kEventType   = @"event_type";

@implementation BZRSendLocationEventRequest

#pragma mark - Lifecycle

- (instancetype)initWithLocationEvent:(BZRLocationEvent *)locationEvent
{
    self = [super init];
    if (self) {
        [self.customHeaders setObject:[NSString stringWithFormat:@"Bearer %@", [BZRStorageManager sharedStorage].userToken.accessToken] forKey:@"Authorization"];
        
        self.serializationType = BZRRequestSerializationTypeJSON;
        self.action = [self requestAction];
        _method = @"POST";
        
        _userAuthorizationRequired = YES;
        _applicationAuthorizationRequired = NO;
        
        NSString *eventTypeString = locationEvent.eventType == BZRLocationEventTypeEntry ? @"ENTRY" : @"EXIT";
        NSDictionary *parameters = @{kLocation: @{kId: @(locationEvent.locationId)}, kLatitude: @(locationEvent.coordinate.latitude), kLongitude: @(locationEvent.coordinate.longitude), kCustomerId: locationEvent.customerId, kEventType: eventTypeString};
        
        [self setParametersWithParamsData:parameters];
    }
    return self;
}

- (NSString *)requestAction
{
    return requestAction;
}

- (BOOL)parseJSONDataSucessfully:(id)responseObject error:(NSError *__autoreleasing *)error
{
    if (!responseObject) {
        return NO;
    } else {
        self.loggedEvent = [BZRLocationEventService locationEventFromServerResponse:responseObject];
        return !!self.loggedEvent;
    }
}

@end
