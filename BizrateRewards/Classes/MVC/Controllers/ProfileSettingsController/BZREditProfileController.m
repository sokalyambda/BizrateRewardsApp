//
//  BZRProfileSettingsController.m
//  BizrateRewards
//
//  Created by Eugenity on 27.06.15.
//  Copyright (c) 2015 ThinkMobiles. All rights reserved.
//

#import "BZREditProfileController.h"

@interface BZREditProfileController ()

@property (strong, nonatomic) IBOutlet UIBarButtonItem *doneBarButton;

@end

@implementation BZREditProfileController

#pragma mark - View Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self customizeNavigationItem];
}

//- (void)viewWillAppear:(BOOL)animated
//{
//    [super viewWillAppear:animated];
//    
//}

#pragma mark - Actions

- (IBAction)doneClick:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)customizeNavigationItem
{
    self.navigationItem.title = NSLocalizedString(@"Profile", nil);
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    self.navigationItem.rightBarButtonItem = self.doneBarButton;
}

@end
