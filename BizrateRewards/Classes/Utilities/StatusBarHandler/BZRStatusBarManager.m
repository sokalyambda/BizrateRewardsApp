//
//  BZRStatusBarHandler.m
//  BizrateRewards
//
//  Created by Eugenity on 19.07.15.
//  Copyright (c) 2015 Connexity. All rights reserved.
//

#import "BZRStatusBarManager.h"

@interface BZRStatusBarManager ()

@property (strong, nonatomic) UIView *statusBarView;
@property (strong, nonatomic) UIWindow *mainWindow;

@end

@implementation BZRStatusBarManager

#pragma mark - Lifecycle

+ (BZRStatusBarManager *)sharedManager
{
    static BZRStatusBarManager *statusBarManager = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        statusBarManager = [[BZRStatusBarManager alloc] init];
    });
    return statusBarManager;
}

#pragma mark - Accessors

- (UIWindow *)mainWindow
{
    if (!_mainWindow) {
        _mainWindow = [UIApplication sharedApplication].keyWindow;
    }
    return _mainWindow;
}

- (UIView *)statusBarView
{
    if (!_statusBarView) {
        NSInteger statusBarHeight = CGRectGetHeight([UIApplication sharedApplication].statusBarFrame);
        _statusBarView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.mainWindow.frame), statusBarHeight)];
        _statusBarView.backgroundColor = [UIColor blackColor];
    }
    
    return _statusBarView;
}

#pragma mark - Actions

- (void)addCustomStatusBarView
{
    if (![self.mainWindow.subviews containsObject:self.statusBarView]) {
        [self.mainWindow addSubview:self.statusBarView];
    }
}

- (void)hideCustomStatusBarView
{
    [UIView animateWithDuration:0.3f animations:^{
        [self.statusBarView setHidden:YES];
    }];
}

- (void)showCustomStatusBarView
{
    [UIView animateWithDuration:0.3f animations:^{
        [self.statusBarView setHidden:NO];
    }];
}

@end
