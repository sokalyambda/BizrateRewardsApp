//
//  Validator.m
//  CarusselSalesTool
//
//  Created by Eugenity on 26.05.15.
//  Copyright (c) 2015 Connexity. All rights reserved.
//

#import "BZRValidator.h"
#import "BZRCommonDateFormatter.h"

#import "UIView+Shaking.h"
#import "UIView+Flashable.h"

#import "BZRAuthorizationField.h"
#import "BZREditProfileField.h"

static const NSInteger kMinPasswordSymbols = 8.f;
static const NSInteger kMaxPasswordSymbols = 16.f;

static NSString *const kEmailErrorImageName = @"email_icon_error";
static NSString *const kPasswordErrorImageName = @"password_icon_error";

@implementation BZRValidator

#pragma mark - Init & Lifecycle

+ (BZRValidator *)sharedValidator
{
    static BZRValidator *validator = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        validator = [[self alloc] init];
    });
    
    return validator;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.validationErrorString = [NSMutableString string];
    }
    return self;
}

#pragma mark - Validation auth actions

- (BOOL)validateEmailField:(UITextField *)emailField
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    
    if ([emailTest evaluateWithObject:emailField.text]) {
        return YES;
    } else {
        [self.validationErrorString appendString:NSLocalizedString(@"Email is incorrect. Check it\n", nil)];
        [emailField shakeView];
        
        if ([emailField isKindOfClass:[BZRAuthorizationField class]]) {
            ((BZRAuthorizationField *)emailField).errorImageName = kEmailErrorImageName;
        } else if ([emailField isKindOfClass:[BZREditProfileField class]]) {
            ((BZREditProfileField *)emailField).validationFailed = YES;
        }
        
        return NO;
    }
}

- (BOOL)validatePasswordField:(UITextField *)passwordField
{
    BOOL isValid = NO;
    if (passwordField.text.length && passwordField.text.length >= kMinPasswordSymbols && passwordField.text.length <= kMaxPasswordSymbols) {
        isValid = YES;
    } else {
        [passwordField shakeView];
        
        if ([passwordField isKindOfClass:[BZRAuthorizationField class]]) {
            ((BZRAuthorizationField *)passwordField).errorImageName = kPasswordErrorImageName;
        } else if ([passwordField isKindOfClass:[BZREditProfileField class]]) {
            ((BZREditProfileField *)passwordField).validationFailed = YES;
        }
        
        [self.validationErrorString appendString:NSLocalizedString(@"Invalid password. Password must consist of 8 to 16 characters\n", nil)];
    }
    return isValid;
}

- (BOOL)validateEmailField:(UITextField *)emailField andPasswordField:(UITextField *)passwordField
{
    BOOL isValid = NO;
    isValid = [self validateEmailField:emailField] && [self validatePasswordField:passwordField];
    return isValid;
}

- (BOOL)validateFirstNameField:(UITextField *)firstNameField
                 lastNameField:(UITextField *)lastNameField
                    emailField:(UITextField *)emailField
              dateOfBirthField: (UITextField *)dateOfBirthField
                   genderField: (UITextField *)genderField
{
    NSCharacterSet *alphaSet = [NSCharacterSet alphanumericCharacterSet];
    
    BOOL isFirstNameValid = [[firstNameField.text stringByTrimmingCharactersInSet:alphaSet] isEqualToString:@""] && firstNameField.text.length;
    
    BOOL isLastNameValid = [[lastNameField.text stringByTrimmingCharactersInSet:alphaSet] isEqualToString:@""] && lastNameField.text.length;
    
//    NSDate *now = [NSDate date];
//    NSDate *birthDate = [[BZRCommonDateFormatter commonDateFormatter] dateFromString:dateOfBirthField.text];
//
//    NSDateComponents* ageComponents = [[NSCalendar currentCalendar]
//                                       components:NSCalendarUnitYear
//                                       fromDate:birthDate
//                                       toDate:now
//                                       options:0.f];
//    NSInteger age = [ageComponents year];
//    
//    BOOL isBirthDateValid = age > 13.f && dateOfBirthField.text.length;
    
    if (!isFirstNameValid) {
        [firstNameField shakeView];
        
        if ([firstNameField isKindOfClass:[BZREditProfileField class]]) {
            ((BZREditProfileField *)firstNameField).validationFailed = YES;
        }
        
        [self.validationErrorString appendString:NSLocalizedString(@"First name can only contain alphanumeric characters.\n", nil)];
        return NO;
    }
    if (!isLastNameValid) {
        [lastNameField shakeView];
        
        if ([lastNameField isKindOfClass:[BZREditProfileField class]]) {
            ((BZREditProfileField *)lastNameField).validationFailed = YES;
        }
        
        [self.validationErrorString appendString:NSLocalizedString(@"Last name can only contain alphanumeric characters.\n", nil)];
        return NO;
    }
    if (![self validateEmailField:emailField]) {
        return NO;
    }
    if (![self isBirthDateFromFieldValid:dateOfBirthField]) {
        [dateOfBirthField shakeView];
        
        if ([dateOfBirthField isKindOfClass:[BZREditProfileField class]]) {
            ((BZREditProfileField *)dateOfBirthField).validationFailed = YES;
        }
        
        [self.validationErrorString appendString:NSLocalizedString(@"You must be of age 13 or older to register\n", nil)];
        return NO;
    }
    if (!genderField.text.length) {
        [genderField shakeView];
        
        if ([genderField isKindOfClass:[BZREditProfileField class]]) {
            ((BZREditProfileField *)genderField).validationFailed = YES;
        }
        
        [self.validationErrorString appendString:NSLocalizedString(@"Select your gender\n", nil)];
        return NO;
    }
    return YES;
}

- (BOOL)validateCheckboxes:(NSArray *)checkboxes
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

- (BOOL)isBirthDateFromFieldValid:(UITextField *)dateField
{
    NSDate *now = [NSDate date];
    NSDate *birthDate = [[BZRCommonDateFormatter commonDateFormatter] dateFromString:dateField.text];
    
    if (!birthDate) {
        return NO;
    }
    
    NSDateComponents* ageComponents = [[NSCalendar currentCalendar]
                                       components:NSCalendarUnitYear
                                       fromDate:birthDate
                                       toDate:now
                                       options:0.f];
    NSInteger age = [ageComponents year];
    
    return age > 13.f;
}

#pragma mark - Other actions

- (void)cleanValidationErrorString
{
    self.validationErrorString = [@"" mutableCopy];
}

@end
