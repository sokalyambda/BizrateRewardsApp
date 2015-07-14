//
//  BZRLocationObserver.h
//  BizrateRewards
//
//  Created by Eugenity on 24.06.15.
//  Copyright (c) 2015 Connexity. All rights reserved.
//

@interface BZRLocationObserver : NSObject

+ (BZRLocationObserver *)sharedObserver;

@property (assign, nonatomic, getter=isAuthorized) BOOL managerAuthorized;

- (void)startUpdatingLocation;

@end
