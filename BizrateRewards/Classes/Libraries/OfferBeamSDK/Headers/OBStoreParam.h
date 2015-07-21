//
//  OBStoreParam.h
//  SymphonyEYC
//
//  Created by Praveen Kumar on 4/9/15.
//  Copyright (c) 2015 Praveen Kumar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface OBStoreParam : NSManagedObject

@property (nonatomic, retain) NSNumber * store_param_id;
@property (nonatomic, retain) NSNumber * store_param_parking_size;
@property (nonatomic, retain) NSNumber * store_param_penetration_width;
@property (nonatomic, retain) NSNumber * store_param_radius;
@property (nonatomic, retain) NSNumber * store_param_wait_time;

@end
