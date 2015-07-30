//
//  BZRAccountSettingsController.m
//  BizrateRewards
//
//  Created by Eugenity on 27.06.15.
//  Copyright (c) 2015 Connexity. All rights reserved.
//

#import "BZRAccountSettingsController.h"
#import "BZRSignInController.h"
#import "BZRAccountSettingsContaiterController.h"
#import "BZRBaseNavigationController.h"

#import "BZRUserProfile.h"

#import "BZRStorageManager.h"
#import "BZRStatusBarManager.h"

#import "BZRAssetsHelper.h"

#import "BZRProjectFacade.h"

static NSString *const kAccountSettingsContainerSegueIdentifier = @"accountSettingsContainerSegue";

@interface BZRAccountSettingsController ()<UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (weak, nonatomic) BZRAccountSettingsContaiterController *container;

@property (weak, nonatomic) IBOutlet UIImageView *userIcon;
@property (weak, nonatomic) IBOutlet UILabel *userFullNameLabel;

@property (strong, nonatomic) BZRUserProfile *currentProfile;

@end

@implementation BZRAccountSettingsController

@synthesize currentProfile = _currentProfile;

#pragma mark - Accessors

- (BZRUserProfile *)currentProfile
{
    _currentProfile = [BZRStorageManager sharedStorage].currentProfile;
    return _currentProfile;
}

- (void)setCurrentProfile:(BZRUserProfile *)currentProfile
{
    _currentProfile = currentProfile;
    [BZRStorageManager sharedStorage].currentProfile = _currentProfile;
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
    [self updateUserData];
}

#pragma mark - Actions

- (IBAction)exitClick:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)signOutAction:(id)sender
{
    [self showSignOutActionSheet];
}

- (IBAction)changeIconClick:(id)sender
{
    [self setupChangePhotoActionSheet];
}

- (void)showSignOutActionSheet
{
    UIAlertController *signOutController = [UIAlertController alertControllerWithTitle:@"" message:NSLocalizedString(@"Do you want to sign out?", nil) preferredStyle:UIAlertControllerStyleActionSheet];
 
    WEAK_SELF;
    UIAlertAction *signOutAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"Sign Out", nil) style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
        [weakSelf signOut];
    }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"Cancel", nil) style:UIAlertActionStyleCancel handler:nil];
    
    [signOutController addAction:signOutAction];
    [signOutController addAction:cancelAction];
    
    [self presentViewController:signOutController animated:YES completion:nil];
}

/**
 *  Sign out: clean user data and move to root controller.
 */
- (void)signOut
{
    WEAK_SELF;
    [BZRProjectFacade signOutOnSuccess:^(BOOL isSuccess) {
        
        BZRBaseNavigationController *navigationController = (BZRBaseNavigationController *)weakSelf.presentingViewController;
        
        [CATransaction begin];
        [CATransaction setCompletionBlock:^{
            [weakSelf dismissViewControllerAnimated:YES completion:nil];
        }];
        [navigationController popToRootViewControllerAnimated:YES];;
        [CATransaction commit];
        
    } onFailure:^(NSError *error, BOOL isCanceled) {
        
    }];
}

- (void)updateUserData
{
    if (self.currentProfile.avatarURL) {
        WEAK_SELF;
        [BZRAssetsHelper imageFromAssetURL:self.currentProfile.avatarURL withCompletion:^(UIImage *image, NSDictionary *info) {
            weakSelf.userIcon.image = image ? image : [UIImage imageNamed:@"user_icon_large"];
        }];
    }
    
    self.userFullNameLabel.text = self.currentProfile.fullName;
}

#pragma mark - Change photo actions

- (void)setupChangePhotoActionSheet
{
    WEAK_SELF;
    UIAlertController *changePhotoActionSheet = [UIAlertController alertControllerWithTitle:@"" message:NSLocalizedString(@"Change your photo", nil) preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *cameraAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"Take photo", nil) style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
        [weakSelf takeNewPhotoFromCamera];
    }];
    
    UIAlertAction *galleryAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"Select from gallery", nil) style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
        [weakSelf choosePhotoFromExistingImages];
    }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"Cancel", nil) style:UIAlertActionStyleCancel handler:nil];
    
    [changePhotoActionSheet addAction:cameraAction];
    [changePhotoActionSheet addAction:galleryAction];
    [changePhotoActionSheet addAction:cancelAction];
    
    [self presentViewController:changePhotoActionSheet animated:YES completion:nil];
}

/**
 *  If camera source type is available - show camera.
 */
- (void)takeNewPhotoFromCamera
{
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        ShowAlert(NSLocalizedString(@"Camera is not available", nil));
        return;
    } else {
        [self showImagePickerWithType:UIImagePickerControllerSourceTypeCamera];
        [[BZRStatusBarManager sharedManager] hideCustomStatusBarView];
    }
}

/**
 *  Choose photo from photo library
 */
- (void)choosePhotoFromExistingImages
{
    [self showImagePickerWithType:UIImagePickerControllerSourceTypeSavedPhotosAlbum];
}

/**
 *  Setup UIImagePickerController
 *
 *  @param type Chosen type
 */
- (void)showImagePickerWithType:(UIImagePickerControllerSourceType)type
{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.modalPresentationStyle = UIModalPresentationCurrentContext;
    picker.delegate = self;
    picker.sourceType = type;
    picker.mediaTypes = @[(NSString*)kUTTypeImage];
    [self presentViewController:picker animated:YES completion:nil];
}

#pragma mark - UIImagePickerControllerDelegate methods

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    if (!image) {
        image = [info objectForKey:UIImagePickerControllerOriginalImage];
    }
    
    if (image) {
        //save photo to disk
        WEAK_SELF;
        NSURL *imagePath = [info objectForKey:UIImagePickerControllerReferenceURL];
        if (!imagePath) {
            [BZRAssetsHelper writeImage:image withMediaInfo:info toPhotoAlbumWithCompletion:^(NSURL *assetURL, NSError *error) {
                weakSelf.currentProfile.avatarURL = assetURL;
                [picker dismissViewControllerAnimated:YES completion:nil];
                [[BZRStatusBarManager sharedManager] showCustomStatusBarView];
            }];
        } else {
            self.currentProfile.avatarURL = imagePath;
            [picker dismissViewControllerAnimated:YES completion:nil];
            [[BZRStatusBarManager sharedManager] showCustomStatusBarView];
        }
    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
    [[BZRStatusBarManager sharedManager] showCustomStatusBarView];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:kAccountSettingsContainerSegueIdentifier]) {
        self.container = (BZRAccountSettingsContaiterController *)segue.destinationViewController;
        [self.container viewWillAppear:YES];
    }
}

@end
