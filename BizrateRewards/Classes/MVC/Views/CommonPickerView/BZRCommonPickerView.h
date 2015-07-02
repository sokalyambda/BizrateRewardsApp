//
//  BZRCommonPickerView.h
//  BizrateRewards
//
//  Created by Eugenity on 02.07.15.
//  Copyright (c) 2015 ThinkMobiles. All rights reserved.
//

@protocol BZRCommonPickerViewDelegate;

@interface BZRCommonPickerView : UIView

@property (weak, nonatomic) id<BZRCommonPickerViewDelegate> delegate;

@end

@protocol BZRCommonPickerViewDelegate <NSObject>

@optional
- (void)commonPickerViewWillDissmiss:(BZRCommonPickerView *)commonPickerView;

@end