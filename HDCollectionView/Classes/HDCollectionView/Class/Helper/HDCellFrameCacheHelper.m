//
//  HDCellHeightCountHelper.m
//  HDCollectionView
//
//  Created by HaoDong chen on 2018/11/6.
//  Copyright © 2018 CHD. All rights reserved.
//

#import "HDCellFrameCacheHelper.h"

@implementation HDCellFrameCacheHelper

+ (NSMutableArray<NSValue*>*)copySubViewsFrame:(UIView*)superView
{
    NSMutableArray *allSubViewFrame = @[].mutableCopy;
    NSMutableArray *queue = superView.subviews.mutableCopy;
    int index = 0;
    while (queue.count) {
        UIView *oneSubV = [queue firstObject];
        [queue removeObjectAtIndex:0];
        
        NSValue *cache = [NSValue valueWithCGRect:oneSubV.frame];
        [allSubViewFrame addObject:cache];
        
        if (oneSubV.subviews.count) {
            [queue addObjectsFromArray:oneSubV.subviews];
        }
        index ++;
    }
    return allSubViewFrame;
}
+ (void)resetViewSubviewFrame:(UIView*)superView subViewFrame:(NSMutableArray<NSValue*>*)subViewFrameArr
{
    NSMutableArray *queue = superView.subviews.mutableCopy;
    int index = 0;
    while (queue.count) {
        UIView *firstView = [queue firstObject];
        if (index<subViewFrameArr.count) {
            NSValue *cache = subViewFrameArr[index];
            firstView.frame = [cache CGRectValue];
        }
        //出队
        [queue removeObjectAtIndex:0];
        //子view入队
        [queue addObjectsFromArray:firstView.subviews];
        index ++;
        
    }
}


@end
