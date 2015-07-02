//
//  BZRCommonPickerView.h
//  BizrateRewards
//
//  Created by Eugenity on 02.07.15.
//  Copyright (c) 2015 ThinkMobiles. All rights reserved.
//

@protocol BZRCommonPickerViewDelegate;
@class BZRPickerHolder;

@interface BZRCommonPickerView : UIView

@property (strong, nonatomic) NSArray *pickerComponentsArray;

@property (weak, nonatomic) id<BZRCommonPickerViewDelegate> delegate;

@end

@protocol BZRCommonPickerViewDelegate <NSObject>

@optional
- (void)commonPickerViewWillDismiss:(BZRCommonPickerView *)commonPickerView;

@end