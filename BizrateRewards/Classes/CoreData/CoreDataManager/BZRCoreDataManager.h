//
//  BZRCoreDataManager.h
//  Bizrate Rewards
//
//  Created by Eugenity on 12.11.15.
//  Copyright © 2015 Connexity. All rights reserved.
//

@interface BZRCoreDataManager : NSObject

@property (strong, nonatomic, readonly) NSManagedObjectContext          *managedObjectContext;
@property (strong, nonatomic, readonly) NSManagedObjectModel            *managedObjectModel;
@property (strong, nonatomic, readonly) NSPersistentStoreCoordinator    *persistentStoreCoordinator;

+ (BZRCoreDataManager *)sharedCoreDataManager;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

- (void)deleteManagedObject:(NSManagedObject *)object;
- (void)deleteCollection:(id<NSFastEnumeration>)collection;
- (void)deleteAllObjects:(NSString*)entityDescription;

- (NSManagedObject*)addNewManagedObjectForName:(NSString*)name;
- (NSArray*)getEntities:(NSString*)entityName byPredicate:(NSPredicate*)predicate;
- (NSArray*)getEntities:(NSString*)entityName;

@end
