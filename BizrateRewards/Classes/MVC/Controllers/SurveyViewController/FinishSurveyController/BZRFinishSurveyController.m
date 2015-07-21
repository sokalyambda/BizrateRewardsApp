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

#import "BZRSurvey.h"

@interface BZRFinishSurveyController ()

@property (weak, nonatomic) IBOutlet BZRTutorialDescriptionLabel *obtainedPointsLabel;

@property (strong, nonatomic) NSString *obtainedPointsText;

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

#pragma mark - View Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [self setupObtainedPointsText];
}

#pragma mark - Actions

- (IBAction)homeClick:(id)sender
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

- (void)setupObtainedPointsText
{
    self.obtainedPointsLabel.text = [NSString stringWithFormat:@"%li %@", (long)self.passedSurvey.surveyPoints, self.obtainedPointsText];
}

@end
