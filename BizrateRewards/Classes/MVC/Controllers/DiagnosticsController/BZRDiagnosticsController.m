//
//  BZRDiagnosticsController.m
//  Bizrate Rewards
//
//  Created by Eugenity on 27.08.15.
//  Copyright (c) 2015 Connexity. All rights reserved.
//

#import "BZRDiagnosticsController.h"

#import "BZRSerialViewConstructor.h"

#import "BZRProjectFacade.h"

#import "BZRDiagnosticsCell.h"

#import "BZRLocationEvent.h"
#import "BZRServerAPIEntity.h"

static NSInteger const kCurrentNumberOfSections = 2.f;

@interface BZRDiagnosticsController ()<UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *apiVersionValue;
@property (weak, nonatomic) IBOutlet UILabel *appVersionValue;
@property (weak, nonatomic) IBOutlet UITextField *apiEndpointField;
@property (weak, nonatomic) IBOutlet UIButton *saveAPIEndpointButton;
@property (weak, nonatomic) IBOutlet UITableView *eventsListTableView;

@property (strong, nonatomic) NSArray *locationEvents;
@property (strong, nonatomic) BZRLocationEvent *lastLocationEvent;
@property (strong, nonatomic) BZRServerAPIEntity *currentAPIEntity;

@property (strong, nonatomic) UIBarButtonItem *closeButton;

@end

@implementation BZRDiagnosticsController

#pragma mark - Accessors

- (BZRLocationEvent *)lastLocationEvent
{
    _lastLocationEvent = [BZRLocationEvent locationEventFromDefaultsForKey:LastReceivedLocationEvent];
    return _lastLocationEvent;
}

- (BZRServerAPIEntity *)currentAPIEntity
{
    _currentAPIEntity = [BZRStorageManager sharedStorage].currentServerAPIEntity;
    return _currentAPIEntity;
}

#pragma mark - View Lifecycle

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self customizeNavigationItem];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self getAPIInfo];
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

- (void)getAPIInfo
{
    WEAK_SELF;
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [BZRProjectFacade getAPIInfoOnSuccess:^(BOOL success) {
        
        [BZRProjectFacade getGeolocationEventsListOnSuccess:^(NSArray *locationEvents) {
            [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:YES];
            
            weakSelf.locationEvents = locationEvents;
            [weakSelf updateDiagnosticsInformation];
            
        } onFailure:^(NSError *error, BOOL isCanceled) {
            [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:YES];
            
        }];
        
    } onFailure:^(NSError *error, BOOL isCanceled) {
        [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:YES];
        
    }];
}

- (void)updateDiagnosticsInformation
{
    self.apiVersionValue.text = self.currentAPIEntity.apiVersion;
    self.appVersionValue.text = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    
    [self.eventsListTableView reloadData];
}

- (IBAction)saveAPIEndpointClick:(id)sender
{
    [BZRProjectFacade initHTTPClientWithRootPath:self.apiEndpointField.text];
    
    if ([self.apiEndpointField isFirstResponder]) {
        [self.apiEndpointField resignFirstResponder];
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return kCurrentNumberOfSections;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return section == 0 ? 1.f : self.locationEvents.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BZRDiagnosticsCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([BZRDiagnosticsCell class]) forIndexPath:indexPath];
    
    BZRLocationEvent *currentEvent = indexPath.section == 0 ? self.lastLocationEvent : self.locationEvents[indexPath.row];
    
    [cell configureWithLocationEvent:currentEvent];
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return section == 0 ? LOCALIZED(@"Last Event from EYC SDK") : LOCALIZED(@"Last 10 Events Captured on API");
}

@end
