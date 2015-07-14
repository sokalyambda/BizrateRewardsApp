//
//  BZRDatePickerHolder.h
//  BizrateRewards
//
//  Created by Eugenity on 02.07.15.
//  Copyright (c) 2015 Connexity. All rights reserved.
//

@protocol BZRPickerHolderDelegate;

@interface BZRPickerHolder : UIPickerView

@property (strong, nonatomic) NSArray *componentsArray;

- (void)addComponentsItems:(NSArray*)items;
- (void)setRowInComponent:(NSUInteger)component byValue:(id)value;

- (NSInteger)selectedIndexComponent:(NSInteger)component;
- (id)selectedValueInComponent:(NSInteger)component;

- (id)valueForRow:(NSInteger)row forComponent:(NSInteger)component;

@end

