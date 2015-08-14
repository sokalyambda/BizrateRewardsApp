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

#pragma mark - Public methods

- (void)configureCellWithGiftCard:(BZRGiftCard *)giftCard
{
    [self downloadImageForGiftCard:giftCard];
}

- (void)addBorders
{
    CALayer *borderLayer = [CALayer layer];
    [borderLayer setFrame:self.bounds];
    borderLayer.borderWidth = kBorderWidth;
    borderLayer.borderColor = UIColorFromRGB(0xD7D7D7).CGColor;
    [self.layer addSublayer:borderLayer];
}

#pragma mark - Private methods

- (void)downloadImageForGiftCard:(BZRGiftCard *)giftCard
{
    WEAK_SELF;
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self animated:YES];
    hud.color = [[UIColor clearColor] copy];
    hud.activityIndicatorColor = [UIColor blackColor];
    [self.giftcardImageView sd_setImageWithURL:giftCard.giftCardImageURL completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        [MBProgressHUD hideAllHUDsForView:weakSelf animated:YES];
    }];
}

@end
