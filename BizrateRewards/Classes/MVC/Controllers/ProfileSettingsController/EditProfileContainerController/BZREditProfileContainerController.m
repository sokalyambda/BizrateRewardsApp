//
//  BZREditProfileContainerController.m
//  BizrateRewards
//
//  Created by Eugenity on 02.07.15.
//  Copyright (c) 2015 ThinkMobiles. All rights reserved.
//

#import "BZREditProfileContainerController.h"
#import "BZRGetStartedController.h"

#import "BZRPickersHelper.h"
#import "BZRStorageManager.h"
#import "BZRCommonDateFormatter.h"

#import "BZRUserProfile.h"

typedef enum : NSUInteger {
    BZREditableFieldTypeFirstName,
    BZREditableFieldTypeLastName,
    BZREditableFieldTypeEmail,
    BZREditableFieldTypeDateOfBirth,
    BZREditableFieldTypeGender
} BZREditableFieldType;

@interface BZREditProfileContainerController ()<UITextFieldDelegate>

@property (strong, nonatomic) BZRPickersHelper *pickersHelper;

@property (strong, nonatomic) BZRUserProfile *currentProfile;

@property (assign, nonatomic) BOOL isPickerPresented;

@property (weak, nonatomic) IBOutlet UITextField *firstNameField;
@property (weak, nonatomic) IBOutlet UITextField *lastNameField;
@property (weak, nonatomic) IBOutlet UITextField *emailField;
@property (weak, nonatomic) IBOutlet UITextField *dateOfBirthField;
@property (weak, nonatomic) IBOutlet UITextField *genderField;

@property (strong, nonatomic) IBOutletCollection(UITextField) NSArray *textFields;

@end

@implementation BZREditProfileContainerController

#pragma mark - Accessors

- (BZRPickersHelper *)pickersHelper
{
    if (!_pickersHelper) {
        _pickersHelper = [[BZRPickersHelper alloc] initWithParentView:self.parentViewController.view];
    }
    return _pickersHelper;
}

- (BZRUserProfile *)currentProfile
{
    if (!_currentProfile) {
        _currentProfile = [BZRStorageManager sharedStorage].currentProfile;
    }
    return _currentProfile;
}

#pragma mark - View Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
}

#pragma mark - UITableViewDelegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    BZREditableFieldType fieldType = indexPath.row;
    
    WEAK_SELF;
    switch (fieldType) {
        case BZREditableFieldTypeDateOfBirth: {
            
            [self resignIfFirstResponder];
            
            [self.pickersHelper showBirthDatePickerWithResult:^(NSDate *dateOfBirth, BOOL isOlderThirteen) {
                
                weakSelf.dateOfBirthField.text = [[BZRCommonDateFormatter commonDateFormatter] stringFromDate:dateOfBirth];
                
            } withAnimationCompletion:^(BOOL isExpanded, UIView *pickerView) {
                [weakSelf adjustPicker:pickerView withExpanding:isExpanded];
            }];
            break;
        }
        case BZREditableFieldTypeGender: {
            
            [self resignIfFirstResponder];
            
            [self.pickersHelper showGenderPickerWithResult:^(BOOL isMale, NSString *genderString) {
                
                weakSelf.genderField.text = genderString;
                
            } withAnimationCompletion:^(BOOL isExpanded, UIView *pickerView) {
                [weakSelf adjustPicker:pickerView withExpanding:isExpanded];
            }];
            break;
        }
        default:
            break;
    }
}

#pragma mark - Private methods

- (void)adjustPicker:(UIView *)picker withExpanding:(BOOL)isExpanded
{
    if (isExpanded) {
        [self pickerDidShow:picker];
    } else {
        [self pickerDidHide:picker];
    }
}

- (void)pickerDidShow:(UIView *)picker
{
    if (!self.isPickerPresented) {
        self.isPickerPresented = YES;
        
        CGRect pickerFrame = picker.frame;
        
        CGRect tableViewFrame = self.tableView.frame;
        
        tableViewFrame = [self.parentViewController.view convertRect:tableViewFrame fromView:self.view];
        
        CGRect intersection = CGRectIntersection(tableViewFrame, pickerFrame);
        
        [self.tableView setContentOffset:CGPointMake(0, CGRectGetHeight(intersection)) animated:YES];
    }
}

- (void)pickerDidHide:(UIView *)picker
{
    self.isPickerPresented = NO;
    [self.tableView setContentOffset:CGPointZero animated:YES];
}

- (void)resignIfFirstResponder
{
    for (UITextField *field in self.textFields) {
        if ([field isFirstResponder]) {
            [field resignFirstResponder];
        }
    }
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if ([self.firstNameField isFirstResponder]) {
        [self.lastNameField becomeFirstResponder];
    } else if ([self.lastNameField isFirstResponder]) {
        [self.emailField becomeFirstResponder];
    } else if ([self.emailField isFirstResponder]) {
        [self.emailField resignFirstResponder];
    }
    return YES;
}

@end
