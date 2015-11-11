//
//  BZRGiftCard.h
//  BizrateRewards
//
//  Created by Eugenity on 24.06.15.
//  Copyright (c) 2015 Connexity. All rights reserved.
//

#import "BZRMappingProtocol.h"

@interface BZRGiftCard : NSObject

@property (strong, nonatomic) NSURL *giftCardImageURL;
@property (strong, nonatomic) NSString *giftCardName;
@property (assign, nonatomic) NSInteger giftCardId;
@property (assign, nonatomic) NSInteger giftBitId;
@property (assign, nonatomic) NSInteger pointsRequired;
@property (assign, nonatomic) NSInteger priceInCents;

@end
