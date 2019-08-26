//
//  HDMultipleScrollListView.h
//  HDCollectionView_Example
//
//  Created by HaoDong chen on 2019/5/20.
//  Copyright © 2019 donggelaile. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HDCollectionView.h"
#import <JXCategoryView/JXCategoryView.h>

static NSInteger HDMainDefaultTopEdge = 444;

NS_ASSUME_NONNULL_BEGIN
@class HDMultipleScrollListView;
@protocol HDMultipleScrollListViewScrollViewDidScroll <NSObject>
@required
- (void)HDMultipleScrollListViewScrollViewDidScroll:(void(^)(UIScrollView*))ScrollCallback;
@end


#pragma mark - HDMultipleScrollListViewTitleHeader
@interface HDMultipleScrollListViewTitleHeader:HDSectionView
@property (nonatomic, weak) HDMultipleScrollListView *rootView;
@end

@interface HDMultipleScrollListConfiger : NSObject
@property (nonatomic, strong, nullable) NSMutableArray <id<HDSectionModelProtocol>> *topSecArr;
@property (nonatomic, strong) NSMutableArray <UIViewController<HDMultipleScrollListViewScrollViewDidScroll> *> *controllers;
@property (nonatomic, strong) NSMutableArray <NSString*> *titles;
@property (nonatomic, assign) CGSize titleContentSize;//标题滑动列表的大小
@property (nonatomic, assign) BOOL isHeaderNeedStop;
@property (nonatomic, copy) NSString *diyHeaderClsStr;//需要自定义header时设置该参数,必须继承自 HDMultipleScrollListViewTitleHeader
@end


@interface HDMultipleScrollListView : UIView
@property (nonatomic, strong, readonly) HDMultipleScrollListConfiger *confingers;
@property (nonatomic, strong, readonly) JXCategoryTitleView *jxTitle;
@property (nonatomic, strong, readonly) JXCategoryIndicatorLineView *jxLineView;
@property (nonatomic, strong, readonly) HDCollectionView *mainCollecitonV;

- (void)configWithConfiger:(void(^)(HDMultipleScrollListConfiger*configer))config;
- (void)configFinishCallback:(void(^)(HDMultipleScrollListConfiger*configer))configFinish;
@end

NS_ASSUME_NONNULL_END
