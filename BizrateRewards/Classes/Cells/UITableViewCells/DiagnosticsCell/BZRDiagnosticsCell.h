//
//  BZRDiagnosticsCell.h
//  Bizrate Rewards
//
//  Created by Eugenity on 27.08.15.
//  Copyright (c) 2015 Connexity. All rights reserved.
//

#import "BZRZeroInsetsSeparatorCell.h"

@class BZRLocationEvent;

@interface BZRDiagnosticsCell : BZRZeroInsetsSeparatorCell

- (void)configureWithLocationEvent:(BZRLocationEvent *)locationEvent;

@end
