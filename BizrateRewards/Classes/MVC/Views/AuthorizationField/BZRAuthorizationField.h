//
//  BZRAuthorizationField.h
//  BizrateRewards
//
//  Created by Eugenity on 08.07.15.
//  Copyright (c) 2015 ThinkMobiles. All rights reserved.
//

#import "BZRLeftImageTextField.h"

@interface BZRAuthorizationField : BZRLeftImageTextField

@property (strong, nonatomic) NSString *activeImageName;
@property (strong, nonatomic) NSString *notActiveImageName;

@property (strong, nonatomic) NSString *errorImageName;

@end
