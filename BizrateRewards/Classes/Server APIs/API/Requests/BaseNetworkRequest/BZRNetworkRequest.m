//
//  SENetworkRequest.m
//  WorkWithServerAPI
//
//  Created by EugeneS on 30.01.15.
//  Copyright (c) 2015 Connexity. All rights reserved.
//

/*
 All request have general structure:
 
*/

#import "BZRNetworkRequest.h"

#import "BZRStorageManager.h"

@implementation BZRNetworkRequest

#pragma mark - Lifecycle

- (id)init
{
    if (self = [super init]) {
        _path = @"";
        if (!_parameters) {
            _parameters = [NSMutableDictionary dictionary];
        }
        if(!_customHeaders) {
            _customHeaders = [NSMutableDictionary dictionary];
        }
        if(!_files) {
            _files = [NSMutableArray array];
        }
    }
    return self;
}

-(void)dealloc
{
    _error = nil;
}

#pragma mark - Methods

- (BOOL)setParametersWithParamsData:(NSDictionary*)data
{
    if (!_action) {
        return NO;
    }
    _parameters = [NSMutableDictionary dictionaryWithDictionary:data];
    _path = _action;
    
    return YES;
}

- (BOOL)parseResponseSucessfully:(id)responseObject
{
    BOOL parseJSONData = NO;
    
    if (!responseObject) {
        LOG_NETWORK(@"Error:Response Is Empty");
        _error = [NSError errorWithDomain:[NSString stringWithFormat:@"%@ - response is empty", NSStringFromClass([self class])]
                                     code:1
                                 userInfo:@{NSLocalizedDescriptionKey: @"response empty"}];
        return parseJSONData;
    }
    
    NSError *error = nil;
    NSDictionary *json;
    
    if ([responseObject isKindOfClass:[NSData class]]) {
        json = [NSJSONSerialization
                JSONObjectWithData:responseObject
                options:kNilOptions
                error:&error];
    } else if ([responseObject isKindOfClass:[NSDictionary class]] || [responseObject isKindOfClass:[NSArray class]]) {
        json = responseObject;
    }
    
    NSLog(@"%@",json);
    
    if (error) {
        _error = error;
    } else {
        if ([json isKindOfClass:[NSDictionary class]] || [json isKindOfClass:[NSArray class]]) {
            
            @try {
                NSError* error = nil;
                parseJSONData = [self parseJSONDataSucessfully:json error:&error];
                
                if (!_error) {
                    _error = error;
                }
                
                //[self createErrorWithResponseObject:json];
            }
            @catch (NSException *exception) {
                _error = [NSError errorWithDomain:@""
                                             code:3
                                         userInfo:@{NSLocalizedDescriptionKey: [NSString stringWithFormat:@"name:%@\nreason:%@", exception.name, exception.reason]}];
            }
            @finally {
                
            }
        }
    }
    
    return parseJSONData;
}

- (BOOL)parseJSONDataSucessfully:(id)responseObject error:(NSError* __autoreleasing  *)error
{
    return YES;
}

- (BOOL)prepareAndCheckRequestParameters
{
    return YES;
}

@end