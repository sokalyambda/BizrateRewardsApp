//
//  BZRLocationEvent.m
//  BizrateRewards
//
//  Created by Eugenity on 31.07.15.
//  Copyright (c) 2015 Connexity. All rights reserved.
//

#import "BZRLocationEvent.h"

//keys for OB call back
static NSString *const kOBLocationId = @"altStoreId";
static NSString *const kOBLatitude = @"latitude";
static NSString *const kOBLongitude = @"longitude";
static NSString *const kOBCustomerId = @"customerId";
static NSString *const kOBLocationEventType = @"locationEventType";

//keys for server response
static NSString *const kServerLatitude = @"lat";
static NSString *const kServerLongitude = @"long";
static NSString *const kServerCustomerId = @"ref_eyc_customer_id";
static NSString *const kServerLocationEventType = @"event_type";

@interface BZRLocationEvent ()<NSCoding>

@end

@implementation BZRLocationEvent

#pragma mark - BZRMappingProtocol

- (instancetype)initWithServerResponse:(NSDictionary *)response
{
    self = [super init];
    if (self) {
        _coordinate = CLLocationCoordinate2DMake([response[kServerLatitude] doubleValue], [response[kServerLongitude] doubleValue]);
        _customerId = response[kServerCustomerId];
        _eventType = [response[kServerLocationEventType] isEqualToString:@"ENTRY"] ? BZRLocaionEventTypeEntry : BZRLocaionEventTypeExit;
    }
    return self;
}

- (instancetype)initWithOfferBeamCallback:(NSDictionary *)locationData
{
    self = [super init];
    if (self) {
        _coordinate = CLLocationCoordinate2DMake([locationData[kOBLatitude] doubleValue], [locationData[kOBLongitude] doubleValue]);
        _locationId = [locationData[kOBLocationId] integerValue];
        _customerId = locationData[kOBCustomerId];
    }
    return self;
}

#pragma mark - NSCoding methods

- (void)encodeWithCoder:(NSCoder *)encoder
{
    //Encode properties, other class variables, etc
    [encoder encodeObject:@(self.coordinate.longitude) forKey:kOBLongitude];
    [encoder encodeObject:@(self.coordinate.latitude) forKey:kOBLatitude];
    [encoder encodeObject:@(self.locationId) forKey:kOBLocationId];
    [encoder encodeObject:self.customerId forKey:kOBCustomerId];
    [encoder encodeObject:@(self.eventType) forKey:kOBLocationEventType];
}

- (id)initWithCoder:(NSCoder *)decoder
{
    if((self = [super init])) {
        //decode properties, other class vars
        CGFloat latitude    = [[decoder decodeObjectForKey:kOBLatitude] doubleValue];
        CGFloat longitude   = [[decoder decodeObjectForKey:kOBLongitude] doubleValue];
        _coordinate = CLLocationCoordinate2DMake(latitude, longitude);
        _locationId         = [[decoder decodeObjectForKey:kOBLocationId] integerValue];
        _customerId         = [decoder decodeObjectForKey:kOBCustomerId];
        _eventType          = [[decoder decodeObjectForKey:kOBLocationEventType] integerValue];
    }
    return self;
}

#pragma mark - NSUserDefaults methods

- (void)setLocationEventToDefaultsForKey:(NSString *)key
{
    NSData *encodedObject = [NSKeyedArchiver archivedDataWithRootObject:self];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    if ([defaults.dictionaryRepresentation.allKeys containsObject:key]) {
        [defaults removeObjectForKey:key];
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
