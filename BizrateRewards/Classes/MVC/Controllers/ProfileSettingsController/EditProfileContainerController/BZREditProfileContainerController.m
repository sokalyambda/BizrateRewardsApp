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

@property (strong, nonatomic) IBOutletCollection(UITextField) NSArray *textFields;

@property (strong, nonatomic) UITableViewCell *activeCell;

@end

@implementation BZREditProfileContainerController

#pragma mark - Accessors

- (BZRPickersHelper *)pickersHelper
{
    if (!_pickersHelper) {
        _pickersHelper = [[BZRPickersHelper alloc] initWithParentView:self.parentViewController.view andContainerController:self];
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

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

#pragma mark - UITableViewDelegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    BZREditableFieldType fieldType = indexPath.row;
    
    self.activeCell = [tableView cellForRowAtIndexPath:indexPath];
    
    WEAK_SELF;
    switch (fieldType) {
        case BZREditableFieldTypeDateOfBirth: {
            
            [self resignIfFirstResponder];
            
            [self.pickersHelper showBirthDatePickerWithResult:^(NSDate *dateOfBirth, BOOL isOlderThirteen) {
                
                weakSelf.dateOfBirthField.text = [[BZRCommonDateFormatter commonDateFormatter] stringFromDate:dateOfBirth];
            }];
            break;
        }
        case BZREditableFieldTypeGender: {
            
            [self resignIfFirstResponder];
            
            [self.pickersHelper showGenderPickerWithResult:^(BOOL isMale, NSString *genderString) {
                
                weakSelf.genderField.text = genderString;
                
            }];
            break;
        }
        default:
            break;
    }
}

#pragma mark - Private methods

- (void)adjustTableViewInsetsWithPresentedRect:(CGRect)rect
{
    CGRect tableViewFrame = self.tableView.frame;
    tableViewFrame = [self.parentViewController.view convertRect:tableViewFrame fromView:self.tableView];
    
    CGRect intersection = CGRectIntersection(rect, tableViewFrame);
    
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.f, 0.f, CGRectGetHeight(intersection), 0.f);
    self.tableView.contentInset = contentInsets;
    self.tableView.scrollIndicatorInsets = contentInsets;
    
    [self.tableView scrollToRowAtIndexPath:[self.tableView indexPathForCell:self.activeCell] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
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
