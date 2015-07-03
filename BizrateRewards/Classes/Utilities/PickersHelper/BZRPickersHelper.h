//
//  BZRPickersHelper.h
//  BizrateRewards
//
//  Created by Eugenity on 02.07.15.
//  Copyright (c) 2015 ThinkMobiles. All rights reserved.
//

typedef void(^DateResult)(NSDate *dateOfBirth, BOOL isOlderThirteen);
typedef void(^GenderResult)(BOOL isMale, NSString *genderString);

typedef void(^AnimaionCompletionBlock)(BOOL isExpanded, UIView *pickerView);

@interface BZRPickersHelper : NSObject

- (instancetype)initWithParentView:(UIView *)parentView;

- (void)showGenderPickerWithResult:(GenderResult)result withAnimationCompletion:(AnimaionCompletionBlock)animationCompletion;
- (void)showBirthDatePickerWithResult:(DateResult)result withAnimationCompletion:(AnimaionCompletionBlock)animationCompletion;

@end
