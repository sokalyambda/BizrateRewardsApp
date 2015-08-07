//
//  BZRGiftCard.m
//  BizrateRewards
//
//  Created by Eugenity on 24.06.15.
//  Copyright (c) 2015 Connexity. All rights reserved.
//

#import "BZRGiftCard.h"

static NSString *const kGiftCardName        = @"name";
static NSString *const kGiftCardImageURL    = @"image_url";
static NSString *const kGiftCardId          = @"id";
static NSString *const kGiftBitId           = @"ref_giftbit_id";
static NSString *const kPointsRequired      = @"points_required";
static NSString *const kPriceInCents        = @"price_in_cents";

@implementation BZRGiftCard

#pragma mark - BZRMappingProtocol

- (instancetype)initWithServerResponse:(NSDictionary *)response
{
    self = [super init];
    if (self) {
        _giftCardName       = response[kGiftCardName];
        _giftCardImageURL   = response[kGiftCardImageURL];
        _giftCardId         = [response[kGiftCardId] integerValue];
        _giftBitId          = [response[kGiftBitId] integerValue];
        _pointsRequired     = [response[kPointsRequired] integerValue];
        _priceInCents       = [response[kPriceInCents] integerValue];
    }
    return self;
}

@end
