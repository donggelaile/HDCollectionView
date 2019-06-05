//
//  HDScrollJoinView.h
//  HDCollectionView_Example
//
//  Created by HaoDong chen on 2019/5/29.
//  Copyright © 2019 donggelaile. All rights reserved.
//  每个子滑动子view的最大frame均为HDScrollJoinView的frame，而非将子view的frame设置为其contentSize，主要用于解决多scrollview衔接问题。

//  1、理论上可以拼接任意个数的滑动view及悬浮view。实际中建议3个左右，因为没有复用
//  2、主要用来解决滑动界面上半部分是webview，下半部分是原生滑动列表的情况（例如新闻详情页这种页面）
//  3、传入的对象 这里 写的是 id<HDScrollJoinViewRealScroll>，事实上不是id，必须是UIView或其子类
//  4、注意不要直接对HDScrollJoinView设置delegate，会阻碍内部函数调用。
//  5、如果需要监听相关代理函数，继承HDScrollJoinView后,设置delegate为本身，并在代理函数中判断父类是否实现，实现了则先调父类
//  6、需要悬浮的话实现hd_subViewStopType函数。内部如果嵌套HDCollectionView,请将HDCollectionView的悬浮功能关闭
//  使用示例见:NewsDetailDemoVC

#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN
typedef NS_ENUM(NSInteger,HDScrollJoinViewStopType) {
    HDScrollJoinViewStopTypeWhenNextDismiss,
    HDScrollJoinViewStopTypeAlways
};
@protocol HDScrollJoinViewRealScroll <NSObject>
@optional
- (UIScrollView*)hd_ScrollJoinViewRealScroll;//如果包含scrollview，那么必须实现该方法
- (HDScrollJoinViewStopType)hd_subViewStopType;//如果想某个view悬停，实现该方法（此时无需实现hd_ScrollJoinViewRealScroll）
- (void)hd_properContentSize:(void(^)(CGSize properSize))callback;
@end


@interface HDScrollJoinView : UIScrollView

/**
 配置（建议调用前先将其加到父view上，方便内部计算布局)
 
 @param listViews  遵循HDScrollJoinViewRealScroll协议的UIView对象 组成的数组
 */

- (void)hd_setListViews:(NSArray< id<HDScrollJoinViewRealScroll>>*)listViews scrollDirection:(UICollectionViewScrollDirection)scrollDirection;
@end

NS_ASSUME_NONNULL_END
