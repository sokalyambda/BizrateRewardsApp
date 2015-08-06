//
//  BZRFailedOperationManager.m
//  BizrateRewards
//
//  Created by Eugenity on 06.08.15.
//  Copyright (c) 2015 Connexity. All rights reserved.
//

#import "BZRFailedOperationManager.h"

#import "BZRProjectFacade.h"

@interface BZRFailedOperationManager ()

@property (strong, nonatomic) BZRSessionManager *sessionManager;

//@property (strong, nonatomic) NSMutableArray *failedOperationsQueue;

@property (strong, nonatomic) BZRNetworkOperation *currentFailedOperation;

@property (copy, nonatomic) SuccessOperationBlock successBlock;
@property (copy, nonatomic) FailureOperationBlock failureBlock;

@end

@implementation BZRFailedOperationManager

#pragma mark - Accessors

- (BZRSessionManager *)sessionManager
{
    return [BZRProjectFacade HTTPClient];
}

//- (NSMutableArray *)failedOperationsQueue
//{
//    if (!_failedOperationsQueue) {
//        _failedOperationsQueue = [NSMutableArray array];
//    }
//    return _failedOperationsQueue;
//}

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

- (void)restartFailedOperation
{
    [self.sessionManager enqueueOperation:self.currentFailedOperation success:self.successBlock failure:self.failureBlock];
}

- (void)addAndRestartFailedOperation:(BZRNetworkOperation *)operation
{
    if (![self.currentFailedOperation isEqual:operation]) {
        self.currentFailedOperation = operation;
        self.currentFailedOperation.successBlock = self.successBlock;
        self.currentFailedOperation.failureBlock = self.failureBlock;
        [self restartFailedOperation];
    } else {
        [self restartFailedOperation];
    }
}

- (void)setFailedOperationSuccessBlock:(SuccessOperationBlock)success andFailureBlock:(FailureOperationBlock)failure
{
    if (success) {
        self.successBlock = success;
    }
    if (failure) {
        self.failureBlock = failure;
    }
}

@end
