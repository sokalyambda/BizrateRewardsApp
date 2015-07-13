//
//  BZRPrivacyAndTermsController.m
//  BizrateRewards
//
//  Created by Eugenity on 23.06.15.
//  Copyright (c) 2015 ThinkMobiles. All rights reserved.
//

#import "BZRPrivacyAndTermsController.h"

@interface BZRPrivacyAndTermsController ()<UIWebViewDelegate>

@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation BZRPrivacyAndTermsController

#pragma mark - View Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self updateWebViewInformation];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

#pragma mark - Actions

- (void)updateWebViewInformation
{
    NSURLRequest *currentRequest = [NSURLRequest requestWithURL:self.currentURL];
    [self.webView loadRequest:currentRequest];
}

#pragma mark - UIWebViewDelegate

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSURL *url = request.URL;
    NSLog(@"url %@", url);
    return YES;
}

@end
