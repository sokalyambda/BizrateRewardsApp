//
//  BZRBaseViewController.m
//  BizrateRewards
//
//  Created by Eugenity on 15.07.15.
//  Copyright (c) 2015 Connexity. All rights reserved.
//

#import "BZRBaseViewController.h"
#import "BZRBaseNavigationController.h"

#import "AppDelegate.h"

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
    [self setNeedsStatusBarAppearanceUpdate];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self setupStatusBarAppearance];
    
    self.navigationItem.leftBarButtonItem = self.baseNavigationController.customBackButton;
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

#pragma mark - Actions

- (void)setupStatusBarAppearance
{
    UIWindow *mainWindow = ((AppDelegate *)[UIApplication
                                         sharedApplication].delegate).window;
    NSInteger statusBarHeight = CGRectGetHeight([UIApplication sharedApplication].statusBarFrame);

    UIView *statusBarView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(mainWindow.frame), statusBarHeight)];
    statusBarView.backgroundColor = [UIColor blackColor];
    [mainWindow addSubview:statusBarView];
}

@end
