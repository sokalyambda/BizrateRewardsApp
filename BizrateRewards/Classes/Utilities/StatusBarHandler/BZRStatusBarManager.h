//
//  BZRStatusBarHandler.h
//  BizrateRewards
//
//  Created by Eugenity on 19.07.15.
//  Copyright (c) 2015 Connexity. All rights reserved.
//

@interface BZRStatusBarManager : NSObject

+ (BZRStatusBarManager *)sharedManager;

- (void)addCustomStatusBarView;

- (void)hideCustomStatusBarView;
- (void)showCustomStatusBarView;

@end
