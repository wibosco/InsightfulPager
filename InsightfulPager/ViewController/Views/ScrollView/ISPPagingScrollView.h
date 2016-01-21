//
//  ISPPagingScrollView.h
//  InsightfulPager
//
//  Created by William Boles on 21/01/2015.
//  Copyright © 2015 Boles. All rights reserved.
//

@import UIKit;

@interface ISPPagingScrollView : UIView

/**
 The scrollview contained inside this view.
 */
@property (nonatomic, strong, readonly) UIScrollView *scrollViewContent;

/**
 Initializer with frame, size, paddding and center value.
 
 @param frame - frame of the view (not scrollview).
 @param pageSize - size of each page to be shown in scrollview.
 @param pagePadding - any horizontal padding that will be able to this entire view.
 @param centerPage - if the first page is a center page or edge.
 
 @return `ISPPagingScrollView` instance configured with the passed in values.
 */
- (instancetype)initWithFrame:(CGRect)frame
                     pageSize:(CGSize)pageSize
                  pagePadding:(CGFloat)pagePadding
                   centerPage:(BOOL)centerPage;

@end
