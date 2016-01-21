//
//  ISEScrollerViewController.m
//  iOSExample
//
//  Created by William Boles on 21/01/2016.
//  Copyright © 2016 Boles. All rights reserved.
//

#import "ISEScrollerViewController.h"

#import <InsightfulPager/ISPPagingViewController.h>

#import "ISEPageViewController.h"

@interface ISEScrollerViewController () <ISPPagingDelegate, ISPPagingDataSource>

@property (nonatomic, strong) ISPPagingViewController *pagingViewController;

@property (nonatomic, strong) NSArray *pages;

- (UIColor *)randomColor;

@end

@implementation ISEScrollerViewController

#pragma mark - ViewLifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    /*-------------------*/
    
    self.title = @"Insightful Pager";
    
    /*-------------------*/
    
    [self addChildViewController:self.pagingViewController];
    [self.view addSubview:self.pagingViewController.view];
    [self.pagingViewController didMoveToParentViewController:self];
    
    [self.pagingViewController beginAppearanceTransition:YES
                                                animated:YES];
    
}

#pragma mark - Paging

- (ISPPagingViewController *)pagingViewController
{
    if (!_pagingViewController)
    {
        _pagingViewController = [[ISPPagingViewController alloc] initWithPageViewController:self.pages[0]
                                                                                   pageSize:self.view.frame.size
                                                                                 centerPage:NO];
        
        self.pagingViewController.dataSource = self;
        self.pagingViewController.delegate = self;
    }
    
    return _pagingViewController;
}

- (NSArray *)pages
{
    if (!_pages)
    {
        NSMutableArray *mutablePages = [NSMutableArray array];
        
        for (NSUInteger index = 0; index < 10; index++)
        {
            ISEPageViewController *viewController = [[ISEPageViewController alloc] init];
            viewController.view.backgroundColor = [self randomColor];
            
            [mutablePages addObject:viewController];
        }
        
        _pages = [mutablePages copy];
    }
    
    return _pages;
}

- (UIColor *)randomColor
{
    CGFloat hue = ( arc4random() % 256 / 256.0f );  //  0.0 to 1.0
    CGFloat saturation = ( arc4random() % 128 / 256.0f ) + 0.5f;  //  0.5 to 1.0, away from white
    CGFloat brightness = ( arc4random() % 128 / 256.0f ) + 0.5f;  //  0.5 to 1.0, away from black
    
    return [UIColor colorWithHue:hue
                      saturation:saturation
                      brightness:brightness
                           alpha:1.0f];
}

#pragma mark - ISPPagingDataSource

- (UIViewController *)viewControllerBeforeViewController:(UIViewController *)viewController
{
    NSUInteger indexOfFocusedViewController = [self.pages indexOfObject:viewController];
    
    ISEPageViewController *viewControllerBeforeViewController = nil;
    
    if (indexOfFocusedViewController > 0)
    {
        viewControllerBeforeViewController = self.pages[(--indexOfFocusedViewController)];
    }
    
    return viewControllerBeforeViewController;
}

- (UIViewController *)viewControllerAfterViewController:(UIViewController *)viewController
{
    NSUInteger indexOfFocusedViewController = [self.pages indexOfObject:viewController];
    
    ISEPageViewController *viewControllerAfterViewController = nil;
    
    if (indexOfFocusedViewController < ([self.pages count] - 1))
    {
        viewControllerAfterViewController = self.pages[(++indexOfFocusedViewController)];
    }
    
    return viewControllerAfterViewController;
}

#pragma mark - ISPPagingDelegate

- (void)willMoveFromViewController:(UIViewController *)viewController
{
    ISEPageViewController *page = (ISEPageViewController *)viewController;
    
    page.informationalLabel.text = @"willMoveFromViewController method called";
}

- (void)didMoveToViewController:(UIViewController *)toViewController
             fromViewController:(UIViewController *)fromViewController
{
    ISEPageViewController *page = (ISEPageViewController *)toViewController;
    
    page.informationalLabel.text = @"didMoveToViewController method called";
}

- (void)scrollingPages
{
    ISEPageViewController *page = (ISEPageViewController *)self.pagingViewController.focusedViewController;
    
    page.informationalLabel.text = @"scrollingPages method called";
}

@end
