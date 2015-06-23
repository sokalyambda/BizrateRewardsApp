//
//  BZRTutorialViewController.m
//  BizrateRewards
//
//  Created by Eugenity on 23.06.15.
//  Copyright (c) 2015 ThinkMobiles. All rights reserved.
//

#import "BZRBaseTutorialController.h"
#import "BZRPageViewController.h"
#import "BZRPageContentController.h"

@interface BZRBaseTutorialController ()<UIPageViewControllerDataSource>

@property (strong, nonatomic) BZRPageViewController *pageViewController;
@property (strong, nonatomic) NSArray *pageImagesNames;

@end

@implementation BZRBaseTutorialController

#pragma mark - Accessors

- (NSArray *)pageImagesNames
{
#warning Incorrect images names! Need to change it!
    if (!_pageImagesNames) {
        _pageImagesNames = @[@"", @"", @""];
    }
    return _pageImagesNames;
}

#pragma mark - View Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupPageViewController];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
}

#pragma mark - Actions

- (void)setupPageViewController
{
    self.pageViewController = [self.storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([BZRPageViewController class])];
    
    self.pageViewController.dataSource = self;
    
    BZRPageContentController *pageContentController = [self viewControllerAtIndex:0];
    
    NSArray *viewControllers = @[pageContentController];
    
    [self.pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];
    
    [self addChildViewController:self.pageViewController];
    [self.view addSubview:self.pageViewController.view];
    [self.pageViewController didMoveToParentViewController:self];
}

- (BZRPageContentController *)viewControllerAtIndex:(NSUInteger)index
{
    if ((![self.pageImagesNames count]) || (index >= [self.pageImagesNames count])) {
        return nil;
    }
    
    BZRPageContentController *pageContentController = [self.storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([BZRPageContentController class])];
    
    pageContentController.index = index;
    pageContentController.imageName = self.pageImagesNames[index];
    
    return pageContentController;
}

#pragma mark - UIPageViewControllerDataSource

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    NSUInteger index = ((BZRPageContentController *)viewController).index;
    
    if ((index == 0) || (index == NSNotFound)) {
        return nil;
    }
    
    index--;
    
    return [self viewControllerAtIndex:index];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    NSUInteger index = [(BZRPageContentController *)viewController index];
    
    if (index == NSNotFound) {
        return nil;
    }
    
    index++;
    
    if (index == [self.pageImagesNames count]) {
        return nil;
    }
    
    return [self viewControllerAtIndex:index];
}

- (NSInteger)presentationCountForPageViewController:(UIPageViewController *)pageViewController
{
    return [self.pageImagesNames count];
}

- (NSInteger)presentationIndexForPageViewController:(UIPageViewController *)pageViewController {
    // The selected item reflected in the page indicator.
    return 0;
}

@end
