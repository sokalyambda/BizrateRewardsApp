//
//  Validator.m
//  CarusselSalesTool
//
//  Created by Eugenity on 26.05.15.
//  Copyright (c) 2015 Connexity. All rights reserved.
//

#import "BZRCommonDateFormatter.h"

#import "UIView+Shaking.h"
#import "UIView+Flashable.h"

#import "BZRAuthorizationField.h"
#import "BZREditProfileField.h"

static const NSInteger kMinPasswordSymbols = 8.f;
static const NSInteger kMaxPasswordSymbols = 16.f;
static const NSInteger kMinValidAge = 13.f;

static NSString *const kEmailErrorImageName = @"email_icon_error";
static NSString *const kPasswordErrorImageName = @"password_icon_error";

@implementation BZRValidator

static NSMutableString *_errorString;

#pragma mark - Accessors

+ (NSMutableString *)validationErrorString
{
    @synchronized(self) {
        if (!_errorString) {
            _errorString = [NSMutableString string];
        }
        return _errorString;
    }
}

+ (void)setValidationErrorString:(NSMutableString *)validationErrorString
{
    @synchronized(self) {
        _errorString = validationErrorString;
    }
}

#pragma mark - Private methods

/**
 *  Validation of email field
 *
 *  @param emailField Current email field
 *
 *  @return Returns 'YES' if email is valid
 */
+ (BOOL)validateEmailField:(UITextField *)emailField
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    
    if (![emailTest evaluateWithObject:emailField.text]) {
        [[self validationErrorString] appendString:NSLocalizedString(@"Email is incorrect. Check it\n", nil)];
        
        [emailField shakeView];
        
        if ([emailField isKindOfClass:[BZRAuthorizationField class]]) {
            ((BZRAuthorizationField *)emailField).errorImageName = kEmailErrorImageName;
        } else if ([emailField isKindOfClass:[BZREditProfileField class]]) {
            ((BZREditProfileField *)emailField).validationFailed = YES;
        }
        
        return NO;
    }
    
    return YES;
}

/**
 *  Validation of password field
 *
 *  @param passwordField Current password field
 *
 *  @return Returns 'YES' if password is valid
 */
+ (BOOL)validatePasswordField:(UITextField *)passwordField
{
    if (!(passwordField.text.length >= kMinPasswordSymbols && passwordField.text.length <= kMaxPasswordSymbols)) {
        
        [[self validationErrorString] appendString:NSLocalizedString(@"Invalid password. Password must consist of 8 to 16 characters\n", nil)];
        
        [passwordField shakeView];
        
        if ([passwordField isKindOfClass:[BZRAuthorizationField class]]) {
            ((BZRAuthorizationField *)passwordField).errorImageName = kPasswordErrorImageName;
        } else if ([passwordField isKindOfClass:[BZREditProfileField class]]) {
            ((BZREditProfileField *)passwordField).validationFailed = YES;
        }
        
        return NO;
    }
    
    return YES;
}

+ (BOOL)validatePasswordField:(UITextField *)passwordField andConfirmPasswordField:(UITextField *)confirmPasswordField
{
    BOOL isValid = YES;
    
    if (![self validatePasswordField:passwordField]) {
        return NO;
    }
    
    if (![passwordField.text isEqualToString:confirmPasswordField.text]) {

        [[self validationErrorString] appendString:NSLocalizedString(@"Password does not match the confirm password\n", nil)];
        
        [confirmPasswordField shakeView];
        
        if ([confirmPasswordField isKindOfClass:[BZRAuthorizationField class]]) {
            ((BZRAuthorizationField *)confirmPasswordField).errorImageName = kPasswordErrorImageName;
        }
        
        isValid = NO;
    }
    
    return isValid;
}

/**
 *  Validate checkboxes
 *
 *  @param checkboxes Array of checkboxes
 *
 *  @return Returns 'YES' if each checkbox is selected
 */
+ (BOOL)validateCheckboxes:(NSArray *)checkboxes
{
    BOOL isValid = YES;
    for (UIButton *checkbox in checkboxes) {
        if (!checkbox.selected) {
            [checkbox flashing];
            isValid = NO;
        }
    }
    return isValid;
}

+ (BOOL)validateFirstNameField:(UITextField *)firstNameField andLastNameField:(UITextField *)lastNameField
{
//    NSCharacterSet *alphaSet = [NSCharacterSet letterCharacterSet];
    
    NSString *lettersRegex = @"^[A-Za-z]*";
    NSPredicate *lettersPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", lettersRegex];
    
    BOOL isFirstNameValid = [lettersPredicate evaluateWithObject:firstNameField.text] && firstNameField.text.length;
    
    BOOL isLastNameValid = [lettersPredicate evaluateWithObject:lastNameField.text] && lastNameField.text.length;
    
    BOOL isValid = YES;
    
    if (!isFirstNameValid) {
        
        [[self validationErrorString] appendString:NSLocalizedString(@"First name can only contain letters\n", nil)];
        
        [firstNameField shakeView];
        
        if ([firstNameField isKindOfClass:[BZREditProfileField class]]) {
            ((BZREditProfileField *)firstNameField).validationFailed = YES;
        }

        isValid = NO;
    }
    
    if (!isLastNameValid) {
        
        [[self validationErrorString] appendString:NSLocalizedString(@"Last name can only contain letters\n", nil)];
        
        [lastNameField shakeView];
        
        if ([lastNameField isKindOfClass:[BZREditProfileField class]]) {
            ((BZREditProfileField *)lastNameField).validationFailed = YES;
        }
        
        isValid = NO;
    }
    
    return isValid;
}

/**
 *  Validate date of birth field
 *
 *  @param dateField Current date of birth field
 *
 *  @return Returns 'YES' if user is older than min valid age and this date is in corrent format and exists
 */
+ (BOOL)validateBirthDateField:(UITextField *)dateField
{
    NSDate *now = [NSDate date];
    NSDate *birthDate = [[BZRCommonDateFormatter commonDateFormatter] dateFromString:dateField.text];
    
    if (!birthDate) {
        
        [dateField shakeView];
        
        [[self validationErrorString] appendString:NSLocalizedString(@"Date is empty\n", nil)];
        
        if ([dateField isKindOfClass:[BZREditProfileField class]]) {
            ((BZREditProfileField *)dateField).validationFailed = YES;
        }
        
        return NO;
    }
    
    NSDateComponents* ageComponents = [[NSCalendar currentCalendar]
                                       components:NSCalendarUnitYear
                                       fromDate:birthDate
                                       toDate:now
                                       options:0.f];
    NSInteger age = [ageComponents year];
    
    if (age < kMinValidAge) {
        
        [dateField shakeView];
        
        if ([dateField isKindOfClass:[BZREditProfileField class]]) {
            ((BZREditProfileField *)dateField).validationFailed = YES;
        }
        
        [[self validationErrorString] appendString:NSLocalizedString(@"You must be of age 13 or older to register\n", nil)];
        return NO;
        
    }
    return YES;
}

/**
 *  Validate gender field
 *
 *  @param genderField Current gender field
 *
 *  @return Returns 'YES' if gender is in correct format and exists
 */
+ (BOOL)validateGenderField:(UITextField *)genderField
{
    if (!genderField.text.length) {
        
        [[self validationErrorString] appendString:NSLocalizedString(@"Gender field is empty\n", nil)];
        
        [genderField shakeView];
        
        if ([genderField isKindOfClass:[BZREditProfileField class]]) {
            ((BZREditProfileField *)genderField).validationFailed = YES;
        }
        
        return NO;
    }
    return YES;
}

#pragma mark - Public methods

/**
 *  Public Validation Methods
 *
 *  @param currentField Current field for validation
 *  @param success      Success Block
 *  @param failure      Failure Block
 */

+ (void)validateEmailField:(UITextField *)emailField
                 onSuccess:(ValidationSuccessBlock)success
                 onFailure:(ValidationFailureBlock)failure
{
    if (![self validateEmailField:emailField] && failure) {

        failure([self validationErrorString]);
        
    } else if (success) {
        success();
    }
}

+ (void)validateEmailField:(UITextField *)emailField
          andPasswordField:(UITextField *)passwordField
                 onSuccess:(ValidationSuccessBlock)success
                 onFailure:(ValidationFailureBlock)failure
{
    BOOL isValid = YES;
    
    if (![self validateEmailField:emailField]) {
        isValid = NO;
    }
    
    if (![self validatePasswordField:passwordField]) {
        isValid = NO;
    }
    
    if (!isValid && failure) {
        failure([self validationErrorString]);
    } else if (success) {
        success();
    }
}

+ (void)validateEmailField:(UITextField *)emailField
          andPasswordField:(UITextField *)passwordField
   andConfirmPasswordField:(UITextField *)confirmPassword
                 onSuccess:(ValidationSuccessBlock)success
                 onFailure:(ValidationFailureBlock)failure
{
    BOOL isValid = YES;
    
    if (![self validateEmailField:emailField]) {
        isValid = NO;
    }
    if (![self validatePasswordField:passwordField andConfirmPasswordField:confirmPassword]) {
        isValid = NO;
    }
    
    if (!isValid && failure) {
        failure([self validationErrorString]);
    } else if (success) {
        success();
    }
}

+ (void)validateFirstNameField:(UITextField *)firstNameField
                 lastNameField:(UITextField *)lastNameField
                    emailField:(UITextField *)emailField
              dateOfBirthField: (UITextField *)dateOfBirthField
                   genderField: (UITextField *)genderField
                 andCheckboxes:(NSArray *)checkboxes
                     onSuccess:(ValidationSuccessBlock)success
                     onFailure:(ValidationFailureBlock)failure
{
    BOOL isValid = YES;
    
    if (![self validateFirstNameField:firstNameField andLastNameField:lastNameField]) {
        isValid = NO;
    }
    if (![self validateEmailField:emailField]) {
        isValid = NO;
    }
    if (![self validateBirthDateField:dateOfBirthField]) {
        isValid = NO;
    }
    if (![self validateGenderField:genderField]) {
        isValid = NO;
    }
    if (checkboxes) {
        if (![self validateCheckboxes:checkboxes]) {
            isValid = NO;
        }
    }
    
    if (!isValid && failure) {
        failure([self validationErrorString]);
    } else if (success) {
        success();
    }
    
}

#pragma mark - Other actions

/**
 *  Clean the validation error string
 */
+ (void)cleanValidationErrorString
{
    [self setValidationErrorString:[@"" mutableCopy]];
}

@end
