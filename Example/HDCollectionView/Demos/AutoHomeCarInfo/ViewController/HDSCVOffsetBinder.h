//
//  HDSCVOffsetBinder.h
//  HDCollectionView
//
//  Created by HaoDong chen on 2019/4/20.
//  Copyright © 2019 CHD. All rights reserved.
//

/*
//只能按以下步骤实现才能支持多个scrolview联动
step 1.在自定义scrollview的实现中添加
+ (BOOL)automaticallyNotifiesObserversForKey:(NSString *)key
{
    if ([key isEqualToString:@"contentOffset"]) {
        return NO;
    }else{
        return [super automaticallyNotifiesObserversForKey:key];
    }
}
 
step 2.在scrollview的delegate的类中包含HDSCVOffsetBinder并添加
 - (void)scrollViewDidScroll:(UIScrollView *)scrollView
 {
    if (!objc_getAssociatedObject(scrollView, HDContentOffsetIsNotNeedKVONotify)) {
        [scrollView willChangeValueForKey:@"contentOffset"];
    }
    if ([super respondsToSelector:@selector(scrollViewDidScroll:)]) {
        [super scrollViewDidScroll:scrollView];
    }
    if (!objc_getAssociatedObject(scrollView, HDContentOffsetIsNotNeedKVONotify)) {
        [scrollView didChangeValueForKey:@"contentOffset"];
    }
 }
 */

static char * _Nonnull HDContentOffsetIsNotNeedKVONotify = "HDContentOffsetIsNotNeedKVONotify";
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <objc/runtime.h>
NS_ASSUME_NONNULL_BEGIN

@interface UIScrollView (HDSetScrollViewContentOffset)

/**
 外部调用一般设置isNotify为NO
 */
- (void)setContentOffset:(CGPoint)contentOffset needKVONotify:(BOOL)isNotify;
@end

@interface HDSCVOffsetBinder : NSObject
+ (instancetype)shareInstance;

/**
 添加一个sc到指定id的组中
 */
- (void)bindScrollView:(UIScrollView*)scrollView groupID:(NSString*)groupID;

/**
 获取某个组当前偏移量
 */
- (NSValue * __nullable)getCurrentOffsetByGroupID:(NSString*)groupID;


-(instancetype)init NS_UNAVAILABLE;
+(instancetype)new NS_UNAVAILABLE;
+(instancetype)alloc NS_UNAVAILABLE;
@end

NS_ASSUME_NONNULL_END
