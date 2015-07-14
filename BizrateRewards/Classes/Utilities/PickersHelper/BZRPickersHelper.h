//
//  BZRPickersHelper.h
//  BizrateRewards
//
//  Created by Eugenity on 02.07.15.
//  Copyright (c) 2015 Connexity. All rights reserved.
//

typedef void(^DateResult)(NSDate *dateOfBirth, BOOL isOlderThirteen);
typedef void(^GenderResult)(BOOL isMale, NSString *genderString);

@class BZREditProfileContainerController;

@interface BZRPickersHelper : NSObject

- (instancetype)initWithParentView:(UIView *)parentView andContainerController:(BZREditProfileContainerController *)container;

- (void)showGenderPickerWithResult:(GenderResult)result;
- (void)showBirthDatePickerWithResult:(DateResult)result;

@end
