//
//  BZRPageContentController.m
//  BizrateRewards
//
//  Created by Eugenity on 23.06.15.
//  Copyright (c) 2015 ThinkMobiles. All rights reserved.
//

#import "BZRPageContentController.h"

@interface BZRPageContentController ()

@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;

@end

@implementation BZRPageContentController

#pragma mark - View Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self updateCurrentImageView];
}

#pragma mark - Actions

- (void)updateCurrentImageView
{
    self.backgroundImageView.image = [UIImage imageNamed:self.imageName];
}

@end
