//
//  BZRFinishSurveyController.m
//  BizrateRewards
//
//  Created by Eugenity on 07.07.15.
//  Copyright (c) 2015 Connexity. All rights reserved.
//

#import "BZRFinishSurveyController.h"
#import "BZRDashboardController.h"

#import "BZRTutorialDescriptionLabel.h"
#import "BZRProgressView.h"

#import "BZRSurvey.h"

@interface BZRFinishSurveyController ()

@property (weak, nonatomic) IBOutlet BZRTutorialDescriptionLabel *obtainedPointsLabel;
@property (weak, nonatomic) IBOutlet BZRProgressView *progressView;

@property (strong, nonatomic) BZRStorageManager *storageManager;

@property (strong, nonatomic) BZRUserProfile *currentProfile;

@end

@implementation BZRFinishSurveyController

#pragma mark - Accessors

- (BZRStorageManager *)storageManager
{
    if (!_storageManager) {
        _storageManager = [BZRStorageManager sharedStorage];
    }
    return _storageManager;
}

- (BZRUserProfile *)currentProfile
{
    _currentProfile = [BZRStorageManager sharedStorage].currentProfile;
    return _currentProfile;
}

#pragma mark - View Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    //track mixpanel event
    [BZRMixpanelService trackEventWithType:BZRMixpanelEventSurveyCompeted propertyValue:nil];
}

- (void)viewDidAppear:(BOOL)animated
{
    [self recalculateProgress];
}

#pragma mark - Actions

- (IBAction)homeClick:(id)sender
{
    [self moveToDashboardController];
}

/**
 *  Customize navigation item
 */
- (void)customizeNavigationItem
{
    [super customizeNavigationItem];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

/**
 *  When survey has been passed - move to home controller.
 */
- (void)moveToDashboardController
{
    __block BZRDashboardController *homeController;
    
    [self.navigationController.viewControllers enumerateObjectsUsingBlock:^(UIViewController *controller, NSUInteger idx, BOOL *stop) {
        if ([controller isKindOfClass:[BZRDashboardController class]]) {
            homeController = (BZRDashboardController *)controller;
            *stop = YES;
        }
    }];
    homeController.updateNeeded = YES;
    [self.navigationController popToViewController:homeController animated:YES];
}

/**
 *  Setup value of obtained points.
 */
- (void)setupObtainedPointsText
{
    self.obtainedPointsLabel.text = [NSString localizedStringWithFormat:LOCALIZED(@"%li points have deposited to your account!"), (long)self.passedSurvey.surveyPoints];
}

/**
 *  Recalculate progress in progress bar
 */
- (void)recalculateProgress
{
    NSInteger updatedPoints = self.currentProfile.pointsAmount + self.passedSurvey.surveyPoints;
    WEAK_SELF;
    [self.progressView recalculateProgressWithCurrentPoints:updatedPoints requiredPoints:self.currentProfile.pointsRequired withCompletion:^(BOOL maxPointsEarned) {
        if (maxPointsEarned) {
            weakSelf.obtainedPointsLabel.text = LOCALIZED(@"Awesome! You have earned a gift card!! We will email you with details how to choose a card and redeem your points.");
        } else {
            [weakSelf setupObtainedPointsText];
        }
    }];
}

/**
 *  Set default status bar style because the background is white
 *
 *  @return UIStatusBarStyleDefault
 */
- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleDefault;
}

@end
