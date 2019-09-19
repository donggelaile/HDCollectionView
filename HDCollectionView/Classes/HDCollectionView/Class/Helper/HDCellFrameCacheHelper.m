//
//  HDCellHeightCountHelper.m
//  HDCollectionView
//
//  Created by HaoDong chen on 2018/11/6.
//  Copyright © 2018 CHD. All rights reserved.
//

#import "HDCellFrameCacheHelper.h"
#import "HDAssociationManager.h"

@implementation HDCollectionCell(subViewFrameCache)
- (void)setCacheKeysIfNeed
{
    id curObjMap = [[HDAssociationManager hd_currentVaules]objectForKey:self];
    if ([[curObjMap keyEnumerator] allObjects].count<=0) {
        [HDCellFrameCacheHelper setAllsubViewFrameKey:self];
    }
}
@end

@interface HDCellSubViewFrameCache()
{
    NSString* cacheKey;
    CGRect cacheFrame;
}
@end

@implementation HDCellSubViewFrameCache
- (void)setCacheKey:(NSString*)key
{
    cacheKey = key;
}
- (void)setCacheFrame:(CGRect)Frame
{
    cacheFrame = Frame;
}
- (CGRect)cacheFrame
{
    return cacheFrame;
}
- (NSString*)cacheKey
{
    return cacheKey;
}
@end

@implementation HDCellFrameCacheHelper

+ (NSMutableArray<HDCellSubViewFrameCache*>*)copySubViewsFrame:(UIView*)superView
{
    NSMutableArray *allSubViewFrame = @[].mutableCopy;
    NSMutableArray *queue = superView.subviews.mutableCopy;
    int index = 0;
    while (queue.count) {
        UIView *oneSubV = [queue firstObject];
        [queue removeObjectAtIndex:0];
        
        int key = index + 100;
        //        UIView *cacheView = objc_getAssociatedObject(superView,  (__bridge const void * _Nonnull)(@(key).stringValue));
        UIView *cacheView = [HDAssociationManager hd_getAssociatedObject:superView key:@(key).stringValue];
        HDCellSubViewFrameCache *cache = [HDCellSubViewFrameCache new];
        [cache setCacheKey:@(key).stringValue];
        [cache setCacheFrame:cacheView.frame];
        [allSubViewFrame addObject:cache];
        
        if (oneSubV.subviews.count && ![self isListView:oneSubV]) {
            [queue addObjectsFromArray:oneSubV.subviews];
        }
        index ++;
    }
    return allSubViewFrame;
}
+ (void)resetViewSubviewFrame:(UIView*)superView subViewFrame:(NSMutableArray<HDCellSubViewFrameCache*>*)subViewFrameArr
{
    [subViewFrameArr enumerateObjectsUsingBlock:^(HDCellSubViewFrameCache * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        //        UIView *subV = objc_getAssociatedObject(superView, (__bridge const void * _Nonnull)(obj.cacheKey));
        UIView *subV = [HDAssociationManager hd_getAssociatedObject:superView key:obj.cacheKey];
        subV.frame = obj.cacheFrame;
    }];
}


+ (void)setAllsubViewFrameKey:(UIView*)superView
{
    NSMutableArray *queue = superView.subviews.mutableCopy;
    int index = 0;
    while (queue.count) {
        UIView *firstView = [queue firstObject];
        //初始化
        int key = index + 100;
        //        objc_setAssociatedObject(superView, (__bridge const void * _Nonnull)(@(key).stringValue), firstView, OBJC_ASSOCIATION_ASSIGN);
        [HDAssociationManager hd_setAssociatedObject:superView key:@(key).stringValue value:firstView];
        //出队
        [queue removeObjectAtIndex:0];
        //子view入队
        if (firstView.subviews.count && ![self isListView:firstView]) {
            [queue addObjectsFromArray:firstView.subviews];
        }
        index ++;
        
    }
}
+ (BOOL)isListView:(UIView*)view
{
    NSArray *clsArr = @[@"HDCollectionView",@"UITableView",@"UICollectionView"];
    __block BOOL isListV = NO;
    [clsArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([view isKindOfClass:NSClassFromString(obj)]) {
            isListV = YES;
            *stop = YES;
        }
    }];
    return isListV;
}
@end
