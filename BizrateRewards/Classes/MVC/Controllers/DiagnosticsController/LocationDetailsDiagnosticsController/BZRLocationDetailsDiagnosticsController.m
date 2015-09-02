//
//  BZRLocationDetailsDiagnosticsController.m
//  Bizrate Rewards
//
//  Created by Eugenity on 28.08.15.
//  Copyright (c) 2015 Connexity. All rights reserved.
//

#import "BZRLocationDetailsDiagnosticsController.h"

#import "BZRLocationEvent.h"

@interface BZRLocationDetailsDiagnosticsController ()<UIWebViewDelegate>

@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation BZRLocationDetailsDiagnosticsController

#pragma mark - View Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self loadRequestInWebView];
    [self customizeNavigationItem];
}

#pragma mark - Actions
     
- (void)loadRequestInWebView
{
    NSString *token = [BZRStorageManager sharedStorage].userToken.accessToken;
    
    if (token.length) {
        NSURL *currentLocationURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@?access_token=%@", self.currentLocationEvent.locationLink, token]];
        NSURLRequest *currentRequest = [NSURLRequest requestWithURL:currentLocationURL];
        [self.webView loadRequest:currentRequest];
    }
    
}

- (void)customizeNavigationItem
{
    self.navigationItem.title = LOCALIZED(@"Location Details");
}
     
#pragma mark - UIWebViewDelegate

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [BZRAlertFacade showFailureResponseAlertWithError:error forController:self andCompletion:nil];
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
}

@end
