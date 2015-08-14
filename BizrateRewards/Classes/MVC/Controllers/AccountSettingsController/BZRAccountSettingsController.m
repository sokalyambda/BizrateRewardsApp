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

#import "BZRAssetsHelper.h"

#import "BZRProjectFacade.h"

#import "BZRRoundedImageView.h"

static NSString *const kAccountSettingsContainerSegueIdentifier = @"accountSettingsContainerSegue";

@interface BZRAccountSettingsController ()<UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (weak, nonatomic) BZRAccountSettingsContaiterController *container;

@property (weak, nonatomic) IBOutlet BZRRoundedImageView *userIcon;
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
    /* This should be uncommented only if we DON'T use the FBSDKProfilePictureView
     [self setupChangePhotoActionSheet];
     */
}

/**
 *  Show sign out action sheet
 */
- (void)showSignOutActionSheet
{
    UIAlertController *signOutController = [UIAlertController alertControllerWithTitle:@"" message:LOCALIZED(@"Do you want to sign out?") preferredStyle:UIAlertControllerStyleActionSheet];
 
    WEAK_SELF;
    UIAlertAction *signOutAction = [UIAlertAction actionWithTitle:LOCALIZED(@"Sign Out") style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
        [weakSelf signOut];
    }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:LOCALIZED(@"Cancel") style:UIAlertActionStyleCancel handler:nil];
    
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

/**
 *  Update fields relative to current user data
 */
- (void)updateUserData
{
    [self setupUserAvatar];
    
    self.userFullNameLabel.text = self.currentProfile.fullName;
}

/**
 *  Setup current user avatar, using FBSDKProfilePictureView
 */
- (void)setupUserAvatar
{
    [self.userIcon setNeedsImageUpdate];
}

#pragma mark - Change photo actions

/**
 *  Choose new photo and set it as user avatar image. (To make it work we have to change parent class of BZRRoundedImageView from FBSDKProfilePictureView to UIImageView).
 */
- (void)setupChangePhotoActionSheet
{
    WEAK_SELF;
    UIAlertController *changePhotoActionSheet = [UIAlertController alertControllerWithTitle:@"" message:NSLocalizedString(@"Change your photo", nil) preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *cameraAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"Take photo", nil) style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
        [weakSelf takeNewPhotoFromCamera];
    }];
    
    UIAlertAction *galleryAction = [UIAlertAction actionWithTitle:LOCALIZED(@"Select from gallery") style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
        [weakSelf choosePhotoFromExistingImages];
    }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:LOCALIZED(@"Cancel") style:UIAlertActionStyleCancel handler:nil];
    
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
        ShowAlert(LOCALIZED(@"Camera is not available"));
        return;
    } else {
        [self showImagePickerWithType:UIImagePickerControllerSourceTypeCamera];
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
            }];
        } else {
            self.currentProfile.avatarURL = imagePath;
            [picker dismissViewControllerAnimated:YES completion:nil];
        }
    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:kAccountSettingsContainerSegueIdentifier]) {
        self.container = (BZRAccountSettingsContaiterController *)segue.destinationViewController;
        [self.container viewWillAppear:YES];
    }
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
