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

#pragma mark - Actions

- (void)configureCellWithGiftCard:(BZRGiftCard *)giftCard
{
    [self.giftcardImageView sd_setImageWithURL:giftCard.giftCardImageURL];
}

- (void)addBorders
{
//    CALayer *rightBorderLayer = [CALayer layer];
//    CALayer *leftBorderLayer = [CALayer layer];
//    CALayer *bottomBorderLayer = [CALayer layer];
//    
//    rightBorderLayer.backgroundColor = [UIColor lightGrayColor].CGColor;
//    leftBorderLayer.backgroundColor = [UIColor lightGrayColor].CGColor;
//    bottomBorderLayer.backgroundColor = [UIColor lightGrayColor].CGColor;
//    
//    [rightBorderLayer setFrame:CGRectMake(CGRectGetWidth(self.bounds), 0.f, 0.5f, CGRectGetHeight(self.bounds))];
//    [leftBorderLayer setFrame:CGRectMake(0.f, 0.f, 0.5f, CGRectGetHeight(self.bounds))];
//    [bottomBorderLayer setFrame:CGRectMake(0.f, CGRectGetHeight(self.bounds), CGRectGetWidth(self.bounds), 0.5f)];
//    
//    [self.layer addSublayer:rightBorderLayer];
//    [self.layer addSublayer:leftBorderLayer];
//    [self.layer addSublayer:bottomBorderLayer];
}

@end
