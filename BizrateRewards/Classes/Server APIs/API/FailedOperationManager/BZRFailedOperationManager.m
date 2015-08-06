//
//  BZRFailedOperationManager.m
//  BizrateRewards
//
//  Created by Eugenity on 06.08.15.
//  Copyright (c) 2015 Connexity. All rights reserved.
//

#import "BZRFailedOperationManager.h"

#import "BZRNetworkOperation.h"

#import "BZRProjectFacade.h"

@interface BZRFailedOperationManager ()

@property (strong, nonatomic) BZRSessionManager *sessionManager;

@property (strong, nonatomic) NSMutableArray *failedOperationsQueue;

@end

@implementation BZRFailedOperationManager

#pragma mark - Accessors

- (BZRSessionManager *)sessionManager
{
    return [BZRProjectFacade HTTPClient];
}

- (NSMutableArray *)failedOperationsQueue
{
    if (!_failedOperationsQueue) {
        _failedOperationsQueue = [NSMutableArray array];
    }
    return _failedOperationsQueue;
}

#pragma mark - Lifecycle

+ (BZRFailedOperationManager *)sharedManager
{
    static BZRFailedOperationManager *manager = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[BZRFailedOperationManager alloc] init];
    });
    
    return manager;
}

#pragma mark - Actions

- (void)restartFailedOperations
{
    for (BZRNetworkOperation *failedOperation in self.failedOperationsQueue) {
        [self.sessionManager enqueueOperation:failedOperation success:^(BZRNetworkOperation *operation) {
            
        } failure:^(BZRNetworkOperation *operation, NSError *error, BOOL isCanceled) {
            
        }];
    }
}

- (void)addFailedOperation:(BZRNetworkOperation *)operation
{
    if ([self.failedOperationsQueue containsObject:operation]) {
        [self.failedOperationsQueue addObject:operation];
    }
}

@end
