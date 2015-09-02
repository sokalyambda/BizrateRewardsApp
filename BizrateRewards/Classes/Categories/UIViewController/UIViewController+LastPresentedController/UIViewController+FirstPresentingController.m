//
//  UIViewController+LastPresentedController.m
//  Bizrate Rewards
//
//  Created by Eugenity on 02.09.15.
//  Copyright (c) 2015 Connexity. All rights reserved.
//

#import "UIViewController+FirstPresentingController.h"

@implementation UIViewController (FirstPresentingController)

- (UIViewController *)firstPresentingController
{
    UIViewController *controller = self.presentingViewController;
    UIViewController *lastController;
    while (controller) {
        lastController = controller;
        controller = controller.presentingViewController;
    }
    return lastController;
}

@end
