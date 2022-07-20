[![Version](https://img.shields.io/cocoapods/v/InsightfulPager.svg?style=flat)](http://cocoapods.org/pods/InsightfulPager)
[![License](https://img.shields.io/cocoapods/l/InsightfulPager.svg?style=flat)](http://cocoapods.org/pods/InsightfulPager)
[![Platform](https://img.shields.io/cocoapods/p/InsightfulPager.svg?style=flat)](http://cocoapods.org/pods/InsightfulPager)
<a href="https://twitter.com/wibosco"><img src="https://img.shields.io/badge/twitter-@wibosco-blue.svg?style=flat" alt="Twitter: @wibosco" /></a>

InsightfulPager is a more chatty alternative to UIPageViewController.

## Installation via [CocoaPods](https://cocoapods.org/)

To integrate InsightfulPager into your Xcode project using CocoaPods, specify it in your `Podfile`:

```ruby
source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '8.0'

pod 'InsightfulPager'
```

Then, run the following command:

```bash
$ pod install
```

> CocoaPods 0.39.0+ is required to build InsightfulPager.

## Usage

#### Init

```objc
#import <InsightfulPager/ISPPagingViewController.h>

....

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
```

#### Adding it as a child viewcontroller

```objc
#import <InsightfulPager/ISPPagingViewController.h>

....

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self addChildViewController:self.pagingViewController];
    [self.view addSubview:self.pagingViewController.view];
    [self.pagingViewController didMoveToParentViewController:self];
    
    [self.pagingViewController beginAppearanceTransition:YES
                                                animated:YES];
    
}
```

#### Possible DataSource implementation

```objc
#import <InsightfulPager/ISPPagingViewController.h>

....

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
```

#### Possible Delegate implementation

```objc
#import <InsightfulPager/ISPPagingViewController.h>

....

- (void)didMoveToViewController:(UIViewController *)toViewController
             fromViewController:(UIViewController *)fromViewController
{
    ISEPageViewController *page = (ISEPageViewController *)toViewController;
    
    NSUInteger indexOfViewControllerMovedTo = [self.pages indexOfObject:toViewController];
    NSUInteger indexOfViewControllerMovedFrom = [self.pages indexOfObject:fromViewController];
    
    NSString *direction = nil;
    
    if (indexOfViewControllerMovedTo > indexOfViewControllerMovedFrom)
    {
        direction = @"forwards";
    }
    else
    {
        direction = @"backwards";
    }
    
    page.informationalLabel.text = [NSString stringWithFormat:@"Moved onto this viewcontroller by scrolling %@", direction];
}
```

#### Less than fullscreen

InsightfulPager allows you to specify different page size so that views outside of the page can be displayed on the screena at the same time. 

```objc
#import <InsightfulPager/ISPPagingViewController.h>

....

- (ISPPagingViewController *)pagingViewController
{
    if (!_pagingViewController)
    {
    	CGSize pageSize = CGSizeMake(self.view.frame.size.width,                                                                                        
                                     self.view.frame.size.height - kISESelectionBarOffset) //kISESelectionBarOffset is a constant float defined else where
    
        _pagingViewController = [[ISPPagingViewController alloc] initWithPageViewController:self.pages[0]
                                                                                   pageSize:pageSize
                                                                                 centerPage:NO];
        
        self.pagingViewController.dataSource = self;
        self.pagingViewController.delegate = self;
    }
    
    return _pagingViewController;
}
```

#### Need the currently shown page

If you need the currently shown (in-focus) `UIViewController` page you can use the `focusedViewController` property.

> InsightfulPager comes with an [example project](https://github.com/wibosco/InsightfulPager/tree/master/Example/iOS%20Example) to provide more details than listed above.

> InsightfulPager uses [modules](http://useyourloaf.com/blog/modules-and-precompiled-headers.html) for importing/using frameworks - you will need to enable this in your project.

## Found an issue?

Please open a [new Issue here](https://github.com/wibosco/ConvenientFileManager/issues/new) if you run into a problem specific to InsightfulPager, have a feature request, or want to share a comment. Note that general `UIPageViewController` questions should be asked on [Stack Overflow](http://stackoverflow.com).

Pull requests are encouraged and greatly appreciated! Please try to maintain consistency with the existing [code style](https://www.williamboles.com/objective-c-coding-style). If you're considering taking on significant changes or additions to the project, please communicate in advance by opening a new Issue. This allows everyone to get onboard with upcoming changes, ensures that changes align with the project's design philosophy, and avoids duplicated work.
