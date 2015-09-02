//
//  BZRDiagnosticsController.m
//  Bizrate Rewards
//
//  Created by Eugenity on 27.08.15.
//  Copyright (c) 2015 Connexity. All rights reserved.
//

#import "BZRDiagnosticsController.h"
#import "BZRLocationDetailsDiagnosticsController.h"
#import "BZRAccountSettingsController.h"

#import "BZRSerialViewConstructor.h"

#import "BZRProjectFacade.h"

#import "BZRDiagnosticsCell.h"

#import "BZRLocationEvent.h"
#import "BZRServerAPIEntity.h"

static NSInteger const kCurrentNumberOfSections = 2.f;
static NSInteger const kLocationEventsCount = 10.f;

@interface BZRDiagnosticsController ()<UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, BZRDiagnosticsCellDelegate>

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

- (void)setLocationEvents:(NSArray *)locationEvents
{
    if (locationEvents.count > kLocationEventsCount) {
        _locationEvents = [locationEvents subarrayWithRange:NSMakeRange(0, kLocationEventsCount)];
    } else {
        _locationEvents = locationEvents;
    }
}

#pragma mark - View Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self customizeNavigationItem];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self getAPIInfo];
    [self updateAPIEndpointTextField];
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

/**
 *  Update diagnostics information
 */
- (void)updateDiagnosticsInformation
{
    self.apiVersionValue.text = self.currentAPIEntity.apiVersion;
    self.appVersionValue.text = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    
    [self.eventsListTableView reloadData];
}

- (void)updateAPIEndpointTextField
{
    self.apiEndpointField.text = [BZRProjectFacade baseURLString];
}

- (IBAction)saveAPIEndpointClick:(id)sender
{
    [self saveAPIEndpoint];
}

- (void)saveAPIEndpoint
{
    WEAK_SELF;
    [BZRProjectFacade setBaseURLString:self.apiEndpointField.text];
    
    [MBProgressHUD showHUDAddedTo:weakSelf.view animated:YES];
    [BZRProjectFacade initHTTPClientWithRootPath:[BZRProjectFacade baseURLString] withCompletion:^{
        
        [BZRProjectFacade getAPIInfoOnSuccess:^(BOOL success) {
            
            [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:YES];
            [[NSUserDefaults standardUserDefaults] setObject:[BZRProjectFacade baseURLString] forKey:BaseURLStringKey];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            [weakSelf updateAPIEndpointTextField];
            
            [BZRAlertFacade showAlertWithMessage:LOCALIZED(@"API endpoint has been saved.") forController:weakSelf withCompletion:^{
                //logout..
                if (![[BZRProjectFacade baseURLString] isEqualToString:defaultBaseURLString]) {
                    
                    [BZRProjectFacade signOutOnSuccess:^(BOOL isSuccess) {
                        
                        [CATransaction begin];
                        [CATransaction setCompletionBlock:^{
                            [weakSelf dismissViewControllerAnimated:YES completion:nil];
                        }];
                        [CATransaction commit];
                        
                        [weakSelf.settingsController signOut];
                        
                    } onFailure:^(NSError *error, BOOL isCanceled) {
                        
                    }];
                    
                }
            }];
        } onFailure:^(NSError *error, BOOL isCanceled) {
            [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:YES];
            
            [BZRAlertFacade showAlertWithMessage:LOCALIZED(@"API endpoint is incorrect.") forController:weakSelf withCompletion:nil];
            
            [BZRProjectFacade setBaseURLString:defaultBaseURLString];
            [BZRProjectFacade initHTTPClientWithRootPath:[BZRProjectFacade baseURLString] withCompletion:nil];
            
            [weakSelf updateAPIEndpointTextField];
        }];
        
    }];
    
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
    cell.delegate = self;
    [cell configureWithLocationEvent:currentEvent];
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return section == 0 ? LOCALIZED(@"Last Event from EYC SDK") : LOCALIZED(@"Last 10 Events Captured on API");
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if ([self.apiEndpointField isFirstResponder]) {
        [self.apiEndpointField resignFirstResponder];
    }
    
    return YES;
}

#pragma mark - BZRDiagnosticsCellDelegate

- (void)diagnosticsCellDidTapLocationLabel:(BZRDiagnosticsCell *)cell
{
    NSIndexPath *indexPath = [self.eventsListTableView indexPathForCell:cell];
    BZRLocationEvent *currentEvent = indexPath.section == 0 ? self.lastLocationEvent : self.locationEvents[indexPath.row];
    
    if (!currentEvent.locationLink.length) {
        return;
    }
    
    BZRLocationDetailsDiagnosticsController *controller = [self.storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([BZRLocationDetailsDiagnosticsController class])];
    controller.currentLocationEvent = currentEvent;
    [self.navigationController pushViewController:controller animated:YES];
}

@end
