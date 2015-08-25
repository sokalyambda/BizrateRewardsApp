//
//  BZRAuthorizationField.m
//  BizrateRewards
//
//  Created by Eugenity on 08.07.15.
//  Copyright (c) 2015 Connexity. All rights reserved.
//

#import "BZRAuthorizationField.h"

// blue 0x12a9d6
// gray 0x9097a3
// red  0xf15364
@implementation BZRAuthorizationField

#pragma mark - Accessors

- (UIColor *)getCurrentColor
{
    return self.isFirstResponder ? UIColorFromRGB(0x12a9d6) : UIColorFromRGB(0x9097a3);
}

- (NSString *)getCurrentImageName
{
    return self.isFirstResponder ? self.activeImageName : self.notActiveImageName;
}

- (void)setNotActiveImageName:(NSString *)notActiveImageName
{
    _notActiveImageName = notActiveImageName;
    [self setupTextFieldAppearance];
}

- (void)setErrorImageName:(NSString *)errorImageName
{
    _errorImageName = errorImageName;
    [self setupErrorFieldAppearance];
}

#pragma mark - Actions

- (void)setupTextFieldAppearance
{
    self.textColor = [self getCurrentColor];
    self.attributedPlaceholder = [[NSAttributedString alloc] initWithString:self.placeholder attributes:@{NSForegroundColorAttributeName:UIColorFromRGB(0xC8C8C8)}];
    self.imageName = [self getCurrentImageName];
}

- (void)setupErrorFieldAppearance
{
    self.textColor = UIColorFromRGB(0xf15364);
    self.attributedPlaceholder = [[NSAttributedString alloc] initWithString:self.placeholder attributes:@{NSForegroundColorAttributeName:UIColorFromRGB(0xf15364)}];
    self.imageName = self.errorImageName;
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
