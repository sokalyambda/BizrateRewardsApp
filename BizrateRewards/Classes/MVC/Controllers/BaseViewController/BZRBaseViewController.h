//
//  BZRBaseViewController.h
//  BizrateRewards
//
//  Created by Eugenity on 15.07.15.
//  Copyright (c) 2015 Connexity. All rights reserved.
//

typedef void(^RedirectionBlock)(NSError *error);

@interface BZRBaseViewController : UIViewController

- (void)customizeNavigationItem;

@property (copy, nonatomic, readonly) RedirectionBlock redirectionBlock;

@end
