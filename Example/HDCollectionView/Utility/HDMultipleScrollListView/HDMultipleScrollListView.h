//
//  HDMultipleScrollListView.h
//  HDCollectionView_Example
//
//  Created by HaoDong chen on 2019/5/20.
//  Copyright © 2019 donggelaile. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <HDCollectionView/HDCollectionView.h>
#import <JXCategoryView/JXCategoryView.h>

NS_ASSUME_NONNULL_BEGIN

@protocol HDMultipleScrollListViewScrollViewDidScroll <NSObject>
@required
- (void)HDMultipleScrollListViewScrollViewDidScroll:(void(^)(UIScrollView*))ScrollCallback;
@end

@interface HDMultipleScrollListConfiger : NSObject
@property (nonatomic, strong, nullable) NSMutableArray <HDSectionModel*> *topSecArr;
@property (nonatomic, strong) NSMutableArray <UIViewController<HDMultipleScrollListViewScrollViewDidScroll> *> *controllers;
@property (nonatomic, strong) NSMutableArray <NSString*> *titles;
@property (nonatomic, assign) CGSize titleContentSize;
@property (nonatomic, assign) BOOL isHeaderNeedStop;

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
