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

@property (strong, nonatomic) NSString *obtainedPointsText;
@property (strong, nonatomic) BZRUserProfile *currentProfile;

@end

@implementation BZRFinishSurveyController

#pragma mark - Accessors

- (NSString *)obtainedPointsText
{
    if (!_obtainedPointsText) {
        _obtainedPointsText = NSLocalizedString(@"points have deposited to your account!", nil);
    }
    return _obtainedPointsText;
}

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

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [self setupObtainedPointsText];
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
    self.obtainedPointsLabel.text = [NSString stringWithFormat:@"%li %@", (long)self.passedSurvey.surveyPoints, self.obtainedPointsText];
}

- (void)recalculateProgress
{
    NSInteger updatedPoints = self.currentProfile.pointsAmount + self.passedSurvey.surveyPoints;
    [self.progressView recalculateProgressWithCurrentPoints:updatedPoints requiredPoints: self.currentProfile.pointsRequired];
}

@end
