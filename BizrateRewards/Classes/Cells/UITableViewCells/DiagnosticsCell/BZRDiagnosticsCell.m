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

#pragma mark - Lifecycle

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self commonInit];
}

#pragma mark - Actions

- (void)configureWithLocationEvent:(BZRLocationEvent *)locationEvent
{
    self.eventTypeLabel.text = locationEvent.eventType == BZRLocationEventTypeEntry ? LOCALIZED(@"ENTRY") : LOCALIZED(@"EXIT");
    
    if (locationEvent.locationId != 0) {
        self.locationLabel.text = [NSString stringWithFormat:@"%d", locationEvent.locationId];
    } else if (locationEvent.locationLink.length) {
        self.locationLabel.text = locationEvent.locationLink;
    } else {
        self.locationLabel.text = LOCALIZED(@"Unknown Location");
    }
    
    self.latitudeLabel.text = [NSString stringWithFormat:@"%f", locationEvent.coordinate.latitude];
    self.longitudeLabel.text = [NSString stringWithFormat:@"%f", locationEvent.coordinate.longitude];
    self.eycCustomerIdLabel.text = locationEvent.customerId;
    
    self.createdLabel.text = locationEvent.creationDateString;
}

- (void)commonInit
{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(locationLabelTapped)];
    [self.locationLabel addGestureRecognizer:tap];
}

- (void)locationLabelTapped
{
    if ([self.delegate respondsToSelector:@selector(diagnosticsCellDidTapLocationLabel:)]) {
        [self.delegate diagnosticsCellDidTapLocationLabel:self];
    }
}

@end
