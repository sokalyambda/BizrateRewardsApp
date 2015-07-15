//
//  BZRBaseViewController.m
//  BizrateRewards
//
//  Created by Eugenity on 15.07.15.
//  Copyright (c) 2015 Connexity. All rights reserved.
//

#import "BZRBaseViewController.h"
#import "BZRBaseNavigationController.h"

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

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationItem.leftBarButtonItem = self.baseNavigationController.customBackButton;
}


@end
