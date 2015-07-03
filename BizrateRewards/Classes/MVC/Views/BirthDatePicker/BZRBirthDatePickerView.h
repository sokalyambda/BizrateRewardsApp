//
//  BZRDatePickerHolder.h
//  BizrateRewards
//
//  Created by Eugenity on 30.06.15.
//  Copyright (c) 2015 ThinkMobiles. All rights reserved.
//

@protocol BZRBirthDatePickerDelegate;

@interface BZRBirthDatePickerView : UIView

@property (weak, nonatomic) id<BZRBirthDatePickerDelegate> delegate;

@end

@protocol BZRBirthDatePickerDelegate <NSObject>

@optional
- (void)birthPickerViewWillDismiss:(BZRBirthDatePickerView *)datePickerView withChosenDate:(NSDate *)date;

@end
