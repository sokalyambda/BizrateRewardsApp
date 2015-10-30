//
//  BZRDiagnosticsDataSource.m
//  Bizrate Rewards
//
//  Created by Eugenity on 29.10.15.
//  Copyright © 2015 Connexity. All rights reserved.
//

#import "BZRDiagnosticsDataSource.h"

#import "BZREnvironment.h"

#import "BZREnvironmentService.h"

#import "BZRDropDownCell.h"

@interface BZRDiagnosticsDataSource ()

@property (strong, nonatomic) NSArray *environmentTypes;

@end

@implementation BZRDiagnosticsDataSource

#pragma mark - Accessors

- (NSArray *)environmentTypes
{
    if (!_environmentTypes) {
        _environmentTypes = [BZREnvironmentService eligibleEnvironmentsArray];
    }
    return _environmentTypes;
}

- (NSArray *)currentDataSourceArray
{
    return self.environmentTypes;
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.environmentTypes.count;
}

- (void)configureCell:(UITableViewCell *)cell forIndexPath:(NSIndexPath *)indexPath
{
    BZRDropDownCell *dropDownCell = (BZRDropDownCell *)cell;
    
    BZREnvironment *currentEnvironment = self.environmentTypes[indexPath.row];
    
    if ([currentEnvironment isEqual:self.currentSelectedValue]) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    dropDownCell.textLabel.textColor = [UIColor blackColor];
    dropDownCell.selectionStyle = UITableViewCellSelectionStyleBlue;
    
    dropDownCell.textLabel.text = currentEnvironment.environmentName;
}

@end
