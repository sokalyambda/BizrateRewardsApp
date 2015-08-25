//
//  BZRLocationEvent.m
//  BizrateRewards
//
//  Created by Eugenity on 31.07.15.
//  Copyright (c) 2015 Connexity. All rights reserved.
//

#import "BZRLocationEvent.h"

static NSString *const kLocationId = @"altStoreId";
static NSString *const kLatitude = @"latitude";
static NSString *const kLongitude = @"longitude";
static NSString *const kCustomerId = @"customerId";
static NSString *const kLocationEventType = @"locationEventType";

@interface BZRLocationEvent ()<NSCoding>

@end

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

#pragma mark - NSCoding methods

- (void)encodeWithCoder:(NSCoder *)encoder
{
    //Encode properties, other class variables, etc
    [encoder encodeObject:@(self.coordinate.longitude) forKey:kLongitude];
    [encoder encodeObject:@(self.coordinate.latitude) forKey:kLatitude];
    [encoder encodeObject:@(self.locationId) forKey:kLocationId];
    [encoder encodeObject:self.customerId forKey:kCustomerId];
    [encoder encodeObject:@(self.eventType) forKey:kLocationEventType];
}

- (id)initWithCoder:(NSCoder *)decoder
{
    if((self = [super init])) {
        //decode properties, other class vars
        CGFloat latitude    = [[decoder decodeObjectForKey:kLatitude] doubleValue];
        CGFloat longitude   = [[decoder decodeObjectForKey:kLongitude] doubleValue];
        _coordinate = CLLocationCoordinate2DMake(latitude, longitude);
        _locationId         = [[decoder decodeObjectForKey:kLocationId] integerValue];
        _customerId         = [decoder decodeObjectForKey:kCustomerId];
        _eventType          = [[decoder decodeObjectForKey:kLocationEventType] integerValue];
    }
    return self;
}

#pragma mark - NSUserDefaults methods

- (void)setLocationEventToDefaultsForKey:(NSString *)key
{
    NSData *encodedObject = [NSKeyedArchiver archivedDataWithRootObject:self];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    if ([defaults.dictionaryRepresentation.allKeys containsObject:key]) {
        return;
    }
    
    [defaults setObject:encodedObject forKey:key];
    [defaults synchronize];
}

+ (BZRLocationEvent *)locationEventFromDefaultsForKey:(NSString *)key
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    if (![defaults.dictionaryRepresentation.allKeys containsObject:key]) {
        return nil;
    }
    
    NSData *encodedObject = [defaults objectForKey:key];
    BZRLocationEvent *locationEvent = [NSKeyedUnarchiver unarchiveObjectWithData:encodedObject];
    return locationEvent;
}

@end
