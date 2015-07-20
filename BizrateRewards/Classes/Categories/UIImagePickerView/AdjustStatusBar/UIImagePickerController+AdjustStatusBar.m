//
//  UIImagePickerController+AdjustStatusBar.m
//  BizrateRewards
//
//  Created by Eugenity on 19.07.15.
//  Copyright (c) 2015 Connexity. All rights reserved.
//

#import "UIImagePickerController+AdjustStatusBar.h"

@implementation UIImagePickerController (AdjustStatusBar)

- (BOOL)prefersStatusBarHidden
{
    return NO;
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

@end
