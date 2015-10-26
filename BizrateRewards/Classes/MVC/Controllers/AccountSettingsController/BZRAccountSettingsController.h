//
//  BZRAccountSettingsController.h
//  BizrateRewards
//
//  Created by Eugenity on 27.06.15.
//  Copyright (c) 2015 Connexity. All rights reserved.
//

#import "BZRBaseViewController.h"

@interface BZRAccountSettingsController : BZRBaseViewController

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *containerHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *headerHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *spaceBetweenContainerBottomAndSignOutButtonTop;

@property (weak, nonatomic) IBOutlet UIButton *signOutButton;

- (void)signOut;

@end
