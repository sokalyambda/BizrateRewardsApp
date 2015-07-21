//
//  LocationService.h
//  Engage
//
//  Created by Praveen Kumar on 12/7/14.
//  Copyright (c) 2014 Praveen Kumar. All rights reserved.
//
#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import <UIKit/UIKit.h>
//#import "OB_XMLDictionary.h"
#import <AVFoundation/AVFoundation.h>
#import "OB_Services.h"
#import "OB_NetworkManager.h"


@protocol OB_LocationServicesDelegate <NSObject>

//-(void) OB_storeUpdated:(BOOL) firsttime;
//-(void) OB_registrationStarted;

@optional
-(void) send_message:(NSString *) str;
-(void) OB_receivedOnEnter:(NSDictionary *) offer;
-(void) OB_receivedOnExit:(NSDictionary *) offer;

-(void) OB_receivedOnBKEnter:(NSString *) beacon;

- (void)OB_didEnterRegion:(CLRegion *)region;
- (void)OB_didExitRegion:(CLRegion *)region;

@end



@interface OB_LocationServices : NSObject <CLLocationManagerDelegate>

+(OB_LocationServices *) sharedInstance;

@property (nonatomic,strong) id <OB_LocationServicesDelegate> ob_locationdelegate;

@property bool isMovedSinceLastLogged;
@property double distance_travel_since_last_geofence_fg;
@property long last_update_timestamp;
@property long last_setupfence_timestamp;
@property BOOL created_fence_first_time;
@property (nonatomic, assign) UIBackgroundTaskIdentifier backgroundTaskId;

//@property (strong, nonatomic) OB_LocationServices *ob_LocationService;

@property (strong, nonatomic) CLLocationManager *locationManager;
@property (nonatomic,strong) CLLocation *currentLocation;
@property (nonatomic,strong) CLLocation *oldLocation;
@property BOOL isForground;
@property (nonatomic,strong) NSMutableDictionary *beaconTracker;
@property (nonatomic,strong) NSMutableDictionary *gf_start_counter;
@property (nonatomic,strong) NSMutableDictionary *gf_stop_counter;
@property (nonatomic,strong) NSMutableDictionary *gf_enter_counter;
@property (nonatomic,strong) NSMutableDictionary *gf_exit_counter;
@property (nonatomic,strong) NSMutableDictionary *gf_start_time;
@property (nonatomic,strong) NSMutableDictionary *gf_stop_time;

@property (nonatomic,strong) NSString *current_rewardid;

@property (nonatomic,strong) NSMutableOrderedSet *monitoredGeofences;

@property BOOL gps_running;
@property long gps_last_update_timestamp;


- (CLRegion*)createGeofenceWithId:(NSString *) ident Lat:(double)lat Long:(double)lon radius:(double)radius;
- (void) sendBackgroundRequestToServer: (NSString *) status ForGeofenceID:(NSString *) customer_id;
- (long) getTimeStamp;

@end