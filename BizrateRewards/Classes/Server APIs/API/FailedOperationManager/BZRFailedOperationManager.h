//
//  BZRFailedOperationManager.h
//  BizrateRewards
//
//  Created by Eugenity on 06.08.15.
//  Copyright (c) 2015 Connexity. All rights reserved.
//

@class BZRNetworkOperation;

@interface BZRFailedOperationManager : NSObject

+ (BZRFailedOperationManager *)sharedManager;

- (void)restartFailedOperations;

- (void)addFailedOperation:(BZRNetworkOperation *)operation;

@end
