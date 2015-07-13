//
//  BZRProfileSettingsController.m
//  BizrateRewards
//
//  Created by Eugenity on 27.06.15.
//  Copyright (c) 2015 ThinkMobiles. All rights reserved.
//

#import "BZREditProfileController.h"
#import "BZREditProfileContainerController.h"

static NSString *const kEditProfileContainerSegueIdentifier = @"editProfileContainerSegue";

@interface BZREditProfileController ()

@property (strong, nonatomic) IBOutlet UIBarButtonItem *doneBarButton;

@property (weak, nonatomic) BZREditProfileContainerController *container;

@end

@implementation BZREditProfileController

#pragma mark - View Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self customizeNavigationItem];
}

#pragma mark - Actions

- (IBAction)doneClick:(id)sender
{
    //TODO: update user
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)customizeNavigationItem
{
    self.navigationItem.title = NSLocalizedString(@"Profile", nil);
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    self.navigationItem.rightBarButtonItem = self.doneBarButton;
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:kEditProfileContainerSegueIdentifier]) {
        self.container = (BZREditProfileContainerController *)segue.destinationViewController;
        [self.container viewWillAppear:YES];
    }
}

@end
