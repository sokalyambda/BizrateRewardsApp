//
//  BZRBaseDropDownDataSource.m
//  Bizrate Rewards
//
//  Created by Eugenity on 29.10.15.
//  Copyright © 2015 Connexity. All rights reserved.
//

#import "BZRBaseDropDownDataSource.h"
#import "BZRDiagnosticsDataSource.h"

#import "BZRDropDownCell.h"

@interface BZRBaseDropDownDataSource ()

@property (nonatomic) NSArray *currentDataSourceArray;

@end

@implementation BZRBaseDropDownDataSource

@synthesize currentSelectedValue = _currentSelectedValue;

#pragma mark - Accessors

- (id)currentSelectedValue
{
    if (!_currentSelectedValue && self.currentDataSourceArray.count) {
        _currentSelectedValue = self.currentDataSourceArray[0];
    }
    return _currentSelectedValue;
}

#pragma mark - Lifecycle

- (instancetype)initWithDataSourceType:(BZRDataSourceType)sourceType
{
    id currentDataSource = nil;
    
    switch (sourceType) {
        case BZRDataSourceTypeDiagnostics: {
            currentDataSource = [[BZRDiagnosticsDataSource alloc] init];
            break;
        }
        default:
            break;
    }
    
    return currentDataSource;
}

+ (instancetype)dataSourceWithType:(BZRDataSourceType)sourceType
{
    return [[self alloc] initWithDataSourceType:sourceType];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIdentifier = NSStringFromClass([BZRDropDownCell class]);
    BZRDropDownCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (!cell) {
        cell = [[BZRDropDownCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.backgroundColor = [UIColor clearColor];
    cell.contentView.backgroundColor = [UIColor clearColor];
    
    [self configureCell:cell forIndexPath:indexPath];
    
    return cell;
}

- (void)configureCell:(UITableViewCell *)cell forIndexPath:(NSIndexPath *)indexPath
{
    
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    id chosenValue = self.currentDataSourceArray[indexPath.row];
    
    if (![chosenValue isEqual:self.currentSelectedValue]) {
        _currentSelectedValue = chosenValue;
    }
    [tableView reloadData];
    
    if (self.result) {
        [self.dropDownTableView hideDropDownList];
        self.result(self.dropDownTableView, chosenValue);
        self.result = nil;
    }
}

#pragma mark - Actions

- (void)updateSelectedValueInDataSourceArray:(id)value
{
    if (!value) {
        return;
    }

    if ([self.currentDataSourceArray containsObject:value]) {
        _currentSelectedValue = value;
    }
}

@end
