//
//  BZRPrivacyAndTermsController.m
//  BizrateRewards
//
//  Created by Eugenity on 23.06.15.
//  Copyright (c) 2015 ThinkMobiles. All rights reserved.
//

#import "BZRPrivacyAndTermsController.h"

@interface BZRPrivacyAndTermsController ()

@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation BZRPrivacyAndTermsController

#pragma mark - View Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self updateWebViewInformation];
}

#pragma mark - Actions

- (void)updateWebViewInformation
{
    NSURLRequest *currentRequest = [NSURLRequest requestWithURL:self.currentURL];
    [self.webView loadRequest:currentRequest];
}

@end
