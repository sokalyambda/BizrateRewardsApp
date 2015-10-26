//
//  BZRProfileSettingsController.m
//  BizrateRewards
//
//  Created by Eugenity on 27.06.15.
//  Copyright (c) 2015 Connexity. All rights reserved.
//

#import "BZREditProfileController.h"
#import "BZREditProfileContainerController.h"

#import "BZRCommonDateFormatter.h"
#import "BZRSerialViewConstructor.h"

#import "BZRProjectFacade.h"

#import "BZREditProfileField.h"

#import "BZRProfileChangesObserver.h"

static NSString *const kEditProfileContainerSegueIdentifier = @"editProfileContainerSegue";

@interface BZREditProfileController ()

@property (weak, nonatomic) BZREditProfileContainerController *container;

@property (strong, nonatomic) BZRUserProfile *currentProfile;

@property (strong, nonatomic) BZRProfileChangesObserver *profileChangesObserver;

@property (assign, nonatomic, getter=isProfileChanged) BOOL profileChanged;

@property (strong, nonatomic) UIBarButtonItem *doneButton;

@end

@implementation BZREditProfileController

#pragma mark - Accessors

- (BZRProfileChangesObserver *)profileChangesObserver
{
    if (!_profileChangesObserver) {
        _profileChangesObserver = [[BZRProfileChangesObserver alloc] initWithFirstNameField:self.container.firstNameField
                                                                           andLastNameField:self.container.lastNameField
                                                                              andEmailField:self.container.emailField
                                                                             andGenderField:self.container.genderField
                                                                        andDateOfBirthField:self.container.dateOfBirthField];
    }
    return _profileChangesObserver;
}

- (BZRUserProfile *)currentProfile
{
    _currentProfile = [BZRStorageManager sharedStorage].currentProfile;
    return _currentProfile;
}

- (void)setProfileChanged:(BOOL)profileChanged
{
    _profileChanged = profileChanged;
    
    self.navigationItem.rightBarButtonItem.enabled = _profileChanged;
    /*
    [((UIButton *)self.doneButton.customView) setTitle:_profileChanged ? LOCALIZED(@"Save") : LOCALIZED(@"Close") forState:UIControlStateNormal];
     */
}

#pragma mark - View Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupFieldsValueFromProfile];
    [self observeProfileChanges];
}

#pragma mark - Actions

/**
 *  Let profile changes observer starts to observe whether profile has changes
 */
- (void)observeProfileChanges
{
    WEAK_SELF;
    [self.profileChangesObserver observeProfileChangesWithBlock:^(BOOL isChanged) {
        weakSelf.profileChanged = isChanged;
    }];
}

- (void)doneClick:(id)sender
{
    [self updateUser];
}

/**
 *  Method that customize the navigation item
 */
- (void)customizeNavigationItem
{
    [super customizeNavigationItem];
    //set navigation title
    self.navigationItem.title = LOCALIZED(@"Profile");
    
    //Show navigation bar
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
    //create custom 'Done' button
    self.doneButton = [BZRSerialViewConstructor customButtonWithTitle:LOCALIZED(@"Save") forController:self withAction:@selector(doneClick:)];
    self.doneButton.enabled = NO;

    //set right bar button item
    self.navigationItem.rightBarButtonItem = self.doneButton;
    
    /*
    //remove back button (custom and system)
    self.navigationItem.leftBarButtonItem = nil;
    self.navigationItem.hidesBackButton = YES;
     */
}

/**
 *  If profile data has been changed - update current profile by sending new data to server.
 */
- (void)updateUser
{
    WEAK_SELF;
    if (self.isProfileChanged) {
        [BZRValidator validateFirstNameField:self.container.firstNameField
                               lastNameField:self.container.lastNameField
                                  emailField:self.container.emailField
                            dateOfBirthField:self.container.dateOfBirthField
                                 genderField:self.container.genderField
                               andCheckboxes:nil onSuccess:^{
                                   
                                   [MBProgressHUD showHUDAddedTo:weakSelf.view animated:YES];
                                   [BZRProjectFacade updateUserWithFirstName:weakSelf.container.firstNameField.text andLastName:weakSelf.container.lastNameField.text andDateOfBirth:weakSelf.container.dateOfBirthField.text andGender:[weakSelf.container.genderField.text substringToIndex:1] onSuccess:^(BOOL isSuccess) {
                                       
                                       [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:YES];
                                       [weakSelf.navigationController popViewControllerAnimated:YES];
                                       
                                   } onFailure:^(NSError *error, BOOL isCanceled) {
                                       [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:YES];
                                       [BZRAlertFacade showFailureResponseAlertWithError:error forController:weakSelf andCompletion:^{
                                           
                                       }];
                                   }];
                               } onFailure:^(NSMutableDictionary *errorDict) {
                                   [BZRValidator cleanValidationErrorDict];
                               }];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

/**
 *  Setup profile data to relative text fields.
 */
- (void)setupFieldsValueFromProfile
{
    self.container.firstNameField.text  = self.currentProfile.firstName;
    self.container.lastNameField.text   = self.currentProfile.lastName;
    self.container.emailField.text      = self.currentProfile.email;
    self.container.genderField.text     = self.currentProfile.genderString;
    self.container.dateOfBirthField.text = [[BZRCommonDateFormatter commonDateFormatter] stringFromDate:self.currentProfile.dateOfBirth];
    
    self.container.emailField.userInteractionEnabled = NO;
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:kEditProfileContainerSegueIdentifier]) {
        self.container = (BZREditProfileContainerController *)segue.destinationViewController;
        self.container.scrollNeeded = NO;
        [self.container viewWillAppear:YES];
    }
}

@end
