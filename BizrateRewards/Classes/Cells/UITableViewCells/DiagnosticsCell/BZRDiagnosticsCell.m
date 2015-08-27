//
//  BZRDiagnosticsCell.m
//  Bizrate Rewards
//
//  Created by Eugenity on 27.08.15.
//  Copyright (c) 2015 Connexity. All rights reserved.
//

#import "BZRDiagnosticsCell.h"

#import "BZRLocationEvent.h"

@interface BZRDiagnosticsCell ()

@property (weak, nonatomic) IBOutlet UILabel *localTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;
@property (weak, nonatomic) IBOutlet UILabel *eventTypeLabel;
@property (weak, nonatomic) IBOutlet UILabel *latitudeLabel;
@property (weak, nonatomic) IBOutlet UILabel *longitudeLabel;
@property (weak, nonatomic) IBOutlet UILabel *eycCustomerIdLabel;
@property (weak, nonatomic) IBOutlet UILabel *createdLabel;

@end

@implementation BZRDiagnosticsCell

#pragma mark - Actions

- (void)configureWithLocationEvent:(BZRLocationEvent *)locationEvent
{
    
}

@end
