//
//  OBCategoriesItem.h
//  SymphonyEYC
//
//  Created by Praveen Kumar on 4/9/15.
//  Copyright (c) 2015 Praveen Kumar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class OBCouponItem;

@interface OBCategoriesItem : NSManagedObject

@property (nonatomic, retain) NSString * category;
@property (nonatomic, retain) NSNumber * category_setting;
@property (nonatomic, retain) NSNumber * categoryid;
@property (nonatomic, retain) NSNumber * main_cat;
@property (nonatomic, retain) NSSet *obCouponsObject;
@end

@interface OBCategoriesItem (CoreDataGeneratedAccessors)

- (void)addObCouponsObjectObject:(OBCouponItem *)value;
- (void)removeObCouponsObjectObject:(OBCouponItem *)value;
- (void)addObCouponsObject:(NSSet *)values;
- (void)removeObCouponsObject:(NSSet *)values;

@end
