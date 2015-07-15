//
//  Validator.h
//  CarusselSalesTool
//
//  Created by Eugenity on 26.05.15.
//  Copyright (c) 2015 Connexity. All rights reserved.
//

@interface BZRValidator : NSObject

@property (strong, nonatomic) NSMutableString *validationErrorString;

+ (BZRValidator *)sharedValidator;

- (BOOL)validateEmailField:(UITextField *)emailField;
- (BOOL)validateEmailField:(UITextField *)emailField andPasswordField:(UITextField *)passwordField;
- (BOOL)validateFirstNameField:(UITextField *)firstNameField lastNameField:(UITextField *)lastNameField emailField:(UITextField *)emailField dateOfBirthField: (UITextField *)dateOfBirthField genderField: (UITextField *)genderField;
- (void)cleanValidationErrorString;

- (BOOL)validateCheckboxes:(NSArray *)checkboxes;

@end
