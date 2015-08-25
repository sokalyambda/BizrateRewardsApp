//
//  BZRPickersHelper.h
//  BizrateRewards
//
//  Created by Eugenity on 02.07.15.
//  Copyright (c) 2015 Connexity. All rights reserved.
//

typedef void(^DateResult)(NSDate *dateOfBirth);
typedef void(^GenderResult)(NSString *genderString);

@class BZREditProfileContainerController;

@interface BZRPickersHelper : NSObject

//Parent view
@property (strong, nonatomic) UIView *parentView;

- (instancetype)initWithContainerController:(BZREditProfileContainerController *)container;

- (void)showGenderPickerWithResult:(GenderResult)result;
- (void)showBirthDatePickerWithResult:(DateResult)result;

@end
