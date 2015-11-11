//
//  BZRRedeemPointsController.m
//  Bizrate Rewards
//
//  Created by Eugenity on 23.10.15.
//  Copyright © 2015 Connexity. All rights reserved.
//

#import "BZRRedeemPointsController.h"

@interface BZRRedeemPointsController ()<UIWebViewDelegate>

@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation BZRRedeemPointsController

#pragma mark - View Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self loadSurveyInWebView];
}

#pragma mark - Actions

/**
 *  Load redeem points request web view.
 */
- (void)loadSurveyInWebView
{
    NSURLRequest *surveyRequest = [NSURLRequest requestWithURL:self.currentRedemptionURL];
    [self.webView loadRequest:surveyRequest];
}

/**
 *  Customize navigation bar appearance
 */
- (void)customizeNavigationItem
{
    [super customizeNavigationItem];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    self.navigationItem.title = LOCALIZED(@"Redeem Your Points");
    self.navigationItem.hidesBackButton = YES;
}

#pragma mark - UIWebViewDelegate

/**
 *  Detecting whether current survey has been completed.
 *
 */
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSString *urlString = request.URL.absoluteString;
    
    DLog(@"URL string is %@", urlString);
    
    return YES;
}

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
