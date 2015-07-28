//
//  SESessionManager.m
//  WorkWithServerAPI
//
//  Created by EugeneS on 30.01.15.
//  Copyright (c) 2015 eugenity. All rights reserved.
//

#import "BZRSessionManager.h"
#import "BZRStorageManager.h"

#import "BZRNetworkOperation.h"

#import "BZRReachabilityHelper.h"

#import "BZRErrorHandler.h"

#import "BZRRenewSessionTokenRequest.h"

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
        
        if (operation.networkRequest.autorizationRequired && ![weakSelf isUserSessionValid]) {
            
            BZRNetworkOperation *renewTokenOperation = [self renewSessionTokenOnSuccess:^(BOOL isSuccess) {
                [weakSelf addOperationToQueue:operation];
            } onFailure:^(NSError *error, BOOL isCanceled) {
                failure(renewTokenOperation, error, isCanceled);
            }];
            
        } else {
            [weakSelf addOperationToQueue:operation];
        }
        
//        [weakSelf addOperationToQueue:operation];
    } failure:^(NSError *error) {
        if (failure) {
            failure(operation, error, NO);
        }
    }];
}

- (void)cancelAllOperations
{
    if ([NSURLSession class]) {
        [self.sessionManager.operationQueue cancelAllOperations];
    }
}

//success queue
- (void)finishOperationInQueue:(BZRNetworkOperation*)operation
{
    [self.operationsQueue removeObject:operation];
}

- (void)addOperationToQueue:(BZRNetworkOperation*)operation
{
    [self.operationsQueue addObject:operation];
    [operation start];
}

//failed queue
- (void)finishOperationInFailedQueue:(BZRNetworkOperation *)operation
{
    [self.failedOperationsQueue removeObject:operation];
}

- (void)addOperationToFailedQueue:(BZRNetworkOperation *)operation
{
    [self.failedOperationsQueue addObject:operation];
}

//restart operation

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
                failedOperation.successBlock(operation);
            } failure:^(BZRNetworkOperation *operation, NSError *error, BOOL isCanceled) {
                [weakSelf finishOperationInFailedQueue:failedOperation];
                failedOperation.failureBlock(operation, error, isCanceled);
            }];
        }
    }
}

- (BOOL)isUserSessionValid
{
    NSString *accessToken;
    NSDate *tokenExpirationDate;
    
    accessToken         = [BZRStorageManager sharedStorage].userToken.accessToken;
    tokenExpirationDate = [BZRStorageManager sharedStorage].userToken.expirationDate;
    
    return (accessToken.length && ([[NSDate date] compare:tokenExpirationDate] == NSOrderedAscending));
}

#pragma mark - Renew Session Token

- (BZRNetworkOperation *)renewSessionTokenOnSuccess:(void (^)(BOOL isSuccess))success
                                              onFailure:(void (^)(NSError *error, BOOL isCanceled))failure
{
    BZRRenewSessionTokenRequest *request = [[BZRRenewSessionTokenRequest alloc] init];
    BZRNetworkOperation *operation = [self enqueueOperationWithNetworkRequest:request success:^(BZRNetworkOperation *operation) {
        
        BZRRenewSessionTokenRequest *request = (BZRRenewSessionTokenRequest *)operation.networkRequest;
        
        [BZRStorageManager sharedStorage].userToken = request.userToken;
        
        success(YES);
        
    } failure:^(BZRNetworkOperation *operation, NSError *error, BOOL isCanceled) {
        
        failure(error, isCanceled);
        
    }];
    return operation;
}

@end
