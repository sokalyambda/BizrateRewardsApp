//
//  BZRAlertFacade.h
//  BizrateRewards
//
//  Created by Eugenity on 03.08.15.
//  Copyright (c) 2015 Connexity. All rights reserved.
//

@interface BZRAlertFacade : NSObject

+ (void)showGlobalGeolocationPermissionsAlertWithCompletion:(void(^)(UIAlertAction *action, BOOL isCanceled))completion;

@end
