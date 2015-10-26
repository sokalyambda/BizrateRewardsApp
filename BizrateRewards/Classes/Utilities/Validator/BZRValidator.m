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

NSString *const kValidationErrorTitle = @"validationErrorTitle";
NSString *const kValidationErrorMessage = @"validationErrorMessage";

@implementation BZRValidator

static NSMutableDictionary *_errorDict;

#pragma mark - Accessors

+ (NSMutableDictionary *)validationErrorDict
{
    @synchronized(self) {
        if (!_errorDict) {
            _errorDict = [NSMutableDictionary dictionary];
        }
        return _errorDict;
    }
}

+ (void)setValidationErrorDict:(NSMutableDictionary *)validationErrorDict
{
    @synchronized(self) {
        _errorDict = validationErrorDict;
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
        [self setErrorTitle:@"" andMessage:LOCALIZED(@"Email is incorrect. Check it\n")];
        
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
    NSString *passwordRegex = [NSString stringWithFormat:@"^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d).{%li,%li}+$", (long)kMinPasswordSymbols, (long)kMaxPasswordSymbols];
    NSPredicate *passwordTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", passwordRegex];
    BOOL isMatchSuccess = [passwordTest evaluateWithObject:passwordField.text];
    
    if (!isMatchSuccess) {
        
        [self setErrorTitle:LOCALIZED(@"Your password is too simple") andMessage:LOCALIZED(@"Minimum length is 8 and it needs to contain at least one uppercase, one lowercase and one number.\n")];
        
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

        [self setErrorTitle:@"" andMessage:LOCALIZED(@"Password does not match the confirm password\n")];
        
        [confirmPasswordField shakeView];
        
        if ([confirmPasswordField isKindOfClass:[BZRAuthorizationField class]]) {
            ((BZRAuthorizationField *)confirmPasswordField).errorImageName = kPasswordErrorImageName;
        }
        
        isValid = NO;
    }
    
    return isValid;
}

+ (BOOL)validateShareCodeField:(UITextField *)shareCodeField
{
    BOOL isValid = YES;
    
    if (!shareCodeField.text.length) {
        isValid = NO;
        
        [self setErrorTitle:@"" andMessage:LOCALIZED(@"Incorrect share code!\n")];
        [shareCodeField shakeView];
    }
    
    if ([shareCodeField isKindOfClass:[BZRAuthorizationField class]] && !isValid) {
        ((BZRAuthorizationField *)shareCodeField).errorImageName = kEmailErrorImageName;
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
        
        [self setErrorTitle:@"" andMessage:LOCALIZED(@"First name can only contain letters\n")];
        
        [firstNameField shakeView];
        
        if ([firstNameField isKindOfClass:[BZREditProfileField class]]) {
            ((BZREditProfileField *)firstNameField).validationFailed = YES;
        }

        isValid = NO;
    }
    
    if (!isLastNameValid) {
        
        [self setErrorTitle:@"" andMessage:LOCALIZED(@"Last name can only contain letters\n")];
        
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
        
        [self setErrorTitle:@"" andMessage:LOCALIZED(@"Date is empty\n")];
        
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
        
        [self setErrorTitle:@"" andMessage:LOCALIZED(@"You must be of age 13 or older to register\n")];
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
        
        [self setErrorTitle:@"" andMessage:LOCALIZED(@"Gender field is empty\n")];
        
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

        failure([self validationErrorDict]);
        
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
        failure([self validationErrorDict]);
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
        failure([self validationErrorDict]);
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
    
    if (![self validateFirstNameField:firstNameField andLastNameField:lastNameField] && firstNameField && lastNameField) {
        isValid = NO;
    }
    if (![self validateEmailField:emailField] && emailField) {
        isValid = NO;
    }
    if (![self validateBirthDateField:dateOfBirthField] && dateOfBirthField) {
        isValid = NO;
    }
    if (![self validateGenderField:genderField] && genderField) {
        isValid = NO;
    }
    if (checkboxes) {
        if (![self validateCheckboxes:checkboxes]) {
            isValid = NO;
        }
    }
    
    if (!isValid && failure) {
        failure([self validationErrorDict]);
    } else if (success) {
        success();
    }
    
}

+ (void)validateShareCodeField:(UITextField *)shareCodeField
                     onSuccess:(ValidationSuccessBlock)success
                     onFailure:(ValidationFailureBlock)failure
{
    BOOL isValid = YES;
    
    if (![self validateShareCodeField:shareCodeField]) {
        isValid = NO;
    }
    
    if (!isValid && failure) {
        failure([self validationErrorDict]);
    } else if (success) {
        success();
    }
}

#pragma mark - Other actions

/**
 *  Clean the validation error string
 */
+ (void)cleanValidationErrorDict
{
    [self setValidationErrorDict:[@{} mutableCopy]];
}

+ (void)setErrorTitle:(NSString *)errorTitle andMessage:(NSString *)message
{
    [[self validationErrorDict] setObject:errorTitle forKey:kValidationErrorTitle];
    [[self validationErrorDict] setObject:message forKey:kValidationErrorMessage];
}

@end
