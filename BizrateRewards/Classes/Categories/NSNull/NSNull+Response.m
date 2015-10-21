//
//  NSNull+Response.m
//  Bizrate Rewards
//
//  Created by Eugenity on 20.10.15.
//  Copyright © 2015 Connexity. All rights reserved.
//

#import "NSNull+Response.h"

@implementation NSNull (Response)

- (NSUInteger)length { return 0; }

- (NSInteger)integerValue { return 0; };

- (float)floatValue { return 0; };

- (NSString *)description { return @"0(NSNull)"; }

- (NSArray *)componentsSeparatedByString:(NSString *)separator { return @[]; }

- (id)objectForKey:(id)key { return nil; }

- (BOOL)boolValue { return NO; }

@end
