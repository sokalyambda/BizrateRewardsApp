//
//  OBWebservices.h
//  Engage
//
//  Created by Praveen Kumar on 1/14/15.
//  Copyright (c) 2015 Praveen Kumar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OB_Macro.h"
#import "OB_DBOperations.h"
#import "OB_LocationServices.h"
#import <MapKit/MapKit.h>

#import "OB_DataManager.h"


@interface OB_Webservices : NSObject  {
    
    
}

+(OB_Webservices *) sharedInstance;

-(void) registerCustomerWithParameters:(NSDictionary *) params Type:(NSString *) type onCompletion:(void (^)(NSDictionary *json, NSError *error,BOOL success))onCompletion;

-(void) getStoresAndOffersWithCustomerID:(NSString *) customer_id Latitude:(double) latitude  Longitude:(double) longitude Radius:(float) radius onCompletion:(void (^)(NSDictionary *json, NSError *error,BOOL success))onCompletion;
-(void) getSystemParametersOnCompletion:(void (^)(NSDictionary *json, NSError *error,BOOL success))onCompletion;
-(void) getStoreParametersOnCompletion:(void (^)(NSDictionary *json, NSError *error,BOOL success))onCompletion;
-(void) getCategoriesOnCompletion:(void (^)(NSDictionary *json, NSError *error,BOOL success))onCompletion;
-(void) getRetailersOnCompletion:(void (^)(NSDictionary *json, NSError *error,BOOL success))onCompletion;



-(void) saveCustomerLocationsWithParameters:(NSDictionary *) params Type:(NSString *) type onCompletion:(void (^)(NSDictionary *json, BOOL success))onCompletion;

//- (NSMutableArray *) prepareAnnotations:(NSArray *) stores onClick:(void (^)(NSDictionary *info))onClick;
@end
