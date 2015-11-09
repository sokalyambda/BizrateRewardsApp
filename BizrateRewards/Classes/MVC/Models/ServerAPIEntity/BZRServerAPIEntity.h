//
//  BZRServerAPIEntity.h
//  Bizrate Rewards
//
//  Created by Eugenity on 27.08.15.
//  Copyright (c) 2015 Connexity. All rights reserved.
//

@interface BZRServerAPIEntity : NSObject

@property (strong, nonatomic) NSString *apiEnv;
@property (strong, nonatomic) NSString *apiBranch;
@property (strong, nonatomic) NSString *apiCommit;
@property (strong, nonatomic) NSString *apiName;
@property (strong, nonatomic) NSString *apiVersion;

@end
