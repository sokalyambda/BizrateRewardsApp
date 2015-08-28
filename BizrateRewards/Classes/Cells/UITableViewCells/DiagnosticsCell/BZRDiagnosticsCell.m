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
    self.eventTypeLabel.text = locationEvent.eventType == BZRLocationEventTypeEntry ? LOCALIZED(@"ENTRY") : LOCALIZED(@"EXIT");
    self.locationLabel.text = [NSString stringWithFormat:@"%d", locationEvent.locationId];
    self.latitudeLabel.text = [NSString stringWithFormat:@"%f", locationEvent.coordinate.latitude];
    self.longitudeLabel.text = [NSString stringWithFormat:@"%f", locationEvent.coordinate.longitude];
    self.eycCustomerIdLabel.text = locationEvent.customerId;
    
    self.createdLabel.text = locationEvent.creationDateString;
}

@end
