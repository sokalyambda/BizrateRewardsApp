//
//  BZRLocationEvent.m
//  BizrateRewards
//
//  Created by Eugenity on 31.07.15.
//  Copyright (c) 2015 Connexity. All rights reserved.
//

#import "BZRLocationEvent.h"

static NSString *const kLocationId = @"locationId";
static NSString *const kLatitude = @"latitude";
static NSString *const kLongitude = @"longitude";
static NSString *const kCustomerId = @"customerId";

@implementation BZRLocationEvent

#pragma mark - BZRMappingProtocol

- (instancetype)initWithServerResponse:(NSDictionary *)response
{
    self = [super init];
    if (self) {
        _coordinate = CLLocationCoordinate2DMake([response[kLatitude] doubleValue], [response[kLongitude] doubleValue]);
        _locationId = [response[kLocationId] integerValue];
        _customerId = response[kCustomerId];
    }
    return self;
}

@end
