//
//  BZRSerialViewConstructor.m
//  BizrateRewards
//
//  Created by Eugenity on 15.07.15.
//  Copyright (c) 2015 Connexity. All rights reserved.
//

#import "BZRSerialViewConstructor.h"
#import "BZRBaseNavigationController.h"

static NSString *const kBackArrowImageName = @"back_arrow";

@implementation BZRSerialViewConstructor

+ (UIBarButtonItem *)backButtonForController:(UIViewController *)controller
{
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:kBackArrowImageName] style:UIBarButtonItemStylePlain target:controller action:@selector(popViewControllerAnimated:)];
    return backButton;
}

@end
