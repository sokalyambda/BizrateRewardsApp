//
//  BZRLocationEvent.m
//  BizrateRewards
//
//  Created by Eugenity on 31.07.15.
//  Copyright (c) 2015 Connexity. All rights reserved.
//

#import "BZRLocationEvent.h"

#import "BZRLocationEventService.h"

@interface BZRLocationEvent ()<NSCoding>

@end

@implementation BZRLocationEvent

#pragma mark - NSCoding methods

- (void)encodeWithCoder:(NSCoder *)encoder
{
    [BZRLocationEventService encodeLocationEvent:self withEncoder:encoder];
}

- (id)initWithCoder:(NSCoder *)decoder
{
    if((self = [super init])) {
        [BZRLocationEventService decodeLocationEvent:self withDecoder:decoder];
    }
    return self;
}

@end
