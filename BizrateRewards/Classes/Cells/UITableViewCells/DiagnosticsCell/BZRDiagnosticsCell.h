//
//  BZRDiagnosticsCell.h
//  Bizrate Rewards
//
//  Created by Eugenity on 27.08.15.
//  Copyright (c) 2015 Connexity. All rights reserved.
//

#import "BZRZeroInsetsSeparatorCell.h"

@class BZRLocationEvent;
@protocol BZRDiagnosticsCellDelegate;

@interface BZRDiagnosticsCell : BZRZeroInsetsSeparatorCell

@property (weak, nonatomic) id<BZRDiagnosticsCellDelegate> delegate;

- (void)configureWithLocationEvent:(BZRLocationEvent *)locationEvent;

@end

@protocol BZRDiagnosticsCellDelegate <NSObject>

@optional
- (void)diagnosticsCellDidTapLocationLabel:(BZRDiagnosticsCell *)cell;

@end
