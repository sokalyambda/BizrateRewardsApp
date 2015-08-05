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
#import "BZRCommonDateFormatter.h"

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

@property (strong, nonatomic) IBOutletCollection(UITextField) NSArray *textFields;

@property (strong, nonatomic) NSIndexPath *editedIndexPath;

@property (assign, nonatomic) CGRect savedKeyboardRect;

@end

@implementation BZREditProfileContainerController

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

/**
 *  Don't call [super viewWillAppear:YES] to avoid auto keyboard handling, provided by table view controller. Keyboard handles manually from BZRPickersHelper class
 */
- (void)viewWillAppear:(BOOL)animated
{
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    BZREditableFieldType fieldType = indexPath.row;
    
    self.editedIndexPath = indexPath;
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    [self resignIfFirstResponder];
    
    WEAK_SELF;
    switch (fieldType) {
        case BZREditableFieldTypeDateOfBirth: {
            
            self.dateOfBirthField.validationFailed = NO;
            
            [self.pickersHelper showBirthDatePickerWithResult:^(NSDate *dateOfBirth) {
                
                weakSelf.dateOfBirthField.text = [[BZRCommonDateFormatter commonDateFormatter] stringFromDate:dateOfBirth];

            }];
            break;
        }
        case BZREditableFieldTypeGender: {
            
            self.genderField.validationFailed = NO;
            
            [self.pickersHelper showGenderPickerWithResult:^(NSString *genderString) {
                
                weakSelf.genderField.text = genderString;
                
            }];
            break;
        }
        default:
            break;
    }
}

#pragma mark - Actions

/**
 *  Adjust table view insets relative to presented rect
 *
 *  @param rect Rect which can be the keyboard or the picker
 */
- (void)adjustTableViewInsetsWithPresentedRect:(CGRect)rect
{
    self.savedKeyboardRect = rect;
    
    CGRect tableViewFrame = self.tableView.frame;
    tableViewFrame = [self.parentViewController.view convertRect:tableViewFrame fromView:self.tableView];
    
    CGRect intersection = CGRectIntersection(rect, tableViewFrame);
    
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.f, 0.f, CGRectGetHeight(intersection), 0.f);

    WEAK_SELF;
    [UIView animateWithDuration:kAnimationDuration animations:^{
        weakSelf.tableView.contentInset = contentInsets;
        weakSelf.tableView.scrollIndicatorInsets = contentInsets;
        [weakSelf checkForMovement];
    }];
}

#pragma mark - Private methods

/**
 *  Resign first responder from active text field
 */
- (void)resignIfFirstResponder
{
    for (UITextField *field in self.textFields) {
        if ([field isFirstResponder]) {
            [field resignFirstResponder];
        }
    }
}

/**
 *  Check whether movement is needed
 */
- (void)checkForMovement
{
    UITableViewCell *editedCell = [self.tableView cellForRowAtIndexPath:self.editedIndexPath];
    CGRect activeCellFrame = editedCell.frame;
    activeCellFrame = [self.parentViewController.view convertRect:activeCellFrame fromView:self.tableView];

    if (CGRectIntersectsRect(self.savedKeyboardRect, activeCellFrame)) {
        [self.tableView scrollToRowAtIndexPath:self.editedIndexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    }
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if ([self.firstNameField isFirstResponder]) {
        [self.lastNameField becomeFirstResponder];
    } else if ([self.lastNameField isFirstResponder]) {
        self.emailField.userInteractionEnabled ? [self.emailField becomeFirstResponder] : [self.lastNameField resignFirstResponder];
    } else if ([self.emailField isFirstResponder]) {
        [self.emailField resignFirstResponder];
    }

    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    //trim whitespaces
    textField.text = [textField.text stringByReplacingOccurrencesOfString:@" " withString:@""];
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    CGPoint p = [textField convertPoint:CGPointZero toView:self.tableView];
    self.editedIndexPath = [self.tableView indexPathForRowAtPoint:p];
    
    [self checkForMovement];
    
    return YES;
}

@end
