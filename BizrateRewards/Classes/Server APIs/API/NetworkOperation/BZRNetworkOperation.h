//
//  SENetworkOperation.h
//  WorkWithServerAPI
//
//  Created by EugeneS on 30.01.15.
//  Copyright (c) 2015 Connexity. All rights reserved.
//

#import "BZRNetworkRequest.h"

@interface BZRNetworkOperation : NSObject

typedef void (^SuccessOperationBlock)(BZRNetworkOperation* operation);
typedef void (^FailureOperationBlock)(BZRNetworkOperation* operation, NSError* error, BOOL isCanceled);

typedef void (^SuccessBlock)(BOOL isSuccess);
typedef void (^FailureBlock)(NSError* error, BOOL isCanceled);

typedef void (^ProgressBlock)(BZRNetworkOperation* operation, long long totalBytesWritten, long long totalBytesExpectedToWrite);

- (id)initWithNetworkRequest:(BZRNetworkRequest*)networkRequest networkManager:(id)manager error:(NSError *__autoreleasing *)error;
- (void)setCompletionBlockAfterProcessingWithSuccess:(SuccessOperationBlock)success
                                             failure:(FailureOperationBlock)failure;
- (void)setProgressBlock:(ProgressBlock)block;

- (void)start;
- (void)pause;
- (void)cancel;

@property (strong, nonatomic) NSDictionary *allHeaders;
@property (strong, nonatomic, readonly) BZRNetworkRequest *networkRequest;

@property (copy, nonatomic) SuccessOperationBlock successBlock;
@property (copy, nonatomic) FailureOperationBlock failureBlock;

@end
