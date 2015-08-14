//
//  BZRDashboardController.m
//  BizrateRewards
//
//  Created by Eugenity on 23.06.15.
//  Copyright (c) 2015 Connexity. All rights reserved.
//

#import "BZRAssetsHelper.h"
#import "BZRCommonNumberFormatter.h"

#import "BZRDashboardController.h"
#import "BZRSurveyViewController.h"
#import "BZRAccountSettingsController.h"
#import "BZRBaseNavigationController.h"
#import "BZRGiftCardsListController.h"

#import "BZRRoundedImageView.h"
#import "BZRProgressView.h"
#import "BZRSurveyPointsValueLabel.h"
#import "BZRTutorialDescriptionLabel.h"
#import "BZRHighlightedButton.h"

#import "BZRPushNotifiactionService.h"
#import "BZRSurveyService.h"
#import "BZRProjectFacade.h"

static NSString *const kAccountSettingsSegueIdentifier = @"accountSettingsSegueIdentifier";
static NSString *const kAllGiftCardsSegueIdentifier = @"allGiftCardsSegue";

@interface BZRDashboardController ()

@property (weak, nonatomic) IBOutlet BZRProgressView *progressView;
@property (weak, nonatomic) IBOutlet BZRRoundedImageView *userAvatar;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *earnedPointsLabel;
@property (weak, nonatomic) IBOutlet BZRSurveyPointsValueLabel *pointsForNextGiftCardLabel;
@property (weak, nonatomic) IBOutlet BZRTutorialDescriptionLabel *pointsForNextSurveyLabel;
@property (weak, nonatomic) IBOutlet BZRHighlightedButton *takeSurveyButton;

@property (strong, nonatomic) BZRStorageManager *storageManager;
@property (strong, nonatomic) BZRUserProfile *currentProfile;

@end

@implementation BZRDashboardController

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
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.view layoutIfNeeded];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    
    [self updateUserInformation];
    if (self.isUpdateNeeded) {
        [self getCurrentUserProfile];
    }
}

#pragma mark - Actions

- (IBAction)takeSurveyClick:(id)sender
{
    [self takeSurvey];
}

- (IBAction)seeAllGiftCardsClick:(id)sender
{
    WEAK_SELF;
    [MBProgressHUD showHUDAddedTo:weakSelf.view animated:YES];
    [BZRProjectFacade getFeaturedGiftCardsOnSuccess:^(NSArray *giftCards) {
        [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:YES];

        if (giftCards.count) {
            BZRGiftCardsListController *controller = [weakSelf.storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([BZRGiftCardsListController class])];
            controller.navigationItem.title = NSLocalizedString(@"Rewards", nil);
            controller.giftCards = giftCards;
            [weakSelf.navigationController pushViewController:controller animated:YES];
        } else {
            ShowAlert(NSLocalizedString(@"There are no gift cards at current time", nil));
            return;
        }
        
    } onFailure:^(NSError *error, BOOL isCanceled) {
        [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:YES];
    }];
//    BZRGiftCardsListController *controller = [self.storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([BZRGiftCardsListController class])];
//    controller.navigationItem.title = NSLocalizedString(@"Rewards", nil);
//    [self.navigationController pushViewController:controller animated:YES];
}

- (IBAction)accountSettingsClick:(id)sender
{
    BZRAccountSettingsController *accountController = [self.storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([BZRAccountSettingsController class])];
    BZRBaseNavigationController *navigationController = [[BZRBaseNavigationController alloc] initWithRootViewController:accountController];
    [self presentViewController:navigationController animated:YES completion:nil];
}

/**
 *  Getting surveys data from server, pick first survey and showing it to user.
 */
- (void)takeSurvey
{
    WEAK_SELF;
    [MBProgressHUD showHUDAddedTo:weakSelf.view animated:YES];
    [BZRSurveyService getEligibleSurveysOnSuccess:^(NSArray *eligibleSurveys) {
        
        [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:YES];
        
        BZRSurveyViewController *controller = [weakSelf.storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([BZRSurveyViewController class])];
        
        if (eligibleSurveys.count) {
            controller.currentSurvey = [eligibleSurveys firstObject];
            [weakSelf.navigationController pushViewController:controller animated:YES];
        } else {
            ShowAlert(LOCALIZED(@"There are no surveys for you"));
            return;
        }
    } onFailure:^(NSError *error, BOOL isCanceled) {
        [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:YES];
    }];
}

/**
 *  Update fields values relative to current user profile data
 */
- (void)updateUserInformation
{
    [self setupUserAvatar];
    
    self.userNameLabel.text = self.currentProfile.fullName;
    
    self.earnedPointsLabel.text = [NSString stringWithFormat:@"%@ %@", [[BZRCommonNumberFormatter commonNumberFormatter] stringFromNumber:@((long)self.currentProfile.pointsAmount)], LOCALIZED(@"pts")];
    self.pointsForNextGiftCardLabel.text = [NSString stringWithFormat:@"%@ %@", [[BZRCommonNumberFormatter commonNumberFormatter] stringFromNumber:@((long)self.currentProfile.pointsRequired)], LOCALIZED(@"pts")];
    
    [self updateProgressView];
}

/**
 *  Setup current user avatar, using FBSDKProfilePictureView
 */
- (void)setupUserAvatar
{
    [self.userAvatar setNeedsImageUpdate];
 /*
    NSURL *avatarURL = [BZRStorageManager sharedStorage].facebookProfile.avararURL;
    if (!avatarURL && self.currentProfile.avatarURL) {
        WEAK_SELF;
        [BZRAssetsHelper imageFromAssetURL:self.currentProfile.avatarURL withCompletion:^(UIImage *image, NSDictionary *info) {
            weakSelf.userAvatar.image = image ? image : [UIImage imageNamed:@"user_icon_small"];
        }];
    } else if (avatarURL) {
        [self.userAvatar sd_setImageWithURL:avatarURL placeholderImage:[UIImage imageNamed:@"user_icon_small"] options:SDWebImageRefreshCached];
    }
*/
}

/**
 *  Get current user profile data from server
 */
- (void)getCurrentUserProfile
{
    WEAK_SELF;
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [BZRProjectFacade getCurrentUserOnSuccess:^(BOOL isSuccess) {
        
        [BZRSurveyService getPointsForNextSurveyOnSuccess:^(NSInteger pointsForNextSurvey) {
            
            [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:YES];
            
            if (!pointsForNextSurvey) {
                weakSelf.pointsForNextSurveyLabel.text = LOCALIZED(@"Impressive! You have completed all surveys we have currently available for you!");
                weakSelf.takeSurveyButton.enabled = NO;
            } else {
                [weakSelf setupPointsForNextSurveyTextWithPoints:pointsForNextSurvey];
                weakSelf.takeSurveyButton.enabled = YES;
            }
            
            [weakSelf updateUserInformation];
            //Register app for push notifications, if success - send device data to server
            [BZRPushNotifiactionService registerApplicationForPushNotifications:[UIApplication sharedApplication]];
            
            weakSelf.updateNeeded = NO;
            
        } onFailure:^(NSError *error, BOOL isCanceled) {
            [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:YES];
        }];
        
    } onFailure:^(NSError *error, BOOL isCanceled) {
        [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:YES];
    }];
}

/**
 *  Update progress view
 */
- (void)updateProgressView
{
    [self.progressView recalculateProgressWithCurrentPoints:self.currentProfile.pointsAmount requiredPoints:self.currentProfile.pointsRequired withCompletion:nil];
}

/**
 *  Setup points for next survey
 *
 *  @param points Points than should be set
 */
- (void)setupPointsForNextSurveyTextWithPoints:(NSInteger)points
{
    self.pointsForNextSurveyLabel.text = [NSString localizedStringWithFormat:LOCALIZED(@"Earn %li points for the next survey"), points];
}

#pragma mark - UIStatusBar appearance

/**
 *  Either navigation bar exists or no, status bar should be light content here
 *
 *  @return UIStatusBarStyleLightContent
 */
- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

@end
