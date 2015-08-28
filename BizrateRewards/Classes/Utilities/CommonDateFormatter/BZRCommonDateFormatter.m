//
//  BZRCommonDateFormatter.m
//  BizrateRewards
//
//  Created by Eugenity on 01.07.15.
//  Copyright (c) 2015 Connexity. All rights reserved.
//

#import "BZRCommonDateFormatter.h"

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

+ (NSDateFormatter *)locationEventsDateFormatter
{
    static NSDateFormatter *locationEventsDateFormatter = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        locationEventsDateFormatter = [[NSDateFormatter alloc] init];
//        [commonDateFormatter setDateStyle:NSDateFormatterShortStyle];
//        [commonDateFormatter setTimeStyle:NSDateFormatterNoStyle];
        [locationEventsDateFormatter setDateFormat:@"yyyy-MM-dd"];
    });
    return locationEventsDateFormatter;
}

@end
