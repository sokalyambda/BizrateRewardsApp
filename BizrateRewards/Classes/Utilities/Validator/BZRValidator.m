//
//  Validator.m
//  CarusselSalesTool
//
//  Created by Eugenity on 26.05.15.
//  Copyright (c) 2015 ThinkMobiles. All rights reserved.
//

#import "BZRValidator.h"
#import "UIView+Shaking.h"

static const NSInteger kMinPasswordSymbols = 5;

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
        return NO;
    }
}

- (BOOL)validatePasswordField:(UITextField *)passwordField
{
    BOOL isValid = NO;
    if (passwordField.text.length && passwordField.text.length >= kMinPasswordSymbols) {
        isValid = YES;
    } else {
        [passwordField shakeView];
        [self.validationErrorString appendString:NSLocalizedString(@"Password is incorrect. Min length - 8 symbols\n", nil)];
    }
    return isValid;
}

- (BOOL)validateEmailField:(UITextField *)emailField andPasswordField:(UITextField *)passwordField
{
    BOOL isValid = NO;
    isValid = [self validateEmailField:emailField] && [self validatePasswordField:passwordField];
    return isValid;
}

#pragma mark - Other actions

- (void)cleanValidationErrorString
{
    self.validationErrorString = [@"" mutableCopy];
}

@end
