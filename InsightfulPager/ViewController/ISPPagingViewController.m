//
//  ISPPagingViewController.m
//  InsightfulPager
//
//  Created by William Boles on 21/01/2015.
//  Copyright © 2015 Boles. All rights reserved.
//

#import "ISPPagingViewController.h"

#import "ISPPagingScrollView.h"
#import "NSObject+ISPBlocks.h"

typedef NS_ENUM(NSUInteger, ISPChildViewControllerPosition)
{
    ISPChildViewControllerPositionLeft,
    ISPChildViewControllerPositionMiddle,
    ISPChildViewControllerPositionRight
};

@interface ISPPagingViewController () <UIScrollViewDelegate>

@property (nonatomic, strong) ISPPagingScrollView *viewLimited;

@property (nonatomic, strong) UIView *viewPageOne;
@property (nonatomic, strong) UIView *viewPageTwo;
@property (nonatomic, strong) UIView *viewPageThree;

@property (nonatomic, strong) UIViewController *pageOneViewController;
@property (nonatomic, strong) UIViewController *pageTwoViewController;
@property (nonatomic, strong) UIViewController *pageThreeViewController;

@property (nonatomic, strong) UIViewController *initialPageViewController;

@property (nonatomic, assign) ISPChildViewControllerPosition position;

@property (nonatomic, assign) CGFloat pagePadding;

@property (nonatomic, assign) BOOL centerPage;

@property (nonatomic, assign, readwrite) CGSize pageSize;

@property (nonatomic, assign, readwrite) BOOL dragging;

@property (nonatomic, strong, readwrite) UIViewController *focusedViewController;

- (void)setUpPages;

@end

@implementation ISPPagingViewController

#pragma mark - Init

- (instancetype)initWithPageViewController:(UIViewController *)initialPageViewController
{
    return [self initWithPageViewController:initialPageViewController
                                   pageSize:CGSizeZero
                                 centerPage:NO];
}

- (instancetype)initWithPageViewController:(UIViewController *)initialPageViewController
                                  pageSize:(CGSize)pageSize
                                centerPage:(BOOL)centerPage
{
    self = [super init];
    
    if (self)
    {
        self.pageSize = pageSize;
        self.initialPageViewController = initialPageViewController;
        self.centerPage = centerPage;
    }
    
    return self;
}

#pragma mark - ViewLifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setUpPages];
}

#pragma mark - Setup

- (void)setUpPages
{
    if (CGSizeEqualToSize(self.pageSize, CGSizeZero))
    {
        self.pageSize = self.view.frame.size;
    }
    
    /*------------------------------*/
    
    if ([self.dataSource respondsToSelector:@selector(viewControllerBeforeViewController:)] &&
        [self.dataSource respondsToSelector:@selector(viewControllerAfterViewController:)])
    {
        /*------------------------------*/
        
        UIViewController *beforeViewController = [self.dataSource viewControllerBeforeViewController:self.initialPageViewController];
        
        if (beforeViewController)
        {

            UIViewController *nextViewController = [self.dataSource viewControllerAfterViewController:self.initialPageViewController];
            
            if (nextViewController)
            {
                self.pageOneViewController = beforeViewController;
                self.pageTwoViewController = self.initialPageViewController;
                self.pageThreeViewController = nextViewController;
                
                self.position = ISPChildViewControllerPositionMiddle;
            }
            else
            {
                UIViewController *beforeBeforeViewController = [self.dataSource viewControllerBeforeViewController:beforeViewController];
                
                if (beforeBeforeViewController)
                {
                    self.pageOneViewController = beforeBeforeViewController;
                    self.pageTwoViewController = beforeViewController;
                    self.pageThreeViewController = self.initialPageViewController;
                }
                else
                {
                    self.pageOneViewController = beforeViewController;
                    self.pageTwoViewController = self.initialPageViewController;
                }
                
                self.position = ISPChildViewControllerPositionRight;
            }
        }
        else
        {
            UIViewController *nextViewController = [self.dataSource viewControllerAfterViewController:self.initialPageViewController];
            
            if (nextViewController)
            {
                UIViewController *nextNextViewController = [self.dataSource viewControllerAfterViewController:nextViewController];
                
                if (nextNextViewController)
                {
                    self.pageOneViewController = self.initialPageViewController;
                    self.pageTwoViewController = nextViewController;
                    self.pageThreeViewController = nextNextViewController;
                }
                else
                {
                    self.pageOneViewController = self.initialPageViewController;
                    self.pageTwoViewController = nextViewController;
                }
                
                self.position = ISPChildViewControllerPositionLeft;
                
            }
            else
            {
                self.pageOneViewController = self.initialPageViewController;
                
                self.position = ISPChildViewControllerPositionLeft;
            }
        }
    }
    else
    {
        self.pageOneViewController = self.initialPageViewController;
        
        self.position = ISPChildViewControllerPositionLeft;
    }
    
    /*------------------------------*/
    
    self.viewLimited = [[ISPPagingScrollView alloc] initWithFrame:CGRectMake(0.0f,
                                                                              0.0f,
                                                                              self.view.frame.size.width,
                                                                              self.view.frame.size.height)
                                                          pageSize:self.pageSize
                                                       pagePadding:self.pagePadding
                                                       centerPage:self.centerPage];
    
    self.viewLimited.scrollViewContent.delegate = self;
    
    [self.view addSubview:self.viewLimited];

    /*------------------------------*/
    
    NSUInteger numberOfPages = 0;
    
    /*------------------------------*/
    
    if (self.pageOneViewController)
    {
        self.viewPageOne = [[UIView alloc] init];
        
        self.viewPageOne.frame = CGRectMake(0.0f,
                                            0.0f,
                                            self.viewLimited.scrollViewContent.frame.size.width,
                                            self.viewLimited.scrollViewContent.frame.size.height);
        
        [self.viewLimited.scrollViewContent addSubview:self.viewPageOne];
        
        numberOfPages++;
        
        /*------------------------------*/
        
        if (self.pageTwoViewController)
        {
            self.viewPageTwo = [[UIView alloc] init];
            
            self.viewPageTwo.frame = CGRectMake(self.viewPageOne.frame.size.width + self.viewPageOne.frame.origin.x,
                                                0.0f,
                                                self.viewLimited.scrollViewContent.frame.size.width,
                                                self.viewLimited.scrollViewContent.frame.size.height);
            
            [self.viewLimited.scrollViewContent addSubview:self.viewPageTwo];
            
            numberOfPages++;
            
            /*------------------------------*/
            
            if (self.pageThreeViewController)
            {
                self.viewPageThree = [[UIView alloc] init];
                
                self.viewPageThree.frame = CGRectMake(self.viewPageTwo.frame.size.width + self.viewPageTwo.frame.origin.x,
                                                      0.0f,
                                                      self.viewLimited.scrollViewContent.frame.size.width,
                                                      self.viewLimited.scrollViewContent.frame.size.height);
                
                [self.viewLimited.scrollViewContent addSubview:self.viewPageThree];
                
                numberOfPages++;
            }
        }
    }
    
    /*------------------------*/
    
    switch (self.position)
    {
        case ISPChildViewControllerPositionLeft:
        {
            /*------------------------------*/
            
            [self addChildViewController:self.pageOneViewController];
            
            [self.viewPageOne addSubview:self.pageOneViewController.view];
            
            [self.pageOneViewController beginAppearanceTransition:YES
                                                         animated:YES];
            
            /*------------------------------*/
            
            if (self.pageTwoViewController)
            {
                
                [self addChildViewController:self.pageTwoViewController];
                
                [self.viewPageTwo addSubview:self.pageTwoViewController.view];
                
                [self.pageTwoViewController beginAppearanceTransition:YES
                                                             animated:YES];
                
                
                if (self.pageThreeViewController)
                {
                    
                    [self addChildViewController:self.pageThreeViewController];
                    
                    [self.viewPageThree addSubview:self.pageThreeViewController.view];
                    
                    [self.pageThreeViewController beginAppearanceTransition:YES
                                                                 animated:YES];
  
                }
            }
            
            /*------------------------------*/
            
            [self isp_performBlock:^
             {
                 [self.viewLimited.scrollViewContent scrollRectToVisible:self.viewPageOne.frame
                                                                animated:NO];
             }
                    afterDelay:0.0f];
            
            break;
        }
        case ISPChildViewControllerPositionMiddle:
        {
            /*------------------------------*/
            
            [self addChildViewController:self.pageOneViewController];
            
            [self.viewPageOne addSubview:self.pageOneViewController.view];
            
            [self.pageOneViewController beginAppearanceTransition:YES
                                                         animated:YES];
            
            /*------------------------------*/
            
            [self addChildViewController:self.pageTwoViewController];
            
            [self.viewPageTwo addSubview:self.pageTwoViewController.view];
            
            [self.pageTwoViewController beginAppearanceTransition:YES
                                                         animated:YES];
            
            /*------------------------------*/
            
            [self addChildViewController:self.pageThreeViewController];
            
            [self.viewPageThree addSubview:self.pageThreeViewController.view];
            
            [self.pageThreeViewController beginAppearanceTransition:YES
                                                           animated:YES];
            
            /*------------------------------*/
            
            [self isp_performBlock:^
             {
                 [self.viewLimited.scrollViewContent scrollRectToVisible:self.viewPageTwo.frame
                                                                animated:NO];
             }
                    afterDelay:0.0f];
            
            break;
        }
        case ISPChildViewControllerPositionRight:
        {
            if (self.pageThreeViewController)
            {
                /*------------------------------*/
                
                [self addChildViewController:self.pageThreeViewController];
                
                [self.viewPageThree addSubview:self.pageThreeViewController.view];
                
                [self.pageThreeViewController beginAppearanceTransition:YES
                                                               animated:YES];
                
                /*------------------------------*/
                
                [self addChildViewController:self.pageTwoViewController];
                
                [self.viewPageTwo addSubview:self.pageTwoViewController.view];
                
                [self.pageTwoViewController beginAppearanceTransition:YES
                                                             animated:YES];
                
                /*------------------------------*/
                
                [self addChildViewController:self.pageOneViewController];
                
                [self.viewPageOne addSubview:self.pageOneViewController.view];
                
                [self.pageOneViewController beginAppearanceTransition:YES
                                                             animated:YES];
                
                /*------------------------------*/
                
                [self isp_performBlock:^
                 {
                     [self.viewLimited.scrollViewContent scrollRectToVisible:self.viewPageThree.frame
                                                                    animated:NO];
                 }
                        afterDelay:0.0f];
            }
            else
            {
                /*------------------------------*/
                
                [self addChildViewController:self.pageTwoViewController];
                
                [self.viewPageTwo addSubview:self.pageTwoViewController.view];
                
                [self.pageTwoViewController beginAppearanceTransition:YES
                                                             animated:YES];
                
                /*------------------------------*/
                
                [self addChildViewController:self.pageOneViewController];
                
                [self.viewPageOne addSubview:self.pageOneViewController.view];
                
                [self.pageOneViewController beginAppearanceTransition:YES
                                                             animated:YES];
                
                /*------------------------------*/
                
                [self isp_performBlock:^
                 {
                     [self.viewLimited.scrollViewContent scrollRectToVisible:self.viewPageTwo.frame
                                                                    animated:NO];
                 }
                        afterDelay:0.0f];
            }
            
            break;
        }
        default:
        {
            break;
        }
    }
    
    /*------------------------*/
    
    self.viewLimited.scrollViewContent.contentSize = CGSizeMake((self.viewLimited.scrollViewContent.frame.size.width*numberOfPages),
                                                                self.viewLimited.scrollViewContent.frame.size.height - 100.0f);
    
    /*------------------------*/
}

#pragma mark - Dragging

- (BOOL)dragging
{
    return self.viewLimited.scrollViewContent.dragging;
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if ([self.delegate respondsToSelector:@selector(scrollingPages)])
    {
        [self.delegate scrollingPages];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if(((scrollView.contentOffset.x > scrollView.frame.size.width) ||
        (scrollView.contentOffset.x == scrollView.frame.size.width && self.position == ISPChildViewControllerPositionLeft)) &&
       (self.position != ISPChildViewControllerPositionRight))
    {
        switch (self.position)
        {
            case ISPChildViewControllerPositionLeft:
            {
                
                if ([self.delegate respondsToSelector:@selector(willMoveFromViewController:)])
                {
                    [self.delegate willMoveFromViewController:self.pageOneViewController];
                }
                
                if (self.pageThreeViewController)
                {
                    self.position = ISPChildViewControllerPositionMiddle;
                }
                else
                {
                    self.position = ISPChildViewControllerPositionRight;
                }
                
                if ([self.delegate respondsToSelector:@selector(didMoveToViewController:fromViewController:)])
                {
                    if (scrollView.contentOffset.x > scrollView.frame.size.width)
                    {
                        [self.delegate didMoveToViewController:self.pageThreeViewController
                                            fromViewController:self.pageOneViewController];
                    }
                    else
                    {
                        [self.delegate didMoveToViewController:self.pageTwoViewController
                                            fromViewController:self.pageOneViewController];
                    }
                }

                break;
            }
            case ISPChildViewControllerPositionMiddle:
            {
                
                if ([self.dataSource respondsToSelector:@selector(viewControllerAfterViewController:)])
                {
                    if ([self.delegate respondsToSelector:@selector(willMoveFromViewController:)])
                    {
                        [self.delegate willMoveFromViewController:self.pageTwoViewController];
                    }
                    
                    UIViewController *thirdViewController = [self.dataSource viewControllerAfterViewController:self.pageThreeViewController];
                    
                    if (thirdViewController)
                    {
                        /*----------------------------*/
                        
                        [self.pageOneViewController.view removeFromSuperview];
                        [self.pageOneViewController removeFromParentViewController];
                        
                        /*----------------------------*/
                        
                        self.pageOneViewController = self.pageTwoViewController;
                        
                        [self addChildViewController:self.pageOneViewController];
                        
                        [self.viewPageOne addSubview:self.pageOneViewController.view];
                        
                        [self.pageOneViewController beginAppearanceTransition:YES
                                                                     animated:YES];
                        
                        /*----------------------------*/
                        
                        self.pageTwoViewController = self.pageThreeViewController;
                        
                        [self addChildViewController:self.pageTwoViewController];
                        
                        [self.viewPageTwo addSubview:self.pageTwoViewController.view];
                        
                        [self.pageTwoViewController beginAppearanceTransition:YES
                                                                     animated:YES];
                        
                        /*----------------------------*/
                        
                        self.pageThreeViewController = thirdViewController;
                        
                        [self addChildViewController:self.pageThreeViewController];
                        
                        [self.viewPageThree addSubview:self.pageThreeViewController.view];
                        
                        [self.pageThreeViewController beginAppearanceTransition:YES
                                                                       animated:YES];
                        
                        /*----------------------------*/
                        
                        [self.viewLimited.scrollViewContent scrollRectToVisible:self.viewPageTwo.frame
                                                                       animated:NO];
                        
                        if ([self.delegate respondsToSelector:@selector(didMoveToViewController:fromViewController:)])
                        {
                            [self.delegate didMoveToViewController:self.pageTwoViewController
                                                fromViewController:self.pageOneViewController]; //this pageTwoViewController used to pageThreeViewController before the move (above)
                        }
                    }
                    else
                    {
                        /*----------------------------*/
                        
                        self.position = ISPChildViewControllerPositionRight;
                        
                        [self.viewLimited.scrollViewContent scrollRectToVisible:self.viewPageThree.frame
                                                                       animated:NO];
                        
                        if ([self.delegate respondsToSelector:@selector(didMoveToViewController:fromViewController:)])
                        {
                            [self.delegate didMoveToViewController:self.pageThreeViewController
                                                fromViewController:self.pageTwoViewController];
                        }
                    }
                }
                else
                {
                    if (self.pageThreeViewController)
                    {
                        if ([self.delegate respondsToSelector:@selector(willMoveFromViewController:)])
                        {
                            [self.delegate willMoveFromViewController:self.pageTwoViewController];
                        }
                        
                        self.position = ISPChildViewControllerPositionRight;
                        
                        [self.viewLimited.scrollViewContent scrollRectToVisible:self.viewPageThree.frame
                                                                       animated:NO];
                        
                        if ([self.delegate respondsToSelector:@selector(didMoveToViewController:fromViewController:)])
                        {
                            [self.delegate didMoveToViewController:self.pageThreeViewController
                                                fromViewController:self.pageTwoViewController];
                        }
                    }
                }
                
                break;
            }
            default:
            {
                break;
            }
        }
	}
    else if((scrollView.contentOffset.x < scrollView.frame.size.width) ||
            (scrollView.contentOffset.x == scrollView.frame.size.width && self.position == ISPChildViewControllerPositionRight))
    {
        switch (self.position)
        {
            case ISPChildViewControllerPositionRight:
            {
                
                if (scrollView.contentOffset.x != scrollView.frame.size.width)
                {
                    
                    if (self.pageThreeViewController)
                    {
                        if ([self.delegate respondsToSelector:@selector(willMoveFromViewController:)])
                        {
                            [self.delegate willMoveFromViewController:self.pageThreeViewController];
                        }
                        
                        self.position = ISPChildViewControllerPositionLeft;
                        
                        if ([self.delegate respondsToSelector:@selector(didMoveToViewController:fromViewController:)])
                        {
                            [self.delegate didMoveToViewController:self.pageOneViewController
                                                fromViewController:self.pageThreeViewController];
                        }
                    }
                    else //To catch when there is only two pages and the user scrolls forward on the last page
                    {
                        if ([self.delegate respondsToSelector:@selector(willMoveFromViewController:)])
                        {
                            [self.delegate willMoveFromViewController:self.pageTwoViewController];
                        }
                        
                        self.position = ISPChildViewControllerPositionLeft;
                        
                        if ([self.delegate respondsToSelector:@selector(didMoveToViewController:fromViewController:)])
                        {
                            [self.delegate didMoveToViewController:self.pageOneViewController
                                                fromViewController:self.pageTwoViewController];
                        }
                    }
                    
                }
                else 
                {
                    if (self.pageThreeViewController)
                    {
                        if ([self.delegate respondsToSelector:@selector(willMoveFromViewController:)])
                        {
                            [self.delegate willMoveFromViewController:self.pageThreeViewController];
                        }
                        
                        self.position = ISPChildViewControllerPositionMiddle;
                        
                        if ([self.delegate respondsToSelector:@selector(didMoveToViewController:fromViewController:)])
                        {
                            [self.delegate didMoveToViewController:self.pageTwoViewController
                                                fromViewController:self.pageThreeViewController];
                        }
                    }
                }
 
                break;
            }
            case ISPChildViewControllerPositionMiddle:
            {
                if ([self.dataSource respondsToSelector:@selector(viewControllerBeforeViewController:)])
                {
                    if ([self.delegate respondsToSelector:@selector(willMoveFromViewController:)])
                    {
                        [self.delegate willMoveFromViewController:self.pageTwoViewController];
                    }
                    
                    UIViewController *firstViewController = [self.dataSource viewControllerBeforeViewController:self.pageOneViewController];
                    
                    if (firstViewController)
                    {
                        /*----------------------------*/
                        
                        [self.pageThreeViewController.view removeFromSuperview];
                        [self.pageThreeViewController removeFromParentViewController];
                        
                        /*----------------------------*/
                        
                        self.pageThreeViewController = self.pageTwoViewController;
                        
                        [self addChildViewController:self.pageThreeViewController];
                        
                        [self.viewPageThree addSubview:self.pageThreeViewController.view];
                        
                        [self.pageThreeViewController beginAppearanceTransition:YES
                                                                       animated:YES];
                        
                        /*----------------------------*/
                        
                        self.pageTwoViewController = self.pageOneViewController;
                        
                        [self addChildViewController:self.pageTwoViewController];
                        
                        [self.viewPageTwo addSubview:self.pageTwoViewController.view];
                        
                        [self.pageTwoViewController beginAppearanceTransition:YES
                                                                     animated:YES];
                        
                        /*----------------------------*/
                        
                        self.pageOneViewController = firstViewController;
                        
                        [self addChildViewController:self.pageOneViewController];
                        
                        [self.viewPageOne addSubview:self.pageOneViewController.view];
                        
                        [self.pageOneViewController beginAppearanceTransition:YES
                                                                     animated:YES];
                        
                        /*----------------------------*/
                        
                        [self.viewLimited.scrollViewContent scrollRectToVisible:self.viewPageTwo.frame
                                                                       animated:NO];
                        
                        if ([self.delegate respondsToSelector:@selector(didMoveToViewController:fromViewController:)])
                        {
                            [self.delegate didMoveToViewController:self.pageTwoViewController
                                                fromViewController:self.pageThreeViewController];//this pageTwoViewController used to pageOneViewController before the move (above)
                        }
                    }
                    else
                    {
                        /*----------------------------*/
                        
                        self.position = ISPChildViewControllerPositionLeft;
                        
                        [self.viewLimited.scrollViewContent scrollRectToVisible:self.viewPageOne.frame
                                                                       animated:NO];
                        
                        if ([self.delegate respondsToSelector:@selector(didMoveToViewController:fromViewController:)])
                        {
                            [self.delegate didMoveToViewController:self.pageOneViewController
                                                fromViewController:self.pageTwoViewController];
                        }
                    }
                }

                break;
            }
            default:
            {
                break;
            }
        }
	}
    else
    {
        switch (self.position)
        {
            case ISPChildViewControllerPositionLeft:
            {
                [self.viewLimited.scrollViewContent scrollRectToVisible:self.viewPageOne.frame
                                                               animated:NO];
                
                break;
            }
            case ISPChildViewControllerPositionMiddle:
            {
                [self.viewLimited.scrollViewContent scrollRectToVisible:self.viewPageTwo.frame
                                                               animated:NO];
                
                break;
            }
            case ISPChildViewControllerPositionRight:
            {
                [self.viewLimited.scrollViewContent scrollRectToVisible:self.viewPageThree.frame
                                                               animated:NO];
                
                break;
            }
            default:
                break;
        }
    }
}

#pragma mark - Pages

- (UIViewController *)focusedViewController
{
    UIViewController *focusedViewController = nil;
    
    switch (self.position)
    {
        case ISPChildViewControllerPositionLeft:
        {
            focusedViewController = self.pageOneViewController;
            
            break;
        }
        case ISPChildViewControllerPositionMiddle:
        {
            focusedViewController = self.pageTwoViewController;
            
            break;
        }
        case ISPChildViewControllerPositionRight:
        {
            if (self.pageThreeViewController)
            {
                focusedViewController = self.pageThreeViewController;
            }
            else
            {
                focusedViewController = self.pageTwoViewController;
            }
            
            break;
        }
        default:
        {
            break;
        }
    }
    
    return focusedViewController;
}

- (void)reloadPagesWithFocusOnPageViewController:(UIViewController *)viewController
{
    NSArray *childViewControllers = self.childViewControllers;
    
    for (UIViewController *childViewController in childViewControllers)
    {
        [childViewController.view removeFromSuperview];
        [childViewController removeFromParentViewController];
    }
    
    self.initialPageViewController = viewController;
    
    [self setUpPages];
}

- (CGFloat) pagePadding
{
    return (self.view.frame.size.width - self.pageSize.width)/4;
}

- (void)setPageOneViewController:(UIViewController *)pageOneViewController
{
    if (![pageOneViewController isEqual:_pageOneViewController])
    {       
        _pageOneViewController = pageOneViewController;
        _pageOneViewController.view.frame = CGRectMake(self.pagePadding/2,
                                                       0.0f,
                                                       self.pageSize.width,
                                                       self.pageSize.height);
    }
}

- (void)setPageTwoViewController:(UIViewController *)pageTwoViewController
{
    if (![pageTwoViewController isEqual:_pageTwoViewController])
    {
        
        _pageTwoViewController = pageTwoViewController;
        _pageTwoViewController.view.frame = CGRectMake(self.pagePadding/2,
                                                       0.0f,
                                                       self.pageSize.width,
                                                       self.pageSize.height);
    }
}

- (void)setPageThreeViewController:(UIViewController *)pageThreeViewController
{
    if (![pageThreeViewController isEqual:_pageThreeViewController])
    {
        _pageThreeViewController = pageThreeViewController;
        _pageThreeViewController.view.frame = CGRectMake(self.pagePadding/2,
                                                         0.0f,
                                                         self.pageSize.width,
                                                         self.pageSize.height);
    }
}

@end
