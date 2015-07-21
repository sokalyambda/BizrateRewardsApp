//
//  OBCustomer.h
//  SymphonyEYC
//
//  Created by Praveen Kumar on 4/9/15.
//  Copyright (c) 2015 Praveen Kumar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface OBCustomer : NSManagedObject

@property (nonatomic, retain) NSNumber * app;
@property (nonatomic, retain) NSString * countryCode;
@property (nonatomic, retain) NSNumber * customerId;
@property (nonatomic, retain) NSString * device;
@property (nonatomic, retain) NSString * device_token;
@property (nonatomic, retain) NSString * device_type;
@property (nonatomic, retain) NSNumber * latitude;
@property (nonatomic, retain) NSNumber * longitude;
@property (nonatomic, retain) NSString * os_version;
@property (nonatomic, retain) NSString * postalCode;
@property (nonatomic, retain) NSNumber * privacy;
@property (nonatomic, retain) NSNumber * radius;
@property (nonatomic, retain) NSString * uuid;

@end
