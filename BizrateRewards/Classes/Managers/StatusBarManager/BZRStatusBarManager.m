//
//  BZRStatusBarHandler.m
//  BizrateRewards
//
//  Created by Eugenity on 19.07.15.
//  Copyright (c) 2015 Connexity. All rights reserved.
//

#import "BZRStatusBarManager.h"

static CGFloat const kHideAnimationDuration = 1.f;
static CGFloat const kShowAnimationDuration = .5f;

@interface BZRStatusBarManager ()

@property (strong, nonatomic) UIView *statusBarView;
@property (strong, nonatomic) UIWindow *mainWindow;

@end

@implementation BZRStatusBarManager

#pragma mark - Lifecycle

/**
 *  Singleton object of status bar manager
 *
 *  @return Status bar manager singleton object
 */
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

/**
 *  Create custom status bar view if it hasn't existed already
 *
 *  @return Custom status bar view
 */
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

/**
 *  Add custom status bar view to main window once.
 */
- (void)addCustomStatusBarView
{
    if (![self.mainWindow.subviews containsObject:self.statusBarView]) {
        [self.mainWindow addSubview:self.statusBarView];
    }
}

/**
 *  Hide custom status bar view
 */
- (void)hideCustomStatusBarView
{
    [UIView animateWithDuration:kHideAnimationDuration animations:^{
        self.statusBarView.alpha = 0.f;
    }];
}

/**
 *  Show custom status bar view
 */
- (void)showCustomStatusBarView
{
    [UIView animateWithDuration:kShowAnimationDuration animations:^{
        self.statusBarView.alpha = 1.f;
    }];
}

@end
