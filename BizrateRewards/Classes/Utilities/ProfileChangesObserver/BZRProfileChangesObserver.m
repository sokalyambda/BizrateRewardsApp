//
//  BZRProfileChangesObserver.m
//  BizrateRewards
//
//  Created by Eugenity on 11.08.15.
//  Copyright (c) 2015 Connexity. All rights reserved.
//

#import "BZRProfileChangesObserver.h"

#import "BZRCommonDateFormatter.h"

static NSString *const kTextKeyPath = @"text";

@interface BZRProfileChangesObserver ()

@property (strong, nonatomic) BZRUserProfile *currentProfile;

@property (strong, nonatomic) UITextField *firstNameField;
@property (strong, nonatomic) UITextField *lastNameField;
@property (strong, nonatomic) UITextField *emailField;

@property (strong, nonatomic) UITextField *genderField;
@property (strong, nonatomic) UITextField *dateOfBirthField;

@property (strong, nonatomic) NSArray *editableFields;
@property (strong, nonatomic) NSArray *notEditableFields;

@property (copy, nonatomic) ProfileChangedBlock profileChangedBlock;

@end

@implementation BZRProfileChangesObserver

#pragma mark - Accessors

- (BZRUserProfile *)currentProfile
{
    _currentProfile = [BZRStorageManager sharedStorage].currentProfile;
    return _currentProfile;
}

- (NSArray *)editableFields
{
    if (!_editableFields) {
        _editableFields = @[_firstNameField, _lastNameField, _emailField];
    }
    return _editableFields;
}

- (NSArray *)notEditableFields
{
    if (!_notEditableFields) {
        _notEditableFields = @[_genderField, _dateOfBirthField];
    }
    return _notEditableFields;
}

#pragma mark - Lifecycle

- (void)dealloc
{
    [self removeObserverFromProfileFields];
}

- (instancetype)initWithFirstNameField:(UITextField *)firstNameField
                      andLastNameField:(UITextField *)lastNameField
                         andEmailField:(UITextField *)emailField
                        andGenderField:(UITextField *)genderField
                   andDateOfBirthField:(UITextField *)dateOfBirthField
{
    self = [super init];
    if (self) {
        _firstNameField     = firstNameField;
        _lastNameField      = lastNameField;
        _emailField         = emailField;
        _genderField        = genderField;
        _dateOfBirthField   = dateOfBirthField;

        [self addObserverForProfileFields];
    }
    return self;
}

#pragma mark - Actions

/**
 *  Check whether profile has changes
 */
- (void)checkProfileForChanges
{
    if ((![self.firstNameField.text isEqualToString:self.currentProfile.firstName] ||
         ![self.lastNameField.text isEqualToString:self.currentProfile.lastName] ||
         ![self.genderField.text isEqualToString:self.currentProfile.genderString] ||
         ![self.dateOfBirthField.text isEqualToString:[[BZRCommonDateFormatter commonDateFormatter] stringFromDate:self.currentProfile.dateOfBirth]]) && self.profileChangedBlock) {
        self.profileChangedBlock(YES);
    } else if (self.profileChangedBlock) {
        self.profileChangedBlock(NO);
    }
}

/**
 *  Add observer for profile text fields
 */
- (void)addObserverForProfileFields
{
    for (UITextField *field in self.editableFields) {
        [field addTarget:self action:@selector(textFieldTextDidChange:) forControlEvents:UIControlEventEditingChanged];
    }
    
    for (UITextField *field in self.notEditableFields) {
        [field addObserver:self forKeyPath:kTextKeyPath options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:NULL];
    }
}

/**
 *  Remove observer from profile text fields
 */
- (void)removeObserverFromProfileFields
{
    for (UITextField *field in self.notEditableFields) {
        [field removeObserver:self forKeyPath:kTextKeyPath];
    }
}

/**
 *  Called when not-editable text fields text has been changed
 *
 *  @param field Current text field
 */
- (void)textFieldTextDidChange:(UITextField *)field
{
    [self checkProfileForChanges];
}

/**
 *  Setup the changes block
 *
 *  @param profileChangedBlock Completion that called when text fields data changes
 */
- (void)observeProfileChangesWithBlock:(ProfileChangedBlock)profileChangedBlock
{
    if (profileChangedBlock) {
        self.profileChangedBlock = profileChangedBlock;
    }
}

#pragma mark - KVO

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    [self checkProfileForChanges];
}

@end
