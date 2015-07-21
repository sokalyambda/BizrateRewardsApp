//
//  OB_DBOperations.h
//  Engage
//
//  Created by Praveen Kumar on 1/18/15.
//  Copyright (c) 2015 Praveen Kumar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OB_DataManager.h"
#import <MapKit/MapKit.h>

@interface OB_DBOperations : NSObject

//+(BOOL) insertIntoTable:(NSString *)table WithData:(NSDictionary  *) dict;
+(NSMutableArray *)getOffersWithLatitude:(double) latitude  Longitude:(double) longitude Radius:(float) radius;
+(void)getOffersWithLatitude:(double) latitude  Longitude:(double) longitude Radius:(float) radius onCompletion:(void (^)(id result))onCompletion;

+(NSMutableArray *)getOffersByRegion:(MKCoordinateRegion) region;

+(NSMutableArray *)getBeamsWithLatitude:(double) latitude  Longitude:(double) longitude Radius:(float) radius;
+(NSMutableArray *)getBeamsByRegion:(MKCoordinateRegion) region;
+(void)getBeamsByRegion:(MKCoordinateRegion) region onCompletion:(void (^)(id result))onCompletion;

+ (id) getCouponById:(NSString *) coupon_id;
+ (id) getLocationById:(NSString *) location_id;
+(NSMutableArray *)getCouponsFor:(NSSet *) set;
+(NSMutableArray *)getCouponsForStoreID:(NSString *) store_id;

@end
