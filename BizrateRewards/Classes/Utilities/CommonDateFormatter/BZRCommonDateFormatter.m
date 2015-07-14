//
//  BZRCommonDateFormatter.m
//  BizrateRewards
//
//  Created by Eugenity on 01.07.15.
//  Copyright (c) 2015 ThinkMobiles. All rights reserved.
//

#import "BZRCommonDateFormatter.h"

@implementation BZRCommonDateFormatter

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

@end
