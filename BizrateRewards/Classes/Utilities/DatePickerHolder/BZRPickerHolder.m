//
//  BZRDatePickerHolder.m
//  BizrateRewards
//
//  Created by Eugenity on 02.07.15.
//  Copyright (c) 2015 Connexity. All rights reserved.
//

#import "BZRPickerHolder.h"

@interface BZRPickerHolder ()<UIPickerViewDataSource>

@property (strong, nonatomic) NSMutableArray *internalArray;

@end

@implementation BZRPickerHolder

#pragma mark - Lifecycle

- (void)awakeFromNib
{
    [self commonInit];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (void)commonInit
{
    self.dataSource = self;
    self.internalArray = [NSMutableArray array];
}

#pragma mark -  Accessors

- (void)setComponentsArray:(NSArray *)componentsArray
{
    if (componentsArray.count) {
        for (NSArray *itemsArray in componentsArray) {
            if (itemsArray.count == 0)
                return;
        }
    }
    self.internalArray = [NSMutableArray arrayWithArray:componentsArray];
}

- (NSArray *)componentsArray
{
    return self.internalArray;
}

#pragma mark - Actions

- (void)addComponentsItems:(NSArray*)items
{
    if (items.count > 0) {
       [self.internalArray addObject:items];
    }
}

- (void)setRowInComponent:(NSUInteger)component byValue:(id)value
{
    if (component < self.internalArray.count) {
        NSArray *items = self.internalArray[component];
        NSUInteger ind =  [items indexOfObject:value];
        if (ind == NSNotFound) {
            ind = 0;
        }
        
        [self selectRow:ind inComponent:component animated:NO];
    }
}

- (NSInteger)selectedIndexComponent:(NSInteger)component
{
    NSUInteger ind = [super selectedRowInComponent:component];
    
    if (component < self.internalArray.count) {
        ind %= ((NSArray*)self.internalArray[component]).count;
    }
    
    return ind;
}

- (id)selectedValueInComponent:(NSInteger)component
{
    if (component < self.internalArray.count) {
        NSUInteger ind = [self selectedIndexComponent:component];
        return ((NSArray*)self.internalArray[component])[ind];
    }
    return nil;
}

- (id)valueForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (component < self.internalArray.count) {
        NSUInteger ind = row;
        NSArray *itemsArray = self.internalArray[component];
        ind %= itemsArray.count;
        
        if (ind < itemsArray.count) {
            return itemsArray[ind];
        }
    }
    
    return nil;
}

#pragma mark - UIPickerViewDataSource methods

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return [self.internalArray count];
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if ([self.internalArray count]) {
        return [[self.internalArray objectAtIndex:component] count];
    } else {
        return 0;
    }
}

@end
