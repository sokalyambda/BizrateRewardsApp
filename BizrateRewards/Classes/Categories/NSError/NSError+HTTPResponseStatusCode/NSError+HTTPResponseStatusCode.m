//
//  NSError+HTTPResponseStatusCode.m
//  Bizrate Rewards
//
//  Created by Eugenity on 03.11.15.
//  Copyright © 2015 Connexity. All rights reserved.
//

#import "NSError+HTTPResponseStatusCode.h"

#import <objc/runtime.h>

static char *kHTTPResponseStatusCodeKey = "HTTPResponseStatusCodeKey";

@implementation NSError (HTTPResponseStatusCode)

@dynamic HTTPResponseStatusCode;

- (NSInteger)HTTPResponseStatusCode
{
    return [objc_getAssociatedObject(self, &kHTTPResponseStatusCodeKey) integerValue];
}

- (void)setHTTPResponseStatusCode:(NSInteger)HTTPResponseStatusCode
{
    objc_setAssociatedObject(self, &kHTTPResponseStatusCodeKey, @(HTTPResponseStatusCode), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
