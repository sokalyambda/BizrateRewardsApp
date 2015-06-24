//
//  BZRDataManager.m
//  CarusselSalesTool
//
//  Created by AnatoliyDalekorey on 29.05.15.
//  Copyright (c) 2015 ThinkMobiles. All rights reserved.
//

#import "BZRDataManager.h"

@interface BZRDataManager ()

@property (strong, nonatomic) BZRNetworkManager *network;

@end

@implementation BZRDataManager

#pragma mark - Lifecycle

+ (BZRDataManager *)sharedInstance
{
    static BZRDataManager *singletonObject = nil;

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        singletonObject = [[self alloc] init];
        
    });
    return singletonObject;
}

- (instancetype)init
{
    self = [super init];
    
    if (self) {
        _network = [BZRNetworkManager new];
    }
    return self;
}

#pragma mark - Requests

- (void)signInWithUserName:(NSString *)userName password:(NSString *)password withResult:(SuccessBlock)result
{
    [self.network signInWithUserName:userName password:password withResult:^(BOOL success, BZRUserProfile *userProfile, NSError *error) {
        _userProfile = userProfile;
        return result(success, error);
    }];
}

@end
