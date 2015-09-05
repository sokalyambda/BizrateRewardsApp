//
//  OBCouponItem.h
//  SymphonyEYC
//
//  Created by Praveen Kumar on 4/9/15.
//  Copyright (c) 2015 Praveen Kumar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class OBBeamLocation, OBCategoriesItem, OBImageitems, OBLocationItem;

@interface OBCouponItem : NSManagedObject

@property (nonatomic, retain) NSNumber * beam_reset;
@property (nonatomic, retain) NSString * coupon_code;
@property (nonatomic, retain) NSNumber * discount_amount;
@property (nonatomic, retain) NSDate * expiration;
@property (nonatomic, retain) NSNumber * fav;
@property (nonatomic, retain) NSNumber * favStoreId;
@property (nonatomic, retain) NSNumber * flag;
@property (nonatomic, retain) NSNumber * issuance_limit;
@property (nonatomic, retain) NSString * keywords;
@property (nonatomic, retain) NSDate * last_beamed;
@property (nonatomic, retain) NSString * long_desc;
@property (nonatomic, retain) NSNumber * max_beam;
@property (nonatomic, retain) NSNumber * max_usage;
@property (nonatomic, retain) NSNumber * maxRedeemableTransaction;
@property (nonatomic, retain) NSNumber * numberToBuy;
@property (nonatomic, retain) NSNumber * numofuses;
@property (nonatomic, retain) NSString * offer;
@property (nonatomic, retain) NSString * offer_id;
//@property (nonatomic, retain) NSString * store_id;
@property (nonatomic, retain) NSNumber * purchasedItems;
@property (nonatomic, retain) NSNumber * rank;
@property (nonatomic, retain) NSNumber * sBeamed;
@property (nonatomic, retain) NSNumber * redemptionType;
@property (nonatomic, retain) NSNumber * shareable;
@property (nonatomic, retain) NSSet *obbeam;
@property (nonatomic, retain) OBCategoriesItem *obCategoriesObjects;
@property (nonatomic, retain) NSSet *obFavCouponStore;
@property (nonatomic, retain) OBImageitems *obimageObjects;
@property (nonatomic, retain) NSSet *obstore;
@end

@interface OBCouponItem (CoreDataGeneratedAccessors)

- (void)addObbeamObject:(OBBeamLocation *)value;
- (void)removeObbeamObject:(OBBeamLocation *)value;
- (void)addObbeam:(NSSet *)values;
- (void)removeObbeam:(NSSet *)values;

- (void)addObFavCouponStoreObject:(OBLocationItem *)value;
- (void)removeObFavCouponStoreObject:(OBLocationItem *)value;
- (void)addObFavCouponStore:(NSSet *)values;
- (void)removeObFavCouponStore:(NSSet *)values;

- (void)addObstoreObject:(OBLocationItem *)value;
- (void)removeObstoreObject:(OBLocationItem *)value;
- (void)addObstore:(NSSet *)values;
- (void)removeObstore:(NSSet *)values;

@end
