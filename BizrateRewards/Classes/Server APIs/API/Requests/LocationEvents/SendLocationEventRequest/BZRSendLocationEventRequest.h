//
//  BZRSendLocationEventRequest.h
//  BizrateRewards
//
//  Created by Eugenity on 31.07.15.
//  Copyright (c) 2015 Connexity. All rights reserved.
//

#import "BZRNetworkRequest.h"

@class BZRLocationEvent;

@interface BZRSendLocationEventRequest : BZRNetworkRequest

@property (strong, nonatomic) BZRLocationEvent *loggedEvent;

- (instancetype)initWithLocationEvent:(BZRLocationEvent *)locationEvent;

@end
