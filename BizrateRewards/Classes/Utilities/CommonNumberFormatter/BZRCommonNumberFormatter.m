//
//  BZRCommonNumberFormatter.m
//  BizrateRewards
//
//  Created by Eugenity on 20.07.15.
//  Copyright (c) 2015 Connexity. All rights reserved.
//

#import "BZRCommonNumberFormatter.h"

@implementation BZRCommonNumberFormatter

+ (NSNumberFormatter *)commonNumberFormatter
{
    static NSNumberFormatter *numberFormatter = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        numberFormatter = [[NSNumberFormatter alloc] init];
        [numberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
        numberFormatter.groupingSeparator = @",";
    });
    
    return numberFormatter;
}

@end
