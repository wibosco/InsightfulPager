//
//  ISPPagingScrollView.m
//  InsightfulPager
//
//  Created by William Boles on 21/01/2015.
//  Copyright © 2015 Boles. All rights reserved.
//

#import "ISPPagingScrollView.h"

@interface ISPPagingScrollView ()

@property (nonatomic, strong, readwrite) UIScrollView *scrollViewContent;

@end

@implementation ISPPagingScrollView

#pragma mark - Init

- (id)initWithFrame:(CGRect)frame
           pageSize:(CGSize)pageSize
        pagePadding:(CGFloat)pagePadding
         centerPage:(BOOL)centerPage
{
    
    self = [super initWithFrame:frame];
    
    if (self)
    {
        if (centerPage)
        {
            self.scrollViewContent = [[UIScrollView alloc] initWithFrame:CGRectMake(((frame.size.width - (pageSize.width + pagePadding))/2),
                                                                                    ((frame.size.height - pageSize.height)/4),
                                                                                    pageSize.width+pagePadding,
                                                                                    pageSize.height)];
        }
        else
        {
            self.scrollViewContent = [[UIScrollView alloc] initWithFrame:CGRectMake(0.0f,
                                                                                    0.0f,
                                                                                    pageSize.width,
                                                                                    pageSize.height)];
        }
        
        self.scrollViewContent.pagingEnabled = YES;
        self.scrollViewContent.showsHorizontalScrollIndicator = NO;
        self.scrollViewContent.showsVerticalScrollIndicator = NO;
        self.scrollViewContent.bounces = NO;
        self.scrollViewContent.directionalLockEnabled = YES;
        self.scrollViewContent.clipsToBounds = NO;
        
        [self addSubview:self.scrollViewContent];
    }
    
    return self;
}

#pragma mark - Hit

- (UIView *) hitTest:(CGPoint)thePoint withEvent:(UIEvent *)theEvent
{
    
    UIView *view = nil;
    
    if ([self pointInside:thePoint withEvent:theEvent])
    {
        view = [super hitTest:thePoint withEvent:theEvent];
        
        if ([view isEqual:self])
        {
            view = self.scrollViewContent;
        }
    }
    
    return view;
}

@end
