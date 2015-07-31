//
//  BZRMixpanelService.m
//  BizrateRewards
//
//  Created by Admin on 21.07.15.
//  Copyright (c) 2015 Connexity. All rights reserved.
//

#import "BZRMixpanelService.h"

#import <Mixpanel.h>

static NSString *const kMixpanelToken = @"f818411581cc210c670fe3351a46debe";//@"aae3e2388125817b27b8afcf99093d97";

static NSString *const kMixpanelEventsFile = @"MixpanelEvents";
static NSString *const kPlistResourceType = @"plist";

@implementation BZRMixpanelService


+ (void)setupMixpanel
{
    [Mixpanel sharedInstanceWithToken:kMixpanelToken];
}

+ (void)trackEventWithType:(BZRMixpanelEventType)eventType propertyValue:(NSString *)propertyValue
{
    Mixpanel *mixpanel = [Mixpanel sharedInstance];
    
    NSArray *eventsArray = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:kMixpanelEventsFile ofType:kPlistResourceType]];
    NSString *eventName = [eventsArray[eventType] allKeys].firstObject;
    NSString *propertyKey = eventsArray[eventType][eventName];
    
    if (propertyValue) {
        [mixpanel track:eventName properties:@{propertyKey : propertyValue}];
    } else {
        [mixpanel track:eventName];
    }
}

+ (void)setPeopleWithProperties:(NSDictionary *)properties
{
    Mixpanel *mixpanel = [Mixpanel sharedInstance];
    NSString  *aliasID = [[NSUserDefaults standardUserDefaults] objectForKey:MixpanelAliasID];
    if (!aliasID) {
        aliasID = [properties objectForKey:BizrateIDProperty];
        [mixpanel createAlias:aliasID forDistinctID:mixpanel.distinctId];
        [mixpanel identify:mixpanel.distinctId];
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:aliasID forKey:MixpanelAliasID];
        [defaults synchronize];
    }
    [mixpanel.people set:properties];
}

@end
