//
//  SESessionManager.m
//  WorkWithServerAPI
//
//  Created by EugeneS on 30.01.15.
//  Copyright (c) 2015 eugenity. All rights reserved.
//

#import "BZRSessionManager.h"

#import "BZRNetworkOperation.h"

#import "BZRReachabilityHelper.h"

#import "BZRErrorHandler.h"

static CGFloat const kRequestTimeInterval = 60.f;
static NSInteger const kMaxConcurentRequests = 100.f;
static NSInteger const kAllCleansCount = 1.f;

@interface BZRSessionManager ()

@property (copy, nonatomic) CleanBlock cleanBlock;
@property (copy, nonatomic) SuccessOperationBlock successBlock;
@property (copy, nonatomic) FailureOperationBlock failureBlock;

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
//        self.failedOperationsQueue = [NSMutableArray array];
        
        WEAK_SELF;
        [[AFNetworkReachabilityManager sharedManager] startMonitoring];
        
//        weakSelf.reachabilityStatus = [[AFNetworkReachabilityManager sharedManager] networkReachabilityStatus];
        
        [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
            weakSelf.reachabilityStatus = status;
            
#ifdef DEBUG
            NSString* stateText = nil;
            switch (weakSelf.reachabilityStatus) {
                case AFNetworkReachabilityStatusUnknown:
                    stateText = @"Network reachability is unknown";
                    break;
                case AFNetworkReachabilityStatusNotReachable:
                    stateText = @"Network is not reachable";
                    break;
                case AFNetworkReachabilityStatusReachableViaWWAN:
                    stateText = @"Network is reachable via WWAN";
                    break;
                case AFNetworkReachabilityStatusReachableViaWiFi: {
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

#pragma mark - Public methods

- (BOOL)isSessionValid
{
    return NO;
}

#pragma mark - Operation cycle

- (BZRNetworkOperation*)enqueueOperationWithNetworkRequest:(BZRNetworkRequest*)networkRequest success:(SuccessOperationBlock)success
                                                  failure:(FailureOperationBlock)failure
{
    self.successBlock = success;
    self.failureBlock = failure;
    
    NSError* error = nil;
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

    BZRNetworkOperation* operation = [[BZRNetworkOperation alloc] initWithNetworkRequest:networkRequest networkManager:manager error:&error];
    
    WEAK_SELF;
    if (error && failure) {
        failure(operation ,error, NO);
    } else {
        [self enqueueOperation:operation success:^(BZRNetworkOperation *operation) {
            
            if (success) {
                success(operation);
            }
            [weakSelf finishOperationInQueue:operation];
            
        } failure:^(BZRNetworkOperation *operation, NSError *error, BOOL isCanceled) {
            
            if (failure) {
                failure(operation, error, isCanceled);
            }
            [weakSelf finishOperationInQueue:operation];
            
//            if ([BZRErrorHandler errorIsNetworkError:error] && operation.networkRequest.retryIfConnectionFailed) {
//                [weakSelf addOperationToFailedQueue:operation];
//            }
        }];
    }
    
    return operation;
}

- (void)enqueueOperation:(BZRNetworkOperation*)operation success:(SuccessOperationBlock)success failure:(FailureOperationBlock)failure {
    
    [operation setCompletionBlockAfterProcessingWithSuccess:success failure:failure];
    WEAK_SELF;
    //check reachability
    [BZRReachabilityHelper checkConnectionOnSuccess:^{
        [weakSelf addOperationToQueue:operation];
    } failure:^(NSError *error) {
        
        if (failure) {
            failure(operation, error, NO);
        }
//        [weakSelf addOperationToFailedQueue:operation];
    }];
}

- (void)cancelAllOperations
{
    if ([NSURLSession class]) {
        [self.sessionManager.operationQueue cancelAllOperations];
    }
}

- (void)finishOperationInQueue:(BZRNetworkOperation*)operation
{
    [self.operationsQueue removeObject:operation];
}

- (void)addOperationToQueue:(BZRNetworkOperation*)operation
{
    [self.operationsQueue addObject:operation];
    [operation start];
}

- (void)addOperationToFailedQueue:(BZRNetworkOperation *)operation
{
    [self.failedOperationsQueue addObject:operation];
    [operation pause];
}

@end
