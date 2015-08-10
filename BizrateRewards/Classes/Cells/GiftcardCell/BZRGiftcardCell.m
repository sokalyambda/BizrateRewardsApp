//
//  BZRCiftcardCell.m
//  BizrateRewards
//
//  Created by Admin on 09.07.15.
//  Copyright (c) 2015 Connexity. All rights reserved.
//

#import "BZRGiftcardCell.h"

#import "BZRGiftCard.h"

@interface BZRGiftcardCell ()

@property (weak, nonatomic) IBOutlet UIImageView *giftcardImageView;

@end

@implementation BZRGiftcardCell

- (void)configureCellWithGiftCard:(BZRGiftCard *)giftCard
{
    [self.giftcardImageView sd_setImageWithURL:giftCard.giftCardImageURL];
}

@end
