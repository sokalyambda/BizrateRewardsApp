//
//  BZREditProfileFIeld.m
//  BizrateRewards
//
//  Created by Eugenity on 15.07.15.
//  Copyright (c) 2015 Connexity. All rights reserved.
//

#import "BZREditProfileField.h"

@implementation BZREditProfileField

#pragma mark - Lifecycle

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (void)commonInit
{
    [self setupTextFieldAppearance];
}

#pragma mark - Accessors

- (UIColor *)getCurrentColor
{
    return self.isFirstResponder ? UIColorFromRGB(0x12a9d6) : UIColorFromRGB(0x9097a3);
}

- (void)setValidationFailed:(BOOL)validationFailed
{
    _validationFailed = validationFailed;
    
    if (_validationFailed) {
        [self setupErrorFieldAppearance];
    } else {
        [self setupTextFieldAppearance];
    }
}

#pragma mark - Actions

- (void)setupTextFieldAppearance
{
    self.textColor = [self getCurrentColor];
    self.attributedPlaceholder = [[NSAttributedString alloc] initWithString:self.placeholder attributes:@{NSForegroundColorAttributeName:[UIColor lightGrayColor]}];
}

- (void)setupErrorFieldAppearance
{
    self.textColor = UIColorFromRGB(0xf15364);
    self.attributedPlaceholder = [[NSAttributedString alloc] initWithString:self.placeholder attributes:@{NSForegroundColorAttributeName:UIColorFromRGB(0xf15364)}];
}

#pragma mark - UIResponder

- (BOOL)becomeFirstResponder
{
    BOOL returnValue = [super becomeFirstResponder];
    if (returnValue) {
        [self setupTextFieldAppearance];
    }
    return returnValue;
}

- (BOOL)resignFirstResponder
{
    BOOL returnValue = [super resignFirstResponder];
    
    if (returnValue) {
        [self setupTextFieldAppearance];
    }
    return returnValue;
}

@end
