//
//  NSObject+ISPBlocks.h
//  InsightfulPager
//
//  Created by William Boles on 18/02/2014.
//  Copyright © 2015 Boles. All rights reserved.
//

@import Foundation;

/**
 Convenience category for calling a block after a delay. 
 */
@interface NSObject (ISPBlocks)

/*
 Executes block after a delay
 
 @param block - block to be executed
 @param delay - time delay before block is executed
 */
- (void)isp_performBlock:(void (^)(void))block
              afterDelay:(NSTimeInterval)delay;

/*
 Executes block after a delay
 
 @param block - block to be executed
 @param delay - time delay before block is executed
 */
+ (void)isp_performBlock:(void (^)(void))block
              afterDelay:(NSTimeInterval)delay;

@end
