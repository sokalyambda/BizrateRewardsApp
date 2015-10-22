//
//  BZRGiftCardsListController.m
//  BizrateRewards
//
//  Created by Eugenity on 27.06.15.
//  Copyright (c) 2015 Connexity. All rights reserved.
//

#import "BZRGiftCardsListController.h"

#import "BZRGiftcardCell.h"

#import "BZRGiftCard.h"

static CGFloat const kCellHeight = 100.f;

@interface BZRGiftCardsListController ()<UICollectionViewDataSource, UICollectionViewDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *giftCardsCollectionView;

@end

@implementation BZRGiftCardsListController

#pragma mark - View Lifecycle

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
//    [self.view layoutIfNeeded];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.giftCards.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    BZRGiftCard *currentGiftCard = self.giftCards[indexPath.row];
    
    BZRGiftcardCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([BZRGiftcardCell class]) forIndexPath:indexPath];
    
    [cell configureCellWithGiftCard:currentGiftCard];
    
    return cell;
}

#pragma mark - UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGSize size = CGSizeZero;
    CGFloat width = CGRectGetWidth(collectionView.bounds) / 2.f;
    size = CGSizeMake(width, kCellHeight);
    return size;
}

@end
