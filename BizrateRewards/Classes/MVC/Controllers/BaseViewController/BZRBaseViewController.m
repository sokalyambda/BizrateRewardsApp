//
//  BZRBaseViewController.m
//  BizrateRewards
//
//  Created by Eugenity on 15.07.15.
//  Copyright (c) 2015 Connexity. All rights reserved.
//

#import "BZRBaseViewController.h"
#import "BZRBaseNavigationController.h"

#import "BZRRedirectionHelper.h"

#import "NSError+HTTPResponseStatusCode.h"

static NSInteger const kNotAuthorizedStatusCode = 401.f;

@interface BZRBaseViewController ()

@property (weak, nonatomic) BZRBaseNavigationController *baseNavigationController;

@end

@implementation BZRBaseViewController

#pragma mark - Accessors

- (BZRBaseNavigationController *)baseNavigationController
{
    if (!_baseNavigationController && [self.navigationController isKindOfClass:[BZRBaseNavigationController class]]) {
        _baseNavigationController = (BZRBaseNavigationController *)self.navigationController;
    }
    return _baseNavigationController;
}

#pragma mark - View Lifecycle

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self customizeNavigationItem];
    
    _redirectionBlock = ^(NSError *error) {
        
        NSInteger statusCode = error.HTTPResponseStatusCode;
        
        if (statusCode == kNotAuthorizedStatusCode) {
            [BZRRedirectionHelper performSignOut];
        } else {
            [BZRRedirectionHelper redirectToDashboardController];
        }
        
    };
}

/**
 *  Setup the base status bar style
 *
 *  @return UIStatusBarStyleLightContent
 */
- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

#pragma mark - Actions

- (void)customizeNavigationItem
{
    self.navigationItem.leftBarButtonItem = self.baseNavigationController.customBackButton;
}

@end
