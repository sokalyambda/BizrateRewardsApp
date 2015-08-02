//
//  OBLocationLog.h
//  SymphonyEYC
//
//  Created by Praveen Kumar on 7/9/15.
//  Copyright (c) 2015 Praveen Kumar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface OBLocationLog : NSManagedObject

@property (nonatomic, retain) NSString * accuracy;
@property (nonatomic, retain) NSString * date_location;
@property (nonatomic, retain) NSString * latitude;
@property (nonatomic, retain) NSString * longitude;
@property (nonatomic, retain) NSString * speed;
@property (nonatomic, retain) NSNumber * timestamp;
@property (nonatomic, retain) NSString * timezone;
@property (nonatomic, retain) NSString * beam_id;
@property (nonatomic, retain) NSString * status;
@property (nonatomic, retain) NSNumber * record_id;

@end
