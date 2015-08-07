//
//  MFMailComposeViewController+Styles.m
//  BizrateRewards
//
//  Created by Eugenity on 07.08.15.
//  Copyright (c) 2015 Connexity. All rights reserved.
//

#import "MFMailComposeViewController+Styles.h"

@implementation MFMailComposeViewController (Styles)

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (UIViewController *)childViewControllerForStatusBarStyle
{
    return nil;
}

@end
