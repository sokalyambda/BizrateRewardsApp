//
//  BZRCiftcardCell.m
//  BizrateRewards
//
//  Created by Admin on 09.07.15.
//  Copyright (c) 2015 Connexity. All rights reserved.
//

#import "BZRGiftcardCell.h"

#import "BZRGiftCard.h"

static CGFloat const kBorderWidth = .5f;

@interface BZRGiftcardCell ()

@property (weak, nonatomic) IBOutlet UIImageView *giftcardImageView;

@end

@implementation BZRGiftcardCell

#pragma mark - Actions

- (void)configureCellWithGiftCard:(BZRGiftCard *)giftCard
{
    [self.giftcardImageView sd_setImageWithURL:giftCard.giftCardImageURL];
}

- (void)addBorders
{
    CALayer *borderLayer = [CALayer layer];
    [borderLayer setFrame:self.bounds];
    borderLayer.borderWidth = kBorderWidth;
    borderLayer.borderColor = UIColorFromRGB(0xD7D7D7).CGColor;
    [self.layer addSublayer:borderLayer];
}

@end
