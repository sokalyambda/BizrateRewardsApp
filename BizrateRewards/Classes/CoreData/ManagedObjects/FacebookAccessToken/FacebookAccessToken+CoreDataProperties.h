//
//  FacebookAccessToken+CoreDataProperties.h
//  Bizrate Rewards
//
//  Created by Eugenity on 12.11.15.
//  Copyright © 2015 Connexity. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "FacebookAccessToken.h"

NS_ASSUME_NONNULL_BEGIN

@interface FacebookAccessToken (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *tokenValue;
@property (nullable, nonatomic, retain) NSDate *expirationDate;
@property (nullable, nonatomic, retain) FacebookProfile *facebookProfile;

@end

NS_ASSUME_NONNULL_END
