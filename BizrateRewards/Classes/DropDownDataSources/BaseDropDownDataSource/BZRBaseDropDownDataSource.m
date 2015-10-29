//
//  BZRBaseDropDownDataSource.m
//  Bizrate Rewards
//
//  Created by Eugenity on 29.10.15.
//  Copyright © 2015 Connexity. All rights reserved.
//

#import "BZRBaseDropDownDataSource.h"
#import "BZRDiagnosticsDataSource.h"

#import "BZRDiagnosticsDropDownCell.h"

@interface BZRBaseDropDownDataSource ()

@property (nonatomic) NSArray *currentDataSourceArray;

@end

@implementation BZRBaseDropDownDataSource

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
    NSString *cellIdentifier = NSStringFromClass([BZRDiagnosticsDropDownCell class]);
    BZRDiagnosticsDropDownCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (!cell) {
        cell = [[BZRDiagnosticsDropDownCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
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
    if (self.result) {
        [self.dropDownTableView hideDropDownList];
        self.result(self.dropDownTableView, self.currentDataSourceArray[indexPath.row]);
        self.result = nil;
    }
}

@end
