//
//  BZRAPIInfoRequest.h
//  Bizrate Rewards
//
//  Created by Eugenity on 27.08.15.
//  Copyright (c) 2015 Connexity. All rights reserved.
//

#import "BZRNetworkRequest.h"

@class BZRServerAPIEntity;

@interface BZRAPIInfoRequest : BZRNetworkRequest

@property (strong, nonatomic) BZRServerAPIEntity *apiEntity;

@end
