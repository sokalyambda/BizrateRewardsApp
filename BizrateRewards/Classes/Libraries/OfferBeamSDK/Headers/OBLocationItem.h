//
//  OBLocationItem.h
//  SymphonyEYC
//
//  Created by Praveen Kumar on 4/9/15.
//  Copyright (c) 2015 Praveen Kumar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class OBCouponItem, OBImageitems;

@interface OBLocationItem : NSManagedObject

@property (nonatomic, retain) NSDate * bb_exp;
@property (nonatomic, retain) NSNumber * beam;
@property (nonatomic, retain) NSString * beam_time;
@property (nonatomic, retain) NSNumber * distance;
@property (nonatomic, retain) NSString * facebookURL;
@property (nonatomic, retain) NSNumber * favourite;
@property (nonatomic, retain) NSString * logoURL;
@property (nonatomic, retain) NSNumber * max_beam;
@property (nonatomic, retain) NSNumber * penetrationWidth;
@property (nonatomic, retain) NSNumber * radius;
@property (nonatomic, retain) NSString * retailer_address;
@property (nonatomic, retain) NSString * retailer_altaddress;
@property (nonatomic, retain) NSString * retailer_city;
@property (nonatomic, retain) NSString * retailer_full_description;
@property (nonatomic, retain) NSString * retailer_intro;
@property (nonatomic, retain) NSNumber * retailer_latitude;
@property (nonatomic, retain) NSNumber * retailer_longitude;
@property (nonatomic, retain) NSString * retailer_name;
@property (nonatomic, retain) NSString * retailer_phone;
@property (nonatomic, retain) NSString * retailer_state;
@property (nonatomic, retain) NSString * retailer_url;
@property (nonatomic, retain) NSString * retailer_zip;
@property (nonatomic, retain) NSNumber * retailerid;
@property (nonatomic, retain) NSString * store_id;
@property (nonatomic, retain) NSNumber * storeParam;
@property (nonatomic, retain) NSString * storeParameter;
@property (nonatomic, retain) NSString * twitterURL;
@property (nonatomic, retain) NSNumber * wait_time;
@property (nonatomic, retain) NSSet *obcoupon;
@property (nonatomic, retain) OBImageitems *obimageObjects;
@end

@interface OBLocationItem (CoreDataGeneratedAccessors)

- (void)addObcouponObject:(OBCouponItem *)value;
- (void)removeObcouponObject:(OBCouponItem *)value;
- (void)addObcoupon:(NSSet *)values;
- (void)removeObcoupon:(NSSet *)values;

@end
