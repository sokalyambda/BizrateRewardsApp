//
//  Validator.h
//  CarusselSalesTool
//
//  Created by Eugenity on 26.05.15.
//  Copyright (c) 2015 ThinkMobiles. All rights reserved.
//

@interface BZRValidator : NSObject

@property (strong, nonatomic) NSMutableString *validationErrorString;

+ (BZRValidator *)sharedValidator;

- (BOOL)validateEmailField:(UITextField *)emailField;
- (BOOL)validateEmailField:(UITextField *)emailField andPasswordField:(UITextField *)passwordField;
- (void)cleanValidationErrorString;

@end
