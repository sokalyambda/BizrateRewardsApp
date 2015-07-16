//
//  BZREditProfileContainerController.m
//  BizrateRewards
//
//  Created by Eugenity on 02.07.15.
//  Copyright (c) 2015 Connexity. All rights reserved.
//

#import "BZREditProfileContainerController.h"
#import "BZRGetStartedController.h"

#import "BZRPickersHelper.h"
#import "BZRStorageManager.h"
#import "BZRCommonDateFormatter.h"

#import "BZRUserProfile.h"

#import "BZREditProfileField.h"

static CGFloat const kAnimationDuration = .25f;

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

@property (strong, nonatomic) IBOutletCollection(UITextField) NSArray *textFields;

@property (strong, nonatomic) UITableViewCell *activeCell;

@end

@implementation BZREditProfileContainerController

#pragma mark - Accessors

- (BZRUserProfile *)currentProfile
{
    _currentProfile = [BZRStorageManager sharedStorage].currentProfile;
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

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
}

#pragma mark - UITableViewDelegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    BZREditableFieldType fieldType = indexPath.row;
    
    self.activeCell = [tableView cellForRowAtIndexPath:indexPath];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    WEAK_SELF;
    switch (fieldType) {
        case BZREditableFieldTypeDateOfBirth: {
            
            [self resignIfFirstResponder];
            
            self.dateOfBirthField.validationFailed = NO;
            
            [self.pickersHelper showBirthDatePickerWithResult:^(NSDate *dateOfBirth, BOOL isOlderThirteen) {
                
                weakSelf.dateOfBirthField.text = [[BZRCommonDateFormatter commonDateFormatter] stringFromDate:dateOfBirth];

            }];
            break;
        }
        case BZREditableFieldTypeGender: {
            
            [self resignIfFirstResponder];
            
            self.genderField.validationFailed = NO;
            
            [self.pickersHelper showGenderPickerWithResult:^(BOOL isMale, NSString *genderString) {
                
                weakSelf.genderField.text = genderString;
                
            }];
            break;
        }
        default:
            break;
    }
}

#pragma mark - Actions

//- (void)setupUserData
//{
//    self.firstNameField.text    = self.currentProfile.firstName;
//    self.lastNameField.text     = self.currentProfile.lastName;
//    self.emailField.text        = self.currentProfile.email;
//    self.dateOfBirthField.text  = [[BZRCommonDateFormatter commonDateFormatter] stringFromDate:self.currentProfile.dateOfBirth];
//    self.genderField.text       = self.currentProfile.genderString;
//}

- (void)adjustTableViewInsetsWithPresentedRect:(CGRect)rect
{
    self.savedKeyboardRect = rect;
    
    CGRect tableViewFrame = self.tableView.frame;
    tableViewFrame = [self.parentViewController.view convertRect:tableViewFrame fromView:self.tableView];
    
    CGRect intersection = CGRectIntersection(rect, tableViewFrame);
    
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.f, 0.f, CGRectGetHeight(intersection), 0.f);
    
    [UIView animateWithDuration:kAnimationDuration animations:^{
        self.tableView.contentInset = contentInsets;
        self.tableView.scrollIndicatorInsets = contentInsets;
    }];

    [self checkForMovement];
}

#pragma mark - Private methods

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

    if (CGRectIntersectsRect(self.savedKeyboardRect, activeCellFrame)) {
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
    
    return YES;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    CGPoint p = [textField convertPoint:CGPointZero toView:self.tableView];
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:p];
    self.activeCell = [self.tableView cellForRowAtIndexPath:indexPath];
    
    [self checkForMovement];
    
    return YES;
}

@end
