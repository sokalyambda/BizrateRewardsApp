//
//  BZRSurveyViewController.m
//  BizrateRewards
//
//  Created by Eugenity on 27.06.15.
//  Copyright (c) 2015 Connexity. All rights reserved.
//

#import "BZRSurveyViewController.h"
#import "BZRFinishSurveyController.h"

#import "BZRSurvey.h"

#import "NSString+ContainsString.h"

static NSString *const kFinishSurveyString = @"SaveButton";

static NSString *const kSurveyID = @"Survey ID";

@interface BZRSurveyViewController ()<UIWebViewDelegate>

@property (weak, nonatomic) IBOutlet UIWebView *surveyWebView;

@end

@implementation BZRSurveyViewController

#pragma mark - View Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self loadSurveyInWebView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setupNavigationBar];
}

#pragma mark - Actions

/**
 *  Load current survey in web view.
 */
- (void)loadSurveyInWebView
{
    NSURLRequest *surveyRequest = [NSURLRequest requestWithURL:self.currentSurvey.surveyLink];
    [self.surveyWebView loadRequest:surveyRequest];
    
    [BZRMixpanelService trackEventWithType:BZRMixpanelEventSurveyViewed propertyValue:[NSString stringWithFormat:@"%ld", (long)self.currentSurvey.surveyId]];
}

/**
 *  Customize navigation bar appearance
 */
- (void)setupNavigationBar
{
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    self.navigationItem.title = NSLocalizedString(self.currentSurvey.surveyName, nil);
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
    
    if ([urlString containsString:kFinishSurveyString]) {
        
        BZRFinishSurveyController *controller = [self.storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([BZRFinishSurveyController class])];
        controller.passedSurvey = self.currentSurvey;
        [self.navigationController pushViewController:controller animated:YES];
    }
    
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
    ShowFailureResponseAlertWithError(error);
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
}

@end
