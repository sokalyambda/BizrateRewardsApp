//
//  BZRLocationEvent.h
//  BizrateRewards
//
//  Created by Eugenity on 31.07.15.
//  Copyright (c) 2015 Connexity. All rights reserved.
//

typedef enum : NSUInteger {
    BZRLocaionEventTypeEntry,
    BZRLocaionEventTypeExit
} BZRLocaionEventType;

#import "BZRMappingProtocol.h"

@import CoreLocation;

@interface BZRLocationEvent : NSObject<BZRMappingProtocol>

@property (assign, nonatomic) BZRLocaionEventType eventType;
@property (assign, nonatomic) CLLocationCoordinate2D coordinate;
@property (assign, nonatomic) NSInteger locationId;

@property (strong, nonatomic) NSString *customerId;

@end
