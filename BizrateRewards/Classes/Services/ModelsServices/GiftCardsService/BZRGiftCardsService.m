//
//  BZRGiftCardsService.m
//  Bizrate Rewards
//
//  Created by Eugenity on 09.11.15.
//  Copyright © 2015 Connexity. All rights reserved.
//

#import "BZRGiftCardsService.h"

#import "BZRGiftCard.h"

static NSString *const kGiftCardName        = @"name";
static NSString *const kGiftCardImageURL    = @"image_url";
static NSString *const kGiftCardId          = @"id";
static NSString *const kGiftBitId           = @"ref_giftbit_id";
static NSString *const kPointsRequired      = @"points_required";
static NSString *const kPriceInCents        = @"price_in_cents";

@implementation BZRGiftCardsService

#pragma mark - Actions

+ (BZRGiftCard *)giftCardFromServerResponse:(NSDictionary *)response
{
    BZRGiftCard *giftCard = [[BZRGiftCard alloc] init];
    giftCard.giftCardName       = response[kGiftCardName];
    giftCard.giftCardImageURL   = response[kGiftCardImageURL];
    giftCard.giftCardId         = [response[kGiftCardId] integerValue];
    giftCard.giftBitId          = [response[kGiftBitId] integerValue];
    giftCard.pointsRequired     = [response[kPointsRequired] integerValue];
    giftCard.priceInCents       = [response[kPriceInCents] integerValue];
    
    return giftCard;
}

@end
