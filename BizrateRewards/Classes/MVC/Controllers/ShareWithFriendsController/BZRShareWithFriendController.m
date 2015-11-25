//
//  BZRShareWithFriendController.m
//  Bizrate Rewards
//
//  Created by Myroslava Polovka on 11/25/15.
//  Copyright © 2015 Connexity. All rights reserved.
//

#import "BZRShareWithFriendController.h"

@interface BZRShareWithFriendController ()

@property (weak, nonatomic) IBOutlet UILabel *shareCodeLabel;

@end

@implementation BZRShareWithFriendController

#pragma mark - View Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.shareCodeLabel.text = self.shareCode;
}

#pragma mark - Actions

/**
 *  Customize navigation bar appearance
 */
- (void)customizeNavigationItem
{
    [super customizeNavigationItem];
    //set navigation title
    self.navigationItem.title = LOCALIZED(@"Share Code");
    
    //Show navigation bar
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

@end
