//
//  BZRAccountSettingsController.m
//  BizrateRewards
//
//  Created by Eugenity on 27.06.15.
//  Copyright (c) 2015 ThinkMobiles. All rights reserved.
//

#import <AssetsLibrary/AssetsLibrary.h>

#import "BZRAccountSettingsController.h"
#import "BZRSignInController.h"
#import "BZRDashboardController.h"
#import "BZRAccountSettingsContaiterController.h"

static NSString *const kAccountSettingsContainerSegueIdentifier = @"accountSettingsContainerSegue";

@interface BZRAccountSettingsController ()<UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (weak, nonatomic) BZRAccountSettingsContaiterController *container;

@property (weak, nonatomic) IBOutlet UIImageView *userIcon;
@property (weak, nonatomic) IBOutlet UILabel *userFullNameLabel;

@end

@implementation BZRAccountSettingsController

#pragma mark - View Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

#pragma mark - Actions

- (IBAction)exitClick:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)signOutAction:(id)sender
{
    BZRDashboardController *dashboard = (BZRDashboardController *)[self.navigationController.presentingViewController.childViewControllers lastObject];
    [self dismissViewControllerAnimated:YES completion:nil];
    [dashboard.navigationController popViewControllerAnimated:NO];
}

- (IBAction)changeIconClick:(id)sender
{
    [self setupChangePhotoActionSheet];
}

#pragma mark - Change photo actions

- (void)setupChangePhotoActionSheet
{
    WEAK_SELF;
    UIAlertController *changePhotoActionSheet = [UIAlertController alertControllerWithTitle:@"" message:NSLocalizedString(@"Change your photo", nil) preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *cameraAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"Take photo", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [weakSelf takeNewPhotoFromCamera];
    }];
    
    UIAlertAction *galleryAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"Select from gallery", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [weakSelf choosePhotoFromExistingImages];
    }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"Cancel", nil) style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
        
    }];
    
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
    }
    
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    picker.mediaTypes = @[(NSString*)kUTTypeImage];
    picker.modalPresentationStyle = UIModalPresentationFullScreen;
    
    [self presentViewController:picker animated:YES completion:nil];
}

- (void)choosePhotoFromExistingImages
{
    UIImagePickerController * picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
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
    }
    //TODO: send photo
    [picker dismissViewControllerAnimated:YES completion:nil];

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
