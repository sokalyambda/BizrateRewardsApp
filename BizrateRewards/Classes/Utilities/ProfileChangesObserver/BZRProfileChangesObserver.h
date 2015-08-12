//
//  BZRProfileChangesObserver.h
//  BizrateRewards
//
//  Created by Eugenity on 11.08.15.
//  Copyright (c) 2015 Connexity. All rights reserved.
//

typedef void(^ProfileChangedBlock)(BOOL isChanged);

@interface BZRProfileChangesObserver : NSObject

- (instancetype)initWithFirstNameField:(UITextField *)firstNameField
                      andLastNameField:(UITextField *)lastNameField
                         andEmailField:(UITextField *)emailField
                        andGenderField:(UITextField *)genderField
                   andDateOfBirthField:(UITextField *)dateOfBirthField;

- (void)observeProfileChangesWithBlock:(ProfileChangedBlock)profileChangedBlock;

@end
