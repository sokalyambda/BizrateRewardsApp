//
//  BZRValidateShareCodeRequest.h
//  Bizrate Rewards
//
//  Created by Myroslava Polovka on 4/13/16.
//  Copyright © 2016 Connexity. All rights reserved.
//

#import "BZRNetworkRequest.h"

@interface BZRValidateShareCodeRequest : BZRNetworkRequest

- (instancetype)initWithShareCode:(NSString *)shareCode;

@end
