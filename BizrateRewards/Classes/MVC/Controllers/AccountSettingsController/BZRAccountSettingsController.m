//
//  BZRAccountSettingsController.m
//  BizrateRewards
//
//  Created by Eugenity on 27.06.15.
//  Copyright (c) 2015 Connexity. All rights reserved.
//

#import <AssetsLibrary/AssetsLibrary.h>

#import "BZRAccountSettingsController.h"
#import "BZRSignInController.h"
#import "BZRDashboardController.h"
#import "BZRAccountSettingsContaiterController.h"

#import "BZRUserProfile.h"
#import "BZRStorageManager.h"

static NSString *const kAccountSettingsContainerSegueIdentifier = @"accountSettingsContainerSegue";

@interface BZRAccountSettingsController ()<UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (weak, nonatomic) BZRAccountSettingsContaiterController *container;

@property (weak, nonatomic) IBOutlet UIImageView *userIcon;
@property (weak, nonatomic) IBOutlet UILabel *userFullNameLabel;

@property (strong, nonatomic) BZRUserProfile *currentProfile;

@end

@implementation BZRAccountSettingsController

#pragma mark - Accessors

- (BZRUserProfile *)currentProfile
{
#warning temporary!
    if (!_currentProfile) {
//        _currentProfile = [BZRStorageManager sharedStorage].currentProfile;
        _currentProfile = [[BZRUserProfile alloc] init];
    }
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
        BZRDashboardController *dashboard = (BZRDashboardController *)[weakSelf.navigationController.presentingViewController.childViewControllers lastObject];
        [weakSelf dismissViewControllerAnimated:YES completion:nil];
        [dashboard.navigationController popViewControllerAnimated:NO];
    }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"Cancel", nil) style:UIAlertActionStyleCancel handler:nil];
    
    [signOutController addAction:signOutAction];
    [signOutController addAction:cancelAction];
    
    [self presentViewController:signOutController animated:YES completion:nil];
}

- (void)updateUserData
{
    self.userFullNameLabel.text = self.currentProfile.fullName;
#warning temporary!
    self.userIcon.image = self.currentProfile.avatarImage;
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

- (void)takeNewPhotoFromCamera
{
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        ShowAlert(NSLocalizedString(@"Camera is not available", nil));
        return;
    } else {
        [self showImagePickerWithType:UIImagePickerControllerSourceTypeCamera];
    }
}

- (void)choosePhotoFromExistingImages
{
    [self showImagePickerWithType:UIImagePickerControllerSourceTypePhotoLibrary];
}

- (void)showImagePickerWithType:(UIImagePickerControllerSourceType)type
{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.modalPresentationStyle = UIModalPresentationCurrentContext;
    picker.delegate = self;
    picker.sourceType = type;
    picker.mediaTypes = @[(NSString*)kUTTypeImage];
    [self presentViewController:picker animated:YES completion:NULL];
}

#pragma mark - UIImagePickerControllerDelegate methods

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    if (!image) {
        image = [info objectForKey:UIImagePickerControllerOriginalImage];
    }
    
    if (image) {
        CGRect thumbRect = self.userIcon.bounds;
        
        // adjust to aspect fit
        CGFloat k = image.size.width/image.size.height;
        if (k > 1.f) {
            thumbRect.size.height = ceilf(thumbRect.size.width/k);
        } else if (k < 1.f) {
            thumbRect.size.width = ceilf(thumbRect.size.height*k);
        }
        
        UIGraphicsBeginImageContextWithOptions(thumbRect.size, YES, 0);
        [image drawInRect:thumbRect];
        UIImage *thumbImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        self.userIcon.image = thumbImage;
        self.currentProfile.avatarImage = thumbImage;
    }

    [picker dismissViewControllerAnimated:YES completion:nil];
    //TODO: send photo
    
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

@end
