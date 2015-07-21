//
//  OB_DataManager.h
//  SymphonyEYC
//
//  Created by Praveen Kumar on 4/1/15.
//  Copyright (c) 2015 Praveen Kumar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import <MapKit/MapKit.h>

#import "OB_LocationServices.h"
#import "OBStoreParam.h"
#import "OBCategoriesItem.h"
#import "OBSystemParam.h"
#import "OBImageitems.h"
#import "OBLocationLog.h"
#import "OBCouponItem.h"
#import "OBLocationItem.h"
#import "OBBeamLocation.h"
#import "OBCustomer.h"
#import "Store.h"

@interface OB_DataManager : NSObject {
}


- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;
+ (OB_DataManager*)sharedInstance;
//-(void) testDB;

//-(id)createEntity:(NSString *) entity;
-(id)findFirstByAttribute:(NSString *) attr withValue:(NSString *)value onEntity:(NSString *) entity;
-(NSArray *)findAllByAttribute:(NSString *) attr withValue:(NSString *)value onEntity:(NSString *) entity;
-(NSArray *)findAllWithPredicate:(NSPredicate *) predicate onEntity:(NSString *) entity;

-(NSArray *)findAllonEntity:(NSString *) entity;
-(void)findAllonEntity:(NSString *) entity onCompletion:(void (^)(id result,NSError *error))onCompletion;
-(BOOL)deleteAllonEntity:(NSString *) entity;
-(void)deleteAllonEntity:(NSString *) entity onCompletion:(void (^)(BOOL success,NSError *error))onCompletion;

-(void)findFirstByAttribute:(NSString *) attr withValue:(NSString *)value onEntity:(NSString *) entity  onCompletion:(void (^)(id result,NSError *error))onCompletion;

-(void)findAllWithPredicate:(NSPredicate *) predicate onEntity:(NSString *) entity onCompletion:(void (^)(id result,NSError *error))onCompletion;

-(void) SaveLocationLog:(NSDictionary *) dict onCompletion:(void (^)(BOOL success,NSError *error))onCompletion;
-(void) SaveBeamLocations:(NSArray *) array onCompletion:(void (^)(BOOL success,NSError *error))onCompletion;
-(void) SaveStores:(NSArray *) array onCompletion:(void (^)(BOOL success,NSError *error))onCompletion;
-(void) SaveOffers:(NSArray *) array onCompletion:(void (^)(BOOL success,NSError *error))onCompletion;
-(void) SaveImages:(NSArray *) array onCompletion:(void (^)(BOOL success,NSError *error))onCompletion;
-(void) SaveSystemParams:(NSArray *) array onCompletion:(void (^)(BOOL success,NSError *error))onCompletion;
-(void) SaveStoreParams:(NSArray *) array onCompletion:(void (^)(BOOL success,NSError *error))onCompletion;
-(void) SaveCategories:(NSArray *) array onCompletion:(void (^)(BOOL success,NSError *error))onCompletion;
-(void) UpdateOffersWithImages:(NSArray *) array onCompletion:(void (^)(BOOL success,NSError *error))onCompletion;
-(void) UpdateOfferWithStore:(NSArray *) array onCompletion:(void (^)(BOOL success,NSError *error))onCompletion;
-(void) UpdateStoreWithOffer:(NSArray *) array onCompletion:(void (^)(BOOL success,NSError *error))onCompletion;
-(void) UpdateBeamLocationWithStoreAndOffer:(NSArray *) array onCompletion:(void (^)(BOOL success,NSError *error))onCompletion;
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator;
-(BOOL)requireMigration;


@end