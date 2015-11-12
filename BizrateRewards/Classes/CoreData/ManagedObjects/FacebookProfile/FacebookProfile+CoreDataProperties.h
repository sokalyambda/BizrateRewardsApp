//
//  FacebookProfile+CoreDataProperties.h
//  Bizrate Rewards
//
//  Created by Eugenity on 12.11.15.
//  Copyright © 2015 Connexity. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "FacebookProfile.h"

NS_ASSUME_NONNULL_BEGIN

@interface FacebookProfile (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *firstName;
@property (nullable, nonatomic, retain) NSString *lastName;
@property (nullable, nonatomic, retain) NSString *fullName;
@property (nullable, nonatomic, retain) NSString *email;
@property (nullable, nonatomic, retain) NSString *avatarURLString;
@property (nullable, nonatomic, retain) NSNumber *facebookUserId;
@property (nullable, nonatomic, retain) NSString *genderString;
@property (nullable, nonatomic, retain) NSNumber *isLogined;
@property (nullable, nonatomic, retain) FacebookAccessToken *facebookAccessToken;

@end

NS_ASSUME_NONNULL_END
