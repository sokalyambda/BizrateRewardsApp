//
//  BZRDashboardController.m
//  BizrateRewards
//
//  Created by Eugenity on 23.06.15.
//  Copyright (c) 2015 Connexity. All rights reserved.
//

#import "BZRStorageManager.h"
#import "BZRDataManager.h"

#import "BZRDashboardController.h"
#import "BZRSurveyViewController.h"
#import "BZRAccountSettingsController.h"
#import "BZRBaseNavigationController.h"
#import "BZRGiftCardsListController.h"

#import "BZRRoundedImageView.h"
#import "BZRProgressView.h"

static NSString *const kAccountSettingsSegueIdentifier = @"accountSettingsSegueIdentifier";
static NSString *const kAllGiftCardsSegueIdentifier = @"allGiftCardsSegue";

@interface BZRDashboardController ()

@property (weak, nonatomic) IBOutlet BZRProgressView *progressView;
@property (weak, nonatomic) IBOutlet BZRRoundedImageView *userAvatar;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *earnedPointsLabel;

@property (strong, nonatomic) BZRStorageManager *storageManager;
@property (strong, nonatomic) BZRDataManager *dataManager;

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

- (BZRDataManager *)dataManager
{
    if (!_dataManager) {
        _dataManager = [BZRDataManager sharedInstance];
    }
    return _dataManager;
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
//    WEAK_SELF;
//    [BZRReachabilityHelper checkConnectionOnSuccess:^{
//        [MBProgressHUD showHUDAddedTo:weakSelf.view animated:YES];
//        [weakSelf.dataManager getSurveysListWithResult:^(BOOL success, NSArray *surveysList, NSError *error) {
//            [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:YES];
//            if (!success) {
//                ShowErrorAlert(error);
//            } else {
//                BZRSurveyViewController *controller = [weakSelf.storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([BZRSurveyViewController class])];
//                if (surveysList.count) {
//                    controller.currentSurvey = [surveysList firstObject];
//                    [weakSelf.navigationController pushViewController:controller animated:YES];
//                } else {
//                    ShowAlert(NSLocalizedString(@"There are no surveys for you", nil));
//                    return;
//                }
//            }
//        }];
//    } failure:^{
//        ShowAlert(InternetIsNotReachableString);
//    }];
}

- (IBAction)seeAllGiftCardsClick:(id)sender
{
    [self performSegueWithIdentifier:kAllGiftCardsSegueIdentifier sender:self];
}

- (IBAction)accountSettingsClick:(id)sender
{
    BZRAccountSettingsController *accountController = [self.storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([BZRAccountSettingsController class])];
    BZRBaseNavigationController *navigationController = [[BZRBaseNavigationController alloc] initWithRootViewController:accountController];
    [self presentViewController:navigationController animated:YES completion:nil];
}

- (void)updateUserInformation
{
//    [self.userAvatar sd_setImageWithURL:self.currentProfile.avatarURL placeholderImage:[UIImage imageNamed:@"user_icon_small"]];
#warning temporary
    if (!self.currentProfile.avatarImage) {
        self.userAvatar.image = [UIImage imageNamed:@"user_icon_small"];
    } else {
        self.userAvatar.image = self.currentProfile.avatarImage;
    }
    
    self.userNameLabel.text = self.currentProfile.fullName;
    self.earnedPointsLabel.text = [NSString stringWithFormat:@"%d", self.currentProfile.pointsAmount];
    
#warning User Points
    self.currentProfile.pointsRequired = 2000;
}

- (void)getCurrentUserProfile
{
    WEAK_SELF;
    [BZRReachabilityHelper checkConnectionOnSuccess:^{
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [weakSelf.dataManager getCurrentUserWithCompletion:^(BOOL success, NSError *error, NSInteger responseStatusCode) {
            [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:YES];
            if (success) {
                [weakSelf updateUserInformation];
                [weakSelf calculateProgress];
                weakSelf.updateNeeded = NO;
            }
        }];
    } failure:^{
        ShowAlert(InternetIsNotReachableString);
    }];
}

- (void)calculateProgress
{
     self.progressView.progress  = (CGFloat)self.currentProfile.pointsAmount * CGRectGetWidth(self.progressView.frame) / (CGFloat)self.currentProfile.pointsRequired;
    [self.progressView setNeedsDisplay];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:kAllGiftCardsSegueIdentifier]) {
        BZRGiftCardsListController *controller = (BZRGiftCardsListController *)segue.destinationViewController;
        controller.navigationItem.title = NSLocalizedString(@"Rewards", nil);
    }
}

@end
