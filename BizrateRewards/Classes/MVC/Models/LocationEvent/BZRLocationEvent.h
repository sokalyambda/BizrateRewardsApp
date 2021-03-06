//
//  BZRLocationEvent.h
//  BizrateRewards
//
//  Created by Eugenity on 31.07.15.
//  Copyright (c) 2015 Connexity. All rights reserved.
//

typedef enum : NSUInteger {
    BZRLocationEventTypeEntry,
    BZRLocationEventTypeExit
} BZRLocaionEventType;

#import "BZRMappingProtocol.h"

@import CoreLocation;

@interface BZRLocationEvent : NSObject

@property (assign, nonatomic) BZRLocaionEventType eventType;
@property (assign, nonatomic) CLLocationCoordinate2D coordinate;
@property (assign, nonatomic) NSInteger locationId;
@property (strong, nonatomic) NSString *customerId;

@property (strong, nonatomic) NSString *creationDateString;
@property (strong, nonatomic) NSString *localDateString;
@property (strong, nonatomic) NSString *locationLink;

@end
