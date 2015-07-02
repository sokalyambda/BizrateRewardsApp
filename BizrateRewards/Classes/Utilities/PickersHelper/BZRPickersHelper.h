//
//  BZRPickersHelper.h
//  BizrateRewards
//
//  Created by Eugenity on 02.07.15.
//  Copyright (c) 2015 ThinkMobiles. All rights reserved.
//

typedef void(^Completion)(void);
typedef void(^AnimationCompletion)(void);

@interface BZRPickersHelper : NSObject

- (void)showCommonPickerViewInView:(UIView *)view withCompletion:(Completion)completion;
- (void)showBirthDatePickerInView:(UIView *)view withCompletion:(Completion)completion;

@end
