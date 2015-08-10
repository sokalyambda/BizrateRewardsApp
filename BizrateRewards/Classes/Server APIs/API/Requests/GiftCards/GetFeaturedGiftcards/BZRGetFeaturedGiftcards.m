//
//  BZRGetFeaturedGiftcards.m
//  BizrateRewards
//
//  Created by Eugenity on 10.08.15.
//  Copyright (c) 2015 Connexity. All rights reserved.
//

#import "BZRGetFeaturedGiftcards.h"

#import "BZRGiftCard.h"

static NSString *requestAction = @"giftcards/featured";

@implementation BZRGetFeaturedGiftcards

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self.customHeaders setObject:[NSString stringWithFormat:@"Bearer %@", [BZRStorageManager sharedStorage].userToken.accessToken] forKey:@"Authorization"];
        
        self.serializationType = BZRRequestSerializationTypeJSON;
        self.action = [self requestAction];
        _method = @"GET";
        
        _userAuthorizationRequired = YES;
        _applicationAuthorizationRequired = NO;
        
        [self setParametersWithParamsData:nil];
    }
    return self;
}

- (BOOL)parseJSONDataSucessfully:(id)responseObject error:(NSError *__autoreleasing *)error
{
    if (!responseObject) {
        return NO;
    } else {
        NSMutableArray *giftCards = [NSMutableArray array];
        if ([responseObject isKindOfClass:[NSArray class]]) {
            for (NSDictionary *responseDict in responseObject) {
                BZRGiftCard *giftCard = [[BZRGiftCard alloc] initWithServerResponse:responseDict];
                [giftCards addObject:giftCard];
            }
        }
        self.featuredGiftCards = [NSArray arrayWithArray:giftCards];
        
        return !!self.featuredGiftCards;
    }
}

- (NSString *)requestAction
{
    return requestAction;
}

@end
