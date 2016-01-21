//
//  ISPPagingViewController.h
//  InsightfulPager
//
//  Created by William Boles on 21/01/2015.
//  Copyright © 2015 Boles. All rights reserved.
//

@import UIKit;

@class ISPPagingViewController;

/**
 Datasource for ISPPagingViewController, that allows another class to populate the pages.
 */
@protocol ISPPagingDataSource <NSObject>

@optional

/**
 Determines if there is another page before the page passed in.
 
 @param viewController - `UIViewController` instance that directly follows the requested viewcontroller.
 
 @return Requested `UIViewController` instance or nil if the control is at the start of the pages.
 */
- (UIViewController *)viewControllerBeforeViewController:(UIViewController *)viewController;

/**
 Determines if there is another page after the page passed in.
 
 @param viewController - `UIViewController` instance that directly precedes the requested viewcontroller.
 
 @return Requested `UIViewController` instance or nil if the control is at the end of the pages.
 */
- (UIViewController *)viewControllerAfterViewController:(UIViewController *)viewController;

@end

/**
 Delegate for sharing the state of the `ISPPagingViewController` when it is being interacted with.
 */
@protocol ISPPagingDelegate <NSObject>

@optional

/**
 Callback for when the `ISPPagingViewController` instance will move from one page to another
 
 @param viewController - `UIViewController` instance that is being moved off of.
 */
- (void)willMoveFromViewController:(UIViewController *)viewController;

/**
 Callback for when the `ISPPagingViewController` instance will move from one page to another
 
 @param toViewController - `UIViewController` instance that is being moved into.
 @param fromViewController - `UIViewController` instance that is being moved off of.
 */
- (void)didMoveToViewController:(UIViewController *)toViewController
             fromViewController:(UIViewController *)fromViewController;

/**
 Call for when the pages are being scrolled.
 */
- (void)scrollingPages;

@end

/**
 A custom implemetation of `UIPageViewController` that provides more customisation options.
 */
@interface ISPPagingViewController : UIViewController

/**
 Delegate allows for a suite of different callbacks to inform about actions being taken by `ISPPagingViewController` instance.
 */
@property (nonatomic, weak) id<ISPPagingDelegate> delegate;

/**
 Datasource allows for setting the pages to be shown.
 */
@property (nonatomic, weak) id<ISPPagingDataSource> dataSource;

/**
 The size of the pages.
 */
@property (nonatomic, assign, readonly) CGSize pageSize;

/**
 The state of dragging.
 */
@property (nonatomic, assign, readonly) BOOL dragging;

/**
 The `UIViewController` instance that is considered in 'focus'.
 */
@property (nonatomic, strong, readonly) UIViewController *focusedViewController;

/**
 Initializer with an initial page.
 
 @param initialPageViewController - `UIViewController` instance that will be used as the first page.
 
 @return ISPPagingViewController instance.
 */
- (instancetype)initWithPageViewController:(UIViewController *)initialPageViewController;

/**
 Initializer with an initial page, size and state.
 
 @param initialPageViewController - `UIViewController` instance that will be used as the first page.
 @param pageSize - size of each page that will be shown in this `ISPPagingViewController` instance.
 @param centerPage - if this page is a center page.
 
 @return ISPPagingViewController instance.
 */
- (instancetype)initWithPageViewController:(UIViewController *)initialPageViewController
                                  pageSize:(CGSize)pageSize
                                centerPage:(BOOL)centerPage;

/**
 Reloads all pages and returns to the passed in page.
 
 @param centerPage - `UIViewController` instance that will be returned to after the pages are reloaded.
 */
- (void)reloadPagesWithFocusOnPageViewController:(UIViewController *)centerPage;

@end
