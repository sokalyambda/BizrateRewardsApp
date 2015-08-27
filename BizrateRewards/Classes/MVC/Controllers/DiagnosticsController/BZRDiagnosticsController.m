//
//  BZRDiagnosticsController.m
//  Bizrate Rewards
//
//  Created by Eugenity on 27.08.15.
//  Copyright (c) 2015 Connexity. All rights reserved.
//

#import "BZRDiagnosticsController.h"

#import "BZRSerialViewConstructor.h"

@interface BZRDiagnosticsController ()

@property (weak, nonatomic) IBOutlet UILabel *apiVersionValue;
@property (weak, nonatomic) IBOutlet UILabel *appVersionValue;
@property (weak, nonatomic) IBOutlet UITextField *apiEndpointField;
@property (weak, nonatomic) IBOutlet UIButton *saveAPIEndpointButton;
@property (weak, nonatomic) IBOutlet UITableView *eventsListTableView;

@property (strong, nonatomic) UIBarButtonItem *closeButton;

@end

@implementation BZRDiagnosticsController

#pragma mark - View Lifecycle

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self customizeNavigationItem];
}

#pragma mark - Actions

- (void)customizeNavigationItem
{
    //show navigation bar
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
    
    //create custom 'Done' button
    self.closeButton = [BZRSerialViewConstructor customButtonWithTitle:LOCALIZED(@"Close") forController:self withAction:@selector(closeClicik:)];
    
    //set right bar button item
    self.navigationItem.rightBarButtonItem = self.closeButton;
    
    //remove back button (custom and system)
    self.navigationItem.leftBarButtonItem = nil;
    self.navigationItem.hidesBackButton = YES;
    
    //set navigation title
    self.navigationItem.title = LOCALIZED(@"Diagnostics");
}

/**
 *  Action for dismiss current vc
 *
 *  @param sender UIBarButtonItem
 */
- (void)closeClicik:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
