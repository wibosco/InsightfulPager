//
//  ISEAppDelegate.m
//  iOSExample
//
//  Created by William Boles on 21/01/2016.
//  Copyright © 2016 Boles. All rights reserved.
//

#import "ISEAppDelegate.h"

#import "ISEScrollerViewController.h"

@interface ISEAppDelegate ()

@property (nonatomic, strong) ISEScrollerViewController *viewController;

@end

@implementation ISEAppDelegate

#pragma mark - ApplicationLifecycle

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    /*-------------------*/
    
    self.window.backgroundColor = [UIColor clearColor];
    self.window.clipsToBounds = NO;
    
    [self.window makeKeyAndVisible];
    
    /*-------------------*/
    
    return YES;
}

#pragma mark - Window

- (UIWindow *)window
{
    if (!_window)
    {
        _window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _window.rootViewController = self.navigationController;
    }
    
    return _window;
}

#pragma mark - Navigation

- (UINavigationController *)navigationController
{
    if (!_navigationController)
    {
        _navigationController = [[UINavigationController alloc] initWithRootViewController:self.viewController];
    }
    
    return _navigationController;
}

#pragma mark - ViewController

- (ISEScrollerViewController *)viewController
{
    if (!_viewController)
    {
        _viewController = [[ISEScrollerViewController alloc] init];
    }
    
    return _viewController;
}

@end
