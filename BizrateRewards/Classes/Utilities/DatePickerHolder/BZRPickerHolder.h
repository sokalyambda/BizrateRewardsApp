//
//  BZRDatePickerHolder.h
//  BizrateRewards
//
//  Created by Eugenity on 02.07.15.
//  Copyright (c) 2015 ThinkMobiles. All rights reserved.
//

@protocol BZRPickerHolderDelegate;

@interface BZRPickerHolder : UIPickerView

@property (strong, nonatomic) NSArray *componentsArray;

@property (strong, nonatomic) NSIndexPath *indexPath;

@property (weak, nonatomic) id <BZRPickerHolderDelegate, UIPickerViewDelegate> pickerHolderDelegate;

- (void)addComponentsItems:(NSArray*)items;
- (void)setRowInComponent:(NSUInteger)component byValue:(id)value;

- (NSInteger)selectedIndexComponent:(NSInteger)component;
- (id)selectedValueInComponent:(NSInteger)component;

- (id)valueForRow:(NSInteger)row forComponent:(NSInteger)component;

@end

@protocol BZRPickerHolderDelegate <NSObject>

@optional
-(void)pickerHolderWillDismiss:(BZRPickerHolder *)pickerHolder;

@end
