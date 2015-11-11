//
//  BZRRedirectionHelperTests.m
//  Bizrate Rewards
//
//  Created by Eugenity on 28.10.15.
//  Copyright © 2015 Connexity. All rights reserved.
//

/*
 com.bizraterewards://reset_password/success?acces_token=123123123123
 
 com.bizraterewards://reset_password/fail?reason=invalid_link
 
 com.bizraterewards://reset_password/fail?reason=expired_link
 
 com.bizraterewards://reset_password/fail?reason=rejected_link
 */

#import <XCTest/XCTest.h>

#import "BZRRedirectionHelper.h"

static NSString *const kSuccessResettingURLExample = @"com.bizraterewards://reset_password/success?acces_token=123123123123";
static NSString *const kFailureResettingURLExample = @"com.bizraterewards://reset_password/fail?reason=invalid_link";

static NSString *const kFailureResettingURLExampleWithWrongPathComponents = @"com.bizraterewards";

@interface BZRRedirectionHelperTests : XCTestCase

@end

@implementation BZRRedirectionHelperTests

- (void)setUp
{
    [super setUp];
}

- (void)tearDown
{
    [super tearDown];
}

- (void)test_IsEmptyURL
{
    NSURL *testURL = [NSURL URLWithString:@""];
    NSError *error;
    [BZRRedirectionHelper redirectWithURL:testURL withError:&error];
    XCTAssertNotNil(error);
    NSLog(@"error : %@", error);
}

- (void)test_IsNullURL
{
    NSURL *testURL = nil;
    NSError *error;
    [BZRRedirectionHelper redirectWithURL:testURL withError:&error];
    XCTAssertNotNil(error);
    NSLog(@"error : %@", error);
}

- (void)test_IsIncorrectPathComponents
{
    NSURL *testURL = [NSURL URLWithString:kFailureResettingURLExampleWithWrongPathComponents];
    NSError *error;
    [BZRRedirectionHelper redirectWithURL:testURL withError:&error];
    XCTAssertNotNil(error);
    NSLog(@"error : %@", error);
}

- (void)testPerformanceExample
{
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
