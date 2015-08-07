//
//  ViewController.h
//  OfferBeamSDKTest
//
//  Created by Praveen Kumar on 4/2/15.
//  Copyright (c) 2015 SymphonyEYC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OB_LocationServices.h"

@interface ViewController : UIViewController <OB_LocationServicesDelegate>
@property (weak, nonatomic) IBOutlet UILabel *memoryLabel;
@property (weak, nonatomic) IBOutlet UILabel *versionLabel;
@property (weak, nonatomic) IBOutlet UITextView *dataTextView;

@property (weak, nonatomic) IBOutlet UIImageView *logo;

@end

