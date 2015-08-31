//
//  BZRLocationEvent.m
//  BizrateRewards
//
//  Created by Eugenity on 31.07.15.
//  Copyright (c) 2015 Connexity. All rights reserved.
//

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
        _eventType = [response[kServerLocationEventType] isEqualToString:@"ENTRY"] ? BZRLocationEventTypeEntry : BZRLocationEventTypeExit;
        
        _creationDateString = response[kServerEventCreationDate];
        
        //get local date from ISO8601 format
        NSDate *localDate = [[BZRCommonDateFormatter commonISO8601DateFormatter] dateFromString:_creationDateString];
        _localDateString = [[BZRCommonDateFormatter locationEventsDateFormatter] stringFromDate:localDate];
        
        NSArray *links = response[kServerEventLinks];
        if (links.count) {
            [links enumerateObjectsUsingBlock:^(NSDictionary *linkDict, NSUInteger idx, BOOL *stop) {
                if ([linkDict[kServerEventLinkRel] isEqualToString:kServerEventLinkLocation]) {
                    _locationLink = linkDict[kServerEventLinkRef];
                    *stop = YES;
                }
            }];
        }
    }
    return self;
}

- (instancetype)initWithOfferBeamCallback:(NSDictionary *)locationData
{
    self = [super init];
    if (self) {
        _coordinate     = CLLocationCoordinate2DMake([locationData[kOBLatitude] doubleValue], [locationData[kOBLongitude] doubleValue]);
        _locationId     = [locationData[kOBLocationId] integerValue];
        _customerId     = locationData[kOBCustomerId];
        _locationLink   = [NSString stringWithFormat:@"%@/%d", @"https://api.bizraterewards.com/v1/location", _locationId];
        
        _localDateString = [[BZRCommonDateFormatter locationEventsDateFormatter] stringFromDate:[NSDate date]];
        _creationDateString = _localDateString;
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
    [encoder encodeObject:self.locationLink forKey:kOBLocationEventLink];
    [encoder encodeObject:_creationDateString forKey:kOBCreationDate];
    [encoder encodeObject:self.localDateString forKey:kOBLocalCreationDate];
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
        _locationLink       = [decoder decodeObjectForKey:kOBLocationEventLink];
        _creationDateString = [decoder decodeObjectForKey:kOBCreationDate];
        _localDateString    = [decoder decodeObjectForKey:kOBLocalCreationDate];
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
