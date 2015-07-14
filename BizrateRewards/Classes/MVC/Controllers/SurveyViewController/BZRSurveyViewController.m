//
//  BZRSurveyViewController.m
//  BizrateRewards
//
//  Created by Eugenity on 27.06.15.
//  Copyright (c) 2015 Connexity. All rights reserved.
//

#import "BZRSurveyViewController.h"

#import "BZRDataManager.h"

#import "BZRSurvey.h"

@interface BZRSurveyViewController ()<UIWebViewDelegate>

@property (weak, nonatomic) IBOutlet UIWebView *surveyWebView;

@property (strong, nonatomic) BZRSurvey *currentSurvey;

@property (strong, nonatomic) BZRDataManager *dataManager;

@end

@implementation BZRSurveyViewController

#pragma mark - Accessors

- (BZRDataManager *)dataManager
{
    if (!_dataManager) {
        _dataManager = [BZRDataManager sharedInstance];
    }
    return _dataManager;
}

#pragma mark - View Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self getSurvey];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

#pragma mark - Actions

- (void)getSurvey
{
    WEAK_SELF;
    [BZRReachabilityHelper checkConnectionOnSuccess:^{
        [MBProgressHUD showHUDAddedTo:weakSelf.view animated:YES];
        [weakSelf.dataManager getClientCredentialsOnSuccess:^(BOOL success, NSError *error, NSInteger responseStatusCode) {
            if (success) {
                [weakSelf.dataManager getSurveyWithResult:^(BOOL success, BZRSurvey *survey, NSError *error) {
                    [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:YES];
                    weakSelf.currentSurvey = survey;
                    [weakSelf loadSurveyInWebView];
                }];
            } else {
                [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:YES];
            }
        }];
    } failure:^{
        ShowAlert(InternetIsNotReachableString);
    }];
}

- (void)loadSurveyInWebView
{
    NSURLRequest *surveyRequest = [NSURLRequest requestWithURL:self.currentSurvey.surveyLink];
    [self.surveyWebView loadRequest:surveyRequest];
}

#pragma mark - UIWebViewDelegate

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    //TODO: parse url here
    NSURL *url = request.URL;
    NSLog(@"url %@", url);
    return YES;
}

@end
