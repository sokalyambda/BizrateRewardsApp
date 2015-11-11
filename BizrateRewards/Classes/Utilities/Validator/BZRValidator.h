//
//  Validator.h
//  CarusselSalesTool
//
//  Created by Eugenity on 26.05.15.
//  Copyright (c) 2015 Connexity. All rights reserved.
//

typedef void(^ValidationSuccessBlock)(void);
typedef void(^ValidationFailureBlock)(NSMutableDictionary *errorDict);

extern NSString *const kValidationErrorTitle;
extern NSString *const kValidationErrorMessage;

@interface BZRValidator : NSObject

+ (NSMutableDictionary *)validationErrorDict;
+ (void)setValidationErrorDict:(NSMutableDictionary *)validationErrorDict;


+ (void)validateEmailField:(UITextField *)emailField onSuccess:(ValidationSuccessBlock)success onFailure:(ValidationFailureBlock)failure;

+ (void)validateEmailField:(UITextField *)emailField andPasswordField:(UITextField *)passwordField onSuccess:(ValidationSuccessBlock)success onFailure:(ValidationFailureBlock)failure;

+ (void)validateFirstNameField:(UITextField *)firstNameField lastNameField:(UITextField *)lastNameField emailField:(UITextField *)emailField dateOfBirthField: (UITextField *)dateOfBirthField genderField: (UITextField *)genderField andCheckboxes:(NSArray *)checkboxes onSuccess:(ValidationSuccessBlock)success onFailure:(ValidationFailureBlock)failure;

+ (void)validateEmailField:(UITextField *)emailField andPasswordField:(UITextField *)passwordField andConfirmPasswordField:(UITextField *)confirmPassword onSuccess:(ValidationSuccessBlock)success onFailure:(ValidationFailureBlock)failure;

+ (void)validateShareCodeField:(UITextField *)shareCodeField
                     onSuccess:(ValidationSuccessBlock)success
                     onFailure:(ValidationFailureBlock)failure;

+ (void)cleanValidationErrorDict;

@end
