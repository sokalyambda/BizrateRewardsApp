//
//  BZRCommonDateFormatter.m
//  BizrateRewards
//
//  Created by Eugenity on 01.07.15.
//  Copyright (c) 2015 Connexity. All rights reserved.
//

#import "BZRCommonDateFormatter.h"

#import "ISO8601DateFormatter.h"

@implementation BZRCommonDateFormatter

/**
 *  Create common static instance of date formatter with specific format to avoid extra operations each time when we needed in formatter.
 *
 *  @return CommonDateFormatter instance
 */
+ (NSDateFormatter *)commonDateFormatter
{
    static NSDateFormatter *commonDateFormatter = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        commonDateFormatter = [[NSDateFormatter alloc] init];
        
        [commonDateFormatter setDateStyle:NSDateFormatterShortStyle];
        [commonDateFormatter setTimeStyle:NSDateFormatterNoStyle];
        [commonDateFormatter setDateFormat:@"MM/dd/yyyy"];
    });
    
    return commonDateFormatter;
}

/**
 *  Create a static ISO8601 date formatter
 *
 *  @return ISO8601DateFormatter singleton entity
 */
+ (ISO8601DateFormatter *)commonISO8601DateFormatter
{
    static ISO8601DateFormatter *commonDateFormatter = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        commonDateFormatter = [[ISO8601DateFormatter alloc] init];
    });
    
    return commonDateFormatter;
}

+ (NSDateFormatter *)locationEventsDateFormatter
{
    static NSDateFormatter *locationEventsDateFormatter = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        locationEventsDateFormatter = [[NSDateFormatter alloc] init];
        
        [locationEventsDateFormatter setDateStyle:NSDateFormatterShortStyle];
        [locationEventsDateFormatter setTimeStyle:NSDateFormatterShortStyle];
        [locationEventsDateFormatter setTimeZone:[NSTimeZone systemTimeZone]];
    });
    return locationEventsDateFormatter;
}

@end
