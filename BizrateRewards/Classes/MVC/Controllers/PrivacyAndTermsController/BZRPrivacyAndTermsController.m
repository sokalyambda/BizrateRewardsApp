//
//  BZRPrivacyAndTermsController.m
//  BizrateRewards
//
//  Created by Eugenity on 23.06.15.
//  Copyright (c) 2015 Connexity. All rights reserved.
//

#import "BZRPrivacyAndTermsController.h"

#import "BZRSerialViewConstructor.h"

@interface BZRPrivacyAndTermsController ()<UIWebViewDelegate>

@property (weak, nonatomic) IBOutlet UIWebView *webView;

@property (strong, nonatomic) UIBarButtonItem *closeButton;

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
    [self customizeNavigationItem];
}

#pragma mark - Actions

- (void)updateWebViewInformation
{
    NSURLRequest *currentRequest = [NSURLRequest requestWithURL:self.currentURL];
    [self.webView loadRequest:currentRequest];
}

- (void)customizeNavigationItem
{
    //show navigation bar
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
    
    //create custom 'Done' button
    self.closeButton = [BZRSerialViewConstructor customButtonWithTitle:LOCALIZED(@"Close") forController:self withAction:@selector(closeClicik:)];
    
    //set right bar button item
    self.navigationItem.rightBarButtonItem = self.closeButton;
    
    //remove back button (custom and system)
    self.navigationItem.leftBarButtonItem = nil;
    self.navigationItem.hidesBackButton = YES;
    
}

- (void)closeClicik:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
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
