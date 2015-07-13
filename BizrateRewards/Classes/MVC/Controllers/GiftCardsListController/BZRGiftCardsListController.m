//
//  BZRGiftCardsListController.m
//  BizrateRewards
//
//  Created by Eugenity on 27.06.15.
//  Copyright (c) 2015 ThinkMobiles. All rights reserved.
//

#import "BZRGiftCardsListController.h"

#import "BZRGiftcardCell.h"

#import "BZRGiftCard.h"

static NSString *const kGiftCardCell = @"giftCardCell";

@interface BZRGiftCardsListController ()<UICollectionViewDataSource, UICollectionViewDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *giftCardsCollectionView;

@property (strong, nonatomic) NSArray *giftCards;

@end

@implementation BZRGiftCardsListController

#pragma mark - View Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.giftCards count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    BZRGiftCard *currentGiftCard = self.giftCards[indexPath.row];
    
    BZRGiftcardCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kGiftCardCell forIndexPath:indexPath];
    
    [cell.giftcardImageView sd_setImageWithURL:currentGiftCard.iconURL];
    
    return cell;
}

@end
