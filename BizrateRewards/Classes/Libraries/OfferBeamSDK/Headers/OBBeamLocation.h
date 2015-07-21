//
//  OBBeamLocation.h
//  SymphonyEYC
//
//  Created by Praveen Kumar on 4/12/15.
//  Copyright (c) 2015 Praveen Kumar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class OBCouponItem, OBLocationItem;

@interface OBBeamLocation : NSManagedObject

@property (nonatomic, retain) NSString * beam_id;
@property (nonatomic, retain) NSNumber * radius;
@property (nonatomic, retain) NSNumber * beam_latitude;
@property (nonatomic, retain) NSNumber * beam_longitude;
@property (nonatomic, retain) NSString * store_id;
@property (nonatomic, retain) NSString * location;
@property (nonatomic, retain) NSSet *oboffer;
@property (nonatomic, retain) OBLocationItem *obstore;
@end

@interface OBBeamLocation (CoreDataGeneratedAccessors)

- (void)addObofferObject:(OBCouponItem *)value;
- (void)removeObofferObject:(OBCouponItem *)value;
- (void)addOboffer:(NSSet *)values;
- (void)removeOboffer:(NSSet *)values;

@end
