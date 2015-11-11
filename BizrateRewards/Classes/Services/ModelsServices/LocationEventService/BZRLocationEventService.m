//
//  BZRLocationEventService.m
//  Bizrate Rewards
//
//  Created by Eugenity on 09.11.15.
//  Copyright © 2015 Connexity. All rights reserved.
//

#import "BZRLocationEventService.h"

#import "BZRLocationEvent.h"

#import "BZRCommonDateFormatter.h"
#import "ISO8601DateFormatter.h"

//keys for OB call back
static NSString *const kOBLocationId = @"altStoreId";
static NSString *const kOBLatitude = @"latitude";
static NSString *const kOBLongitude = @"longitude";
static NSString *const kOBCustomerId = @"customerId";
static NSString *const kOBLocationEventType = @"locationEventType";
static NSString *const kOBLocationEventLink = @"locationEventLink";
static NSString *const kOBLocalCreationDate = @"localCreationDate";
static NSString *const kOBCreationDate      = @"creationDate";

//keys for server response
static NSString *const kServerLatitude = @"lat";
static NSString *const kServerLongitude = @"long";
static NSString *const kServerCustomerId = @"ref_eyc_customer_id";
static NSString *const kServerLocationEventType = @"event_type";
static NSString *const kServerEventCreationDate = @"created";

static NSString *const kServerEventLinks = @"links";
static NSString *const kServerEventLinkRef = @"href";
static NSString *const kServerEventLinkRel = @"rel";
static NSString *const kServerEventLinkLocation = @"location";

@implementation BZRLocationEventService

#pragma mark - Actions

+ (BZRLocationEvent *)locationEventFromServerResponse:(NSDictionary *)response
{
    BZRLocationEvent *locationEvent = [[BZRLocationEvent alloc] init];
    locationEvent.coordinate = CLLocationCoordinate2DMake([response[kServerLatitude] doubleValue], [response[kServerLongitude] doubleValue]);
    locationEvent.customerId = response[kServerCustomerId];
    locationEvent.eventType = [response[kServerLocationEventType] isEqualToString:@"ENTRY"] ? BZRLocationEventTypeEntry : BZRLocationEventTypeExit;
    
    locationEvent.creationDateString = response[kServerEventCreationDate];
    
    //get local date from ISO8601 format
    NSDate *localDate = [[BZRCommonDateFormatter commonISO8601DateFormatter] dateFromString:locationEvent.creationDateString];
    locationEvent.localDateString = [[BZRCommonDateFormatter locationEventsDateFormatter] stringFromDate:localDate];
    
    NSArray *links = response[kServerEventLinks];
    if (links.count) {
        [links enumerateObjectsUsingBlock:^(NSDictionary *linkDict, NSUInteger idx, BOOL *stop) {
            if ([linkDict[kServerEventLinkRel] isEqualToString:kServerEventLinkLocation]) {
                locationEvent.locationLink = linkDict[kServerEventLinkRef];
                *stop = YES;
            }
        }];
    }
    
    return locationEvent;
}

+ (BZRLocationEvent *)locationEventFromOfferBeamResponse:(NSDictionary *)locationData
{
    BZRLocationEvent *locationEvent = [[BZRLocationEvent alloc] init];
    locationEvent.coordinate     = CLLocationCoordinate2DMake([locationData[kOBLatitude] doubleValue], [locationData[kOBLongitude] doubleValue]);
    locationEvent.locationId     = [locationData[kOBLocationId] integerValue];
    locationEvent.customerId     = locationData[kOBCustomerId];
    locationEvent.locationLink   = [NSString stringWithFormat:@"%@/%d", @"https://api.bizraterewards.com/v1/location", locationEvent.locationId];
    
    locationEvent.localDateString = [[BZRCommonDateFormatter locationEventsDateFormatter] stringFromDate:[NSDate date]];
    locationEvent.creationDateString = locationEvent.localDateString;
    
    return locationEvent;
}

#pragma mark - NSCoding

+ (void)encodeLocationEvent:(BZRLocationEvent *)locationEvent
                withEncoder:(NSCoder *)encoder
{
    //Encode properties, other class variables, etc
    [encoder encodeObject:@(locationEvent.coordinate.longitude) forKey:kOBLongitude];
    [encoder encodeObject:@(locationEvent.coordinate.latitude) forKey:kOBLatitude];
    [encoder encodeObject:@(locationEvent.locationId) forKey:kOBLocationId];
    [encoder encodeObject:locationEvent.customerId forKey:kOBCustomerId];
    [encoder encodeObject:@(locationEvent.eventType) forKey:kOBLocationEventType];
    [encoder encodeObject:locationEvent.locationLink forKey:kOBLocationEventLink];
    [encoder encodeObject:locationEvent.creationDateString forKey:kOBCreationDate];
    [encoder encodeObject:locationEvent.localDateString forKey:kOBLocalCreationDate];
}

+ (BZRLocationEvent *)decodeLocationEvent:(BZRLocationEvent *)locationEvent
                              withDecoder:(NSCoder *)decoder
{
    //decode properties, other class vars
    CGFloat latitude    = [[decoder decodeObjectForKey:kOBLatitude] doubleValue];
    CGFloat longitude   = [[decoder decodeObjectForKey:kOBLongitude] doubleValue];
    locationEvent.coordinate = CLLocationCoordinate2DMake(latitude, longitude);
    locationEvent.locationId         = [[decoder decodeObjectForKey:kOBLocationId] integerValue];
    locationEvent.customerId         = [decoder decodeObjectForKey:kOBCustomerId];
    locationEvent.eventType          = [[decoder decodeObjectForKey:kOBLocationEventType] integerValue];
    locationEvent.locationLink       = [decoder decodeObjectForKey:kOBLocationEventLink];
    locationEvent.creationDateString = [decoder decodeObjectForKey:kOBCreationDate];
    locationEvent.localDateString    = [decoder decodeObjectForKey:kOBLocalCreationDate];
    
    return locationEvent;
}

#pragma mark - NSUserDefaults

+ (void)setLocationEvent:(BZRLocationEvent *)locationEvent
        toDefaultsForKey:(NSString *)key
{
    NSData *encodedObject = [NSKeyedArchiver archivedDataWithRootObject:locationEvent];
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
