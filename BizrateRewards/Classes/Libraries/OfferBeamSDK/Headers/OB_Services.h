//
//  OB_Services.h
//  Engage
//
//  Created by Praveen Kumar on 1/18/15.
//  Copyright (c) 2015 Praveen Kumar. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "OB_KeyChainStore.h"
#import "OB_LocationServices.h"
#import "OB_Webservices.h"


@interface OB_Services : NSObject

+(OB_Services *) sharedInstance;

@property (nonatomic,strong) NSDictionary *Beacons;
@property (nonatomic,strong) NSDictionary *Geofences;
@property (nonatomic,strong) NSMutableDictionary *beaconNotification;
@property (nonatomic,strong) NSDictionary *Messages;

@property (nonatomic, strong) UIAlertView *globalAlertView;

@property (nonatomic,strong) NSMutableArray *global_stores;
@property (nonatomic,strong) NSMutableArray *global_coupons;

@property (nonatomic,strong) id delegate;

@property (nonatomic,strong) dispatch_queue_t db_queue;
@property (nonatomic,strong) NSString *SDK_Version;



+(void) start;
+(void) setLocationDelegate:(id)delegate;
+(void) setRetailerID:(NSString *)retailer_id;
+(void) setRetailerCode:(NSString *)retailer_code;
+ (CLAuthorizationStatus) startLocationService;


-(NSString *) getUUID;
//- (void)requestAlwaysAuthorization;

-(void) populateiBeaconsRange;
- (UIImage*)loadImage;


@end
