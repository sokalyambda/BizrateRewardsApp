//
//  OBImageitems.h
//  SymphonyEYC
//
//  Created by Praveen Kumar on 4/9/15.
//  Copyright (c) 2015 Praveen Kumar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class OBCouponItem, OBLocationItem;

@interface OBImageitems : NSManagedObject

@property (nonatomic, retain) NSData * image_data;
@property (nonatomic, retain) NSNumber * image_id;
@property (nonatomic, retain) NSString * image_url;
@property (nonatomic, retain) NSNumber * search_for_image;
@property (nonatomic, retain) OBCouponItem *obcouponObject;
@property (nonatomic, retain) OBLocationItem *oblocationObject;

@end
