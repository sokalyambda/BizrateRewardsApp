//
//  BZREditProfileContainerController.m
//  BizrateRewards
//
//  Created by Eugenity on 02.07.15.
//  Copyright (c) 2015 ThinkMobiles. All rights reserved.
//

#import "BZREditProfileContainerController.h"
#import "BZRPickersHelper.h"

typedef enum : NSUInteger {
    BZREditableFieldTypeFirstName,
    BZREditableFieldTypeLastName,
    BZREditableFieldTypeEmail,
    BZREditableFieldTypeDateOfBirth,
    BZREditableFieldTypeGender
} BZREditableFieldType;

@interface BZREditProfileContainerController ()

@property (strong, nonatomic) BZRPickersHelper *pickersHelper;

@end

@implementation BZREditProfileContainerController

#pragma mark - Accessors

- (BZRPickersHelper *)pickersHelper
{
    if (!_pickersHelper) {
        _pickersHelper = [[BZRPickersHelper alloc] init];
    }
    return _pickersHelper;
}

#pragma mark - View Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
}

#pragma mark - UITableViewDelegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    BZREditableFieldType fieldType = indexPath.row;

    switch (fieldType) {
        case BZREditableFieldTypeDateOfBirth:
            [self.pickersHelper showBirthDatePickerInView:self.parentViewController.view withCompletion:nil];
            break;
        case BZREditableFieldTypeGender:
            [self.pickersHelper showCommonPickerViewInView:self.parentViewController.view withComponentsArray:@[@"Male", @"Female"] withCompletion:nil];
            break;
            
        default:
            break;
    }
}

@end
