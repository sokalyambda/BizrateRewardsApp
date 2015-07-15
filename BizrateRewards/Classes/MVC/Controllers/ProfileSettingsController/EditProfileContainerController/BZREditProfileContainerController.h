//
//  BZREditProfileContainerController.h
//  BizrateRewards
//
//  Created by Eugenity on 02.07.15.
//  Copyright (c) 2015 Connexity. All rights reserved.
//

@class BZREditProfileField;

@interface BZREditProfileContainerController : UITableViewController

@property (weak, nonatomic) IBOutlet BZREditProfileField *firstNameField;
@property (weak, nonatomic) IBOutlet BZREditProfileField *lastNameField;
@property (weak, nonatomic) IBOutlet BZREditProfileField *emailField;
@property (weak, nonatomic) IBOutlet BZREditProfileField *dateOfBirthField;
@property (weak, nonatomic) IBOutlet BZREditProfileField *genderField;

@property (assign, nonatomic) CGRect savedKeyboardRect;

- (void)adjustTableViewInsetsWithPresentedRect:(CGRect)rect;

@end
