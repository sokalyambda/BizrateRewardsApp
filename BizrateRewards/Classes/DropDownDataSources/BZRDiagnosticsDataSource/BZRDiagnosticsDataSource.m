//
//  BZRDiagnosticsDataSource.m
//  Bizrate Rewards
//
//  Created by Eugenity on 29.10.15.
//  Copyright © 2015 Connexity. All rights reserved.
//

#import "BZRDiagnosticsDataSource.h"

#import "BZREnvironment.h"

#import "BZRDiagnosticsDropDownCell.h"

static NSString *const kDevelopmentAPIEndpoint      = @"";
static NSString *const kStagingAPIEndpoint          = @"http://api-stage.bizraterewards.com/v1/";
static NSString *const kProductionAPIEndpoint       = @"https://api.bizraterewards.com/v1/";

static NSString *const kDevelopmentMixPanelToken    = @"";
static NSString *const kStagingMixPanelToken        = @"";
static NSString *const kProductionMixPanelToken     = @"";

@interface BZRDiagnosticsDataSource ()

@property (strong, nonatomic) NSArray *environmentTypes;

@end

@implementation BZRDiagnosticsDataSource

#pragma mark - Accessors

- (NSArray *)environmentTypes
{
    if (!_environmentTypes) {
        _environmentTypes = [self eligibleEnvironmentsArray];
    }
    return _environmentTypes;
}

- (NSArray *)currentDataSourceArray
{
    return self.environmentTypes;
}

#pragma mark - Actions

- (NSArray *)eligibleEnvironmentsArray
{
    BZREnvironment *development = [BZREnvironment environmentWithName:LOCALIZED(@"Development")];
    development.apiEndpointURLString = kDevelopmentAPIEndpoint;
    development.mixPanelToken = kDevelopmentMixPanelToken;
    
    BZREnvironment *staging = [BZREnvironment environmentWithName:LOCALIZED(@"Staging")];
    staging.apiEndpointURLString = kStagingAPIEndpoint;
    staging.mixPanelToken = kStagingMixPanelToken;
    
    BZREnvironment *production = [BZREnvironment environmentWithName:LOCALIZED(@"Production")];
    production.apiEndpointURLString = kProductionAPIEndpoint;
    production.mixPanelToken = kProductionMixPanelToken;
    
    return @[development, staging, production];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.environmentTypes.count;
}

- (void)configureCell:(UITableViewCell *)cell forIndexPath:(NSIndexPath *)indexPath
{
    BZRDiagnosticsDropDownCell *dropDownCell = (BZRDiagnosticsDropDownCell *)cell;
    BZREnvironment *currentEnvironment = self.environmentTypes[indexPath.row];
    dropDownCell.textLabel.text = currentEnvironment.environmentName;
}

@end
