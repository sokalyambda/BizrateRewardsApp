//
//  SESessionManager.h
//  WorkWithServerAPI
//
//  Created by EugeneS on 30.01.15.
//  Copyright (c) 2015 eugenity. All rights reserved.
//

#import "BZRNetworkOperation.h"

typedef void (^CleanBlock)();

@interface BZRSessionManager : NSObject

@property (assign, atomic) NSInteger requestNumber;

@property (strong, nonatomic, readonly) NSURL *baseURL;

- (id)initWithBaseURL:(NSURL*)url;

- (void)cancelAllOperations;

- (void)cleanManagersWithCompletionBlock:(CleanBlock)block;

- (void)enqueueOperation:(BZRNetworkOperation*)operation success:(SuccessOperationBlock)success failure:(FailureOperationBlock)failure;

- (BZRNetworkOperation*)enqueueOperationWithNetworkRequest:(BZRNetworkRequest*)networkRequest success:(SuccessOperationBlock)success failure:(FailureOperationBlock)failure;

@end