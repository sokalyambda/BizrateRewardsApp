//
//  Environment+CoreDataProperties.h
//  Bizrate Rewards
//
//  Created by Eugenity on 12.11.15.
//  Copyright © 2015 Connexity. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Environment.h"

NS_ASSUME_NONNULL_BEGIN

@interface Environment (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *mixPanelToken;
@property (nullable, nonatomic, retain) NSString *apiEndpointURLString;
@property (nullable, nonatomic, retain) NSString *environmentName;
@property (nullable, nonatomic, retain) NSNumber *isCurrent;

@end

NS_ASSUME_NONNULL_END
