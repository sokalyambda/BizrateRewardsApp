//
//  BZRSerialViewConstructor.h
//  BizrateRewards
//
//  Created by Eugenity on 15.07.15.
//  Copyright (c) 2015 Connexity. All rights reserved.
//

@interface BZRSerialViewConstructor : NSObject

+ (UIBarButtonItem *)backButtonForController:(UIViewController *)controller;

+ (UIBarButtonItem *)customDoneButtonForController:(UIViewController *)controller withAction:(SEL)action;

@end
