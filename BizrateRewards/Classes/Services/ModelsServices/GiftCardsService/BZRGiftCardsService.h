//
//  BZRGiftCardsService.h
//  Bizrate Rewards
//
//  Created by Eugenity on 09.11.15.
//  Copyright © 2015 Connexity. All rights reserved.
//

@class BZRGiftCard;

@interface BZRGiftCardsService : NSObject

+ (BZRGiftCard *)giftCardFromServerResponse:(NSDictionary *)response;

@end
