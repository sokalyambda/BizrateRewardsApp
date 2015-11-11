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

@end

@implementation BZRDiagnosticsDataSource

#pragma mark - Accessors

- (NSArray *)currentDataSourceArray
{
    return [BZREnvironmentService eligibleEnvironmentsArray];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self currentDataSourceArray].count;
}

- (void)configureCell:(UITableViewCell *)cell forIndexPath:(NSIndexPath *)indexPath
{
    BZRDropDownCell *dropDownCell = (BZRDropDownCell *)cell;
    
    BZREnvironment *currentEnvironment = [self currentDataSourceArray][indexPath.row];
    
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
