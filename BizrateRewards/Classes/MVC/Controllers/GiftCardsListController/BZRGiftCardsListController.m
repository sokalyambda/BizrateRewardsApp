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
    static NSString *cellIdentifier = @"giftCardCell";
    
    BZRGiftCard *currentGiftCard = self.giftCards[indexPath.row];
    
    BZRGiftcardCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    
    [cell.giftcardImageView sd_setImageWithURL:currentGiftCard.iconURL];
    
    return cell;
}

@end
