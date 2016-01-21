//
//  NSObject+ISPBlocks.m
//  InsightfulPager
//
//  Created by William Boles on 18/02/2014.
//  Copyright © 2015 Boles. All rights reserved.
//

#import "NSObject+ISPBlocks.h"

@implementation NSObject (ISPBlocks)

#pragma mark - Block

+ (void)isp_performBlock:(void (^)(void))block
              afterDelay:(NSTimeInterval)delay
{
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC));
    
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void)
                   {
                       if (block)
                       {
                           block();
                       }
                   });
}

- (void)isp_performBlock:(void (^)(void))block
              afterDelay:(NSTimeInterval)delay
{
    [NSObject isp_performBlock:block
                    afterDelay:delay];
}

@end
