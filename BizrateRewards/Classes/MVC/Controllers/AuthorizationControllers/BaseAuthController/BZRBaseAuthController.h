//
//  BZRBaseAuthController.h
//  BizrateRewards
//
//  Created by Eugenity on 23.06.15.
//  Copyright (c) 2015 ThinkMobiles. All rights reserved.
//

#import "BZRValidator.h"

@interface BZRBaseAuthController : UIViewController

@property (strong, nonatomic) UITextField *activeField;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (strong, nonatomic) BZRValidator *validator;

@end
