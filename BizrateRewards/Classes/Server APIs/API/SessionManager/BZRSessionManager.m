//
//  SESessionManager.m
//  WorkWithServerAPI
//
//  Created by EugeneS on 30.01.15.
//  Copyright (c) 2015 Connexity. All rights reserved.
//

#import "BZRSessionManager.h"
#import "BZRStorageManager.h"

#import "BZRNetworkOperation.h"

#import "BZRReachabilityHelper.h"

#import "BZRErrorHandler.h"

#import "BZRRenewSessionTokenRequest.h"
#import "BZRGetClientCredentialsRequest.h"

static CGFloat const kRequestTimeInterval = 60.f;
static NSInteger const kMaxConcurentRequests = 100.f;
static NSInteger const kAllCleansCount = 1.f;

@interface BZRSessionManager ()

@property (copy, nonatomic) CleanBlock cleanBlock;

@property (strong, nonatomic) AFHTTPSessionManager *sessionManager;

@property (assign, nonatomic) AFNetworkReachabilityStatus reachabilityStatus;

@property (strong, readwrite, nonatomic) NSURL *baseURL;

@property (strong, nonatomic) NSMutableArray *operationsQueue;
@property (strong, nonatomic) NSMutableArray *failedOperationsQueue;

@property (assign, nonatomic) NSUInteger cleanCount;

@property (strong, nonatomic) NSLock *lock;

@property (strong, nonatomic) AFHTTPRequestSerializer *HTTPRequestSerializer;
@property (strong, nonatomic) AFJSONRequestSerializer *JSONRequestSerializer;

@end

@implementation BZRSessionManager

#pragma mark - Accessors

- (NSMutableArray *)failedOperationsQueue
{
    if (!_failedOperationsQueue) {
        _failedOperationsQueue = [NSMutableArray array];
    }
    return _failedOperationsQueue;
}

- (AFJSONRequestSerializer *)JSONRequestSerializer
{
    if (!_JSONRequestSerializer) {
        _JSONRequestSerializer = [AFJSONRequestSerializer serializer];
    }
    return _JSONRequestSerializer;
}

- (AFHTTPRequestSerializer *)HTTPRequestSerializer
{
    if (!_HTTPRequestSerializer) {
        _HTTPRequestSerializer = [AFHTTPRequestSerializer serializer];
    }
    return _HTTPRequestSerializer;
}

#pragma mark - Lifecycle

- (id)initWithBaseURL:(NSURL*)url
{
    if (self = [super init]) {
        
        self.baseURL = url;
        
        if ([NSURLSession class]) {
            NSURLSessionConfiguration* taskConfig = [NSURLSessionConfiguration defaultSessionConfiguration];
            
            taskConfig.HTTPMaximumConnectionsPerHost = kMaxConcurentRequests;
            taskConfig.timeoutIntervalForRequest = kRequestTimeInterval;
            taskConfig.timeoutIntervalForResource = kRequestTimeInterval;
            taskConfig.allowsCellularAccess = YES;
            
            _sessionManager = [[AFHTTPSessionManager alloc] initWithBaseURL:url sessionConfiguration:taskConfig];
            
            [_sessionManager setResponseSerializer:[AFJSONResponseSerializer serializer]];
            [_sessionManager.responseSerializer setAcceptableContentTypes:[NSSet setWithObjects:@"application/schema+json", @"application/json", @"application/x-www-form-urlencoded", nil]];
        }
        
        self.lock = [[NSLock alloc] init];
        self.lock.name = @"CleanSessionLock";
        
        self.operationsQueue = [NSMutableArray array];
        
        WEAK_SELF;
        [[AFNetworkReachabilityManager sharedManager] startMonitoring];
        
        weakSelf.reachabilityStatus = [[AFNetworkReachabilityManager sharedManager] networkReachabilityStatus];
        [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
            weakSelf.reachabilityStatus = status;
            
#ifdef DEBUG
            NSString* stateText = nil;
            switch (weakSelf.reachabilityStatus) {
                case AFNetworkReachabilityStatusUnknown: {
                    stateText = @"Network reachability is unknown";
                    break;
                }
                case AFNetworkReachabilityStatusNotReachable: {
                    stateText = @"Network is not reachable";
                    break;
                }
                case AFNetworkReachabilityStatusReachableViaWWAN: {
                    stateText = @"Network is reachable via WWAN";
                    break;
                }
                case AFNetworkReachabilityStatusReachableViaWiFi: {
                    
                    //restart failed operation
                    [self restartFailedOperationIfNeeded];
                    
                    stateText = @"Network is reachable via WiFi";
                    break;
                }
            }
            NSLog(@"%@", stateText);
#endif
        }];

        self.requestNumber = 0;
        
    }
    return self;
}

#pragma mark - Actions

- (void)cleanManagersWithCompletionBlock:(CleanBlock)block
{
    if ([NSURLSession class]) {
        self.cleanCount = 0;
        self.cleanBlock = block;
        
        WEAK_SELF;
        [_sessionManager setSessionDidBecomeInvalidBlock:^(NSURLSession *session, NSError *error) {
            [weakSelf syncCleans];
            weakSelf.sessionManager = nil;
        }];
        [_sessionManager invalidateSessionCancelingTasks:YES];
    }
}

- (void)syncCleans
{
    [self.lock lock];
    self.cleanCount++;
    [self.lock unlock];
    
    if (self.cleanCount == kAllCleansCount) {
        if (self.cleanBlock) {
            self.cleanBlock();
        }
    }
}

- (id)manager
{
    if (_sessionManager) {
        return _sessionManager;
    }
    return nil;
}

-(void)dealloc
{
    [[AFNetworkReachabilityManager sharedManager] stopMonitoring];
}

#pragma mark - Operation cycle

- (BZRNetworkOperation*)enqueueOperationWithNetworkRequest:(BZRNetworkRequest*)networkRequest success:(SuccessOperationBlock)success
                                                  failure:(FailureOperationBlock)failure
{
    NSError *error = nil;
    id manager = nil;
    
    if ([NSURLSession class]) {
        manager = _sessionManager;
    }
    
    switch (networkRequest.serializationType) {
        case BZRRequestSerializationTypeHTTP:
            [(AFHTTPSessionManager *)manager setRequestSerializer:self.HTTPRequestSerializer];
            break;
            
        case BZRRequestSerializationTypeJSON:
            [(AFHTTPSessionManager *)manager setRequestSerializer:self.JSONRequestSerializer];
            break;
            
        default:
            break;
    }
    
    BZRNetworkOperation *operation = [[BZRNetworkOperation alloc] initWithNetworkRequest:networkRequest networkManager:manager error:&error];
    
    WEAK_SELF;
    if (error && failure) {
        failure(operation ,error, NO);
    } else {
        [self enqueueOperation:operation success:^(BZRNetworkOperation *operation) {
            
            [weakSelf finishOperationInQueue:operation];
            if (success) {
                success(operation);
            }
        } failure:^(BZRNetworkOperation *operation, NSError *error, BOOL isCanceled) {

            if ([BZRErrorHandler errorIsNetworkError:error] && operation.networkRequest.retryIfConnectionFailed) {
                [weakSelf addOperationToFailedQueue:operation];
            }
            
            [weakSelf finishOperationInQueue:operation];
            if (failure) {
                failure(operation, error, isCanceled);
            }
        }];
    }
    return operation;
}

- (void)enqueueOperation:(BZRNetworkOperation*)operation success:(SuccessOperationBlock)success failure:(FailureOperationBlock)failure
{
    WEAK_SELF;
    //check reachability
    [BZRReachabilityHelper checkConnectionOnSuccess:^{
        [operation setCompletionBlockAfterProcessingWithSuccess:success failure:failure];

        [weakSelf addOperationToQueue:operation];
        
    } failure:^(NSError *error) {
        if (failure) {
            failure(operation, error, NO);
        }
    }];
}

/**
 *  Cancel all operations
 */
- (void)cancelAllOperations
{
    if ([NSURLSession class]) {
        
        for (BZRNetworkOperation *operation in self.operationsQueue) {
            [operation cancel];
        }
        [self.sessionManager.operationQueue cancelAllOperations];
    }
}

/**
 *  Check whether operation is in process
 *
 *  @return Returns 'YES' in any operation is in process
 */
- (BOOL)isOperationInProcess
{
    for (BZRNetworkOperation *operation in self.operationsQueue) {
        if ([operation isInProcess]) {
            return YES;
        }
    }
    return NO;
}

/**
 *  Remove operation from normal queue
 *
 *  @param operation Operation that has to be removed
 */
- (void)finishOperationInQueue:(BZRNetworkOperation*)operation
{
    [self.operationsQueue removeObject:operation];
}

/**
 *  Add new operation to normal queue
 *
 *  @param operation Operation that has to be added to queue
 */
- (void)addOperationToQueue:(BZRNetworkOperation*)operation
{
    [self.operationsQueue addObject:operation];
    
    [operation start];
}

/**
 *  Remove operation from failed queue
 *
 *  @param operation Operation that has to be removed
 */
- (void)finishOperationInFailedQueue:(BZRNetworkOperation *)operation
{
    [self.failedOperationsQueue removeObject:operation];
}

/**
 *  Add new operation to failed queue
 *
 *  @param operation Operation that has to be added to queue
 */
- (void)addOperationToFailedQueue:(BZRNetworkOperation *)operation
{
    [self.failedOperationsQueue addObject:operation];
}

/**
 *  Possibility to renew the failed operation, if current request has this requirement .
 */
- (void)restartFailedOperationIfNeeded
{
    if (!self.failedOperationsQueue.count) {
        return;
    }
    
    WEAK_SELF;
    for (BZRNetworkOperation *failedOperation in self.failedOperationsQueue) {
        @autoreleasepool {
            [self enqueueOperationWithNetworkRequest:failedOperation.networkRequest success:^(BZRNetworkOperation *operation) {
                [weakSelf finishOperationInFailedQueue:failedOperation];
                
                if (failedOperation.successBlock) {
                    failedOperation.successBlock(operation);
                }

            } failure:^(BZRNetworkOperation *operation, NSError *error, BOOL isCanceled) {
                [weakSelf finishOperationInFailedQueue:failedOperation];
                
                if (failedOperation.failureBlock) {
                    failedOperation.failureBlock(operation, error, isCanceled);
                }
                
            }];
        }
    }
}

/**
 *  Validate session and renew token if needed
 *
 *  @param sessionType Type of session for validation
 *  @param success     Success Block
 *  @param failure     Failure Block
 */
- (void)validateSessionWithType:(BZRSessionType)sessionType onSuccess:(SuccessBlock)success onFailure:(FailureBlock)failure
{
    BOOL isValid = [self isSessionValidWithType:sessionType];
    
    if (!isValid && sessionType == BZRSessionTypeUser) {
        [self renewSessionTokenOnSuccess:^(BOOL isSuccess) {
            if (success) {
                success(isSuccess);
            }
        } onFailure:^(NSError *error, BOOL isCanceled) {
            if (failure) {
                failure(error, isCanceled);
            }
        }];
    } else if (!isValid && sessionType == BZRSessionTypeApplication) {
        [self getClientCredentialsOnSuccess:^(BOOL isSuccess) {
            if (success) {
                success(isSuccess);
            }
        } onFailure:^(NSError *error, BOOL isCanceled) {
            if (failure) {
                failure(error, isCanceled);
            }
        }];
    } else {
        if (success) {
            success(YES);
        }
    }
}

/**
 *  Validate current session with specific type
 *
 *  @param sessionType Type of session for validation
 *
 *  @return Returns 'YES' if session is valid
 */
- (BOOL)isSessionValidWithType:(BZRSessionType)sessionType
{
    NSString *accessToken;
    NSDate *tokenExpirationDate;
    
    switch (sessionType) {
        case BZRSessionTypeApplication: {
            accessToken = [BZRStorageManager sharedStorage].applicationToken.accessToken;
            tokenExpirationDate = [BZRStorageManager sharedStorage].applicationToken.expirationDate;
            break;
        }
        case BZRSessionTypeUser: {
            accessToken = [BZRStorageManager sharedStorage].userToken.accessToken;
            tokenExpirationDate = [BZRStorageManager sharedStorage].userToken.expirationDate;
            break;
        }
        default:
            break;
    }
    
    return (accessToken.length && ([[NSDate date] compare:tokenExpirationDate] == NSOrderedAscending));
}

#pragma mark - Renew Session Token

- (BZRNetworkOperation *)renewSessionTokenOnSuccess:(void (^)(BOOL isSuccess))success
                                              onFailure:(void (^)(NSError *error, BOOL isCanceled))failure
{
    BZRRenewSessionTokenRequest *request = [[BZRRenewSessionTokenRequest alloc] init];
    BZRNetworkOperation *operation = [self enqueueOperationWithNetworkRequest:request success:^(BZRNetworkOperation *operation) {
        
        BZRRenewSessionTokenRequest *request = (BZRRenewSessionTokenRequest *)operation.networkRequest;
        
        [BZRStorageManager sharedStorage].userToken = request.token;
        
        if (success) {
            success(YES);
        }
        
    } failure:^(BZRNetworkOperation *operation, NSError *error, BOOL isCanceled) {
        
        if (failure) {
            failure(error, isCanceled);
        }
        
    }];
    return operation;
}

#pragma mark - Get Application Token

- (BZRNetworkOperation *)getClientCredentialsOnSuccess:(void (^)(BOOL success))success onFailure:(void (^)(NSError *error, BOOL isCanceled))failure
{
    BZRGetClientCredentialsRequest *request = [[BZRGetClientCredentialsRequest alloc] init];
    
    BZRNetworkOperation *operation = [self enqueueOperationWithNetworkRequest:request success:^(BZRNetworkOperation *operation) {
        
        BZRGetClientCredentialsRequest *request = (BZRGetClientCredentialsRequest*)operation.networkRequest;
        
        [BZRStorageManager sharedStorage].applicationToken = request.token;
        
        if (success) {
            success(YES);
        }
        
    } failure:^(BZRNetworkOperation *operation ,NSError *error, BOOL isCanceled) {
        ShowFailureResponseAlertWithError(error);
        if (failure) {
            failure(error, isCanceled);
        }
    }];
    return operation;
}

@end
