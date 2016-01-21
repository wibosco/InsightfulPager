//
//  ISEPageViewController.m
//  iOSExample
//
//  Created by William Boles on 21/01/2016.
//  Copyright © 2016 Boles. All rights reserved.
//

#import "ISEPageViewController.h"

#import <PureLayout/PureLayout.h>

@interface ISEPageViewController ()

@property (nonatomic, strong, readwrite) UILabel *informationalLabel;

@end

@implementation ISEPageViewController

#pragma mark - ViewLifcycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    /*-------------------*/
    
    [self.view addSubview:self.informationalLabel];
    
    /*-------------------*/
    
    [self updateViewConstraints];
}

#pragma mark - Informational

- (UILabel *)informationalLabel
{
    if (!_informationalLabel)
    {
        _informationalLabel = [UILabel newAutoLayoutView];
        _informationalLabel.textAlignment = NSTextAlignmentCenter;
        _informationalLabel.font = [UIFont fontWithName:@"HelveticaNeue"
                                                   size:27.0f];
    }
    
    return _informationalLabel;
}

#pragma mark - Constraints

- (void)updateViewConstraints
{
    [self.informationalLabel autoSetDimension:ALDimensionHeight
                                       toSize:40.0f];
    
    [self.informationalLabel autoPinEdgeToSuperviewEdge:ALEdgeLeft
                                              withInset:20.0f];
    
    [self.informationalLabel autoPinEdgeToSuperviewEdge:ALEdgeRight
                                              withInset:20.0f];
    
    [self.informationalLabel autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
    
    /*-------------------*/
    
    [super updateViewConstraints];
}

@end
