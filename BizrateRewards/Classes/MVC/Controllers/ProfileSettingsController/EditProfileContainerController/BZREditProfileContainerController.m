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

@implementation BZREditProfileContainerController {
    CGRect savedKeyboardRect;
}

#pragma mark - Accessors

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

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.pickersHelper = [[BZRPickersHelper alloc] initWithParentView:self.parentViewController.view andContainerController:self];
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
    savedKeyboardRect = rect;
    
    CGRect tableViewFrame = self.tableView.frame;
    tableViewFrame = [self.parentViewController.view convertRect:tableViewFrame fromView:self.tableView];
    
    CGRect intersection = CGRectIntersection(rect, tableViewFrame);
    
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.f, 0.f, CGRectGetHeight(intersection), 0.f);
    self.tableView.contentInset = contentInsets;
    self.tableView.scrollIndicatorInsets = contentInsets;

    [self checkForMovement];
}

- (void)resignIfFirstResponder
{
    for (UITextField *field in self.textFields) {
        if ([field isFirstResponder]) {
            [field resignFirstResponder];
        }
    }
}

- (void)checkForMovement
{
    CGRect activeCellFrame = self.activeCell.frame;
    activeCellFrame = [self.parentViewController.view convertRect:activeCellFrame fromView:self.tableView];
    
    if (CGRectIntersectsRect(savedKeyboardRect, activeCellFrame)) {
        [self.tableView scrollToRowAtIndexPath:[self.tableView indexPathForCell:self.activeCell] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
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
    
    [self checkForMovement];
    
    return YES;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    self.activeCell = ((UITableViewCell *)textField.superview.superview);
    return YES;
}

@end
