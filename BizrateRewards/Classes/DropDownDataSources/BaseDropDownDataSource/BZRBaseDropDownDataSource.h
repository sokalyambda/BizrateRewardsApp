//
//  BZRBaseDropDownDataSource.h
//  Bizrate Rewards
//
//  Created by Eugenity on 29.10.15.
//  Copyright © 2015 Connexity. All rights reserved.
//

typedef enum : NSUInteger {
    BZRDataSourceTypeDiagnostics
} BZRDataSourceType;

#import "BZRDropDownTableView.h"

@interface BZRBaseDropDownDataSource : NSObject<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic) BZRDropDownTableView *dropDownTableView;
@property (copy, nonatomic) DropDownResult result;

+ (instancetype)dataSourceWithType:(BZRDataSourceType)sourceType;

@end
