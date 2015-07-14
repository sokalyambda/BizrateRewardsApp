//
//  AlertMessageService.h
//  Pseudo
//
//  Created by Eugenity on 20.05.15.
//  Copyright (c) 2015 Connexity. All rights reserved.
//

@interface BZRAlertMessageService : NSObject

void ShowTitleErrorAlert(NSString *title, NSError *error);
void ShowErrorAlert(NSError *error);

void ShowTitleAlert(NSString *title, NSString *message);
void ShowAlert(NSString *message);

@end
