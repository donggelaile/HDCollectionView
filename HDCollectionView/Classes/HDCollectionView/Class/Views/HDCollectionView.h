//
//  HDCollectionView.h
//  
//
//  Created by CHD on 2018/8/9.
//  Copyright © 2018年 chd. All rights reserved.
//

#import "HDCellModel.h"
#import "HDCollectionCell.h"
#import "HDSectionModel.h"
#import "HDSectionView.h"
#import "HDUpdateUIProtocol.h"
#import "HDModelProtocol.h"
#import "HDYogaFlowLayout.h"
#import "HDWaterFlowLayout.h"
#import "HDDefines.h"

NS_ASSUME_NONNULL_BEGIN

#define HDCVScrollViewDidScrollNotificationName  @"HDCVScrollViewDidScrollNotificationName"

typedef NS_ENUM(NSInteger,HDCollectionViewEventDealPolicy) {
    HDCollectionViewEventDealPolicyBySubView,//默认，让cell或sectionView自己处理
    HDCollectionViewEventDealPolicyInstead,//直接由HDCollectionView处理
    HDCollectionViewEventDealPolicyAfterSubView,//在subView处理完后，HDCollectionView再进行进一步处理
    HDCollectionViewEventDealPolicyBeforeSubView,//在子view处理之前，HDCollectionView先处理
};


@protocol HDInnerCollectionViewClass <NSObject>
@optional
//需要自定义内部UICollectionView类型的时候实现该协议
- (Class)HDInnerCollectionViewClass;
@end

@interface HDInnerCollectionView : UICollectionView
@end

@interface HDCollectionViewMaker : NSObject
/**
 默认NO,是否需要header悬停,不需要悬停请不要设置为YES（如果设置的scrollDirection == UICollectionViewScrollDirectionVertical则会在左侧悬停）
 */
@property (nonatomic, strong, readonly)  HDCollectionViewMaker* (^hd_isNeedTopStop)(BOOL  isNeedTopStop);

/**
 默认NO,是否使用基于UICollectionViewFlowLayout的布局(为YES时只支持HDBaseLayout)
 */
@property (nonatomic, strong, readonly) HDCollectionViewMaker*  (^hd_isUseSystemFlowLayout)(BOOL  isUseSystemFlowLayout);
/**
 默认垂直滚动
 */
@property (nonatomic, strong, readonly) HDCollectionViewMaker*  (^hd_scrollDirection)(UICollectionViewScrollDirection  scrollDirection);
/**
 默认NO,是否在屏幕旋转时重新布局UI（一般配合HDBaseLayout的headerSizeCb/footerSizeCb及HDCellModel的cellSizeCb使用）
 */
@property (nonatomic, strong, readonly) HDCollectionViewMaker*  (^hd_isNeedAdaptScreenRotaion)(BOOL isNeedAdaptScreenRotaion);
@property (nonatomic, strong, readonly) HDCollectionViewMaker*  (^hd_frame)(CGRect frame);
/**
配置结束时调用 ( 主要是在swift中调用，因为不调会有警告)
*/
@property (nonatomic, strong, readonly) void (^hd_endConfig)(void);
@end

@interface HDCollectionView : UIView <UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,HDInnerCollectionViewClass>

/**
 全局设置HDCollectionView的默认值
 */
+ (void)hd_globalConfigDefaultValue:(void(^ _Nullable)(HDCollectionViewMaker*maker))maker;

/**
 HDCollectionView 初始化 (配置的参数优先级高于默认值)
 */
+ (__kindof HDCollectionView*)hd_makeHDCollectionView:(void(^ _Nullable)(HDCollectionViewMaker*maker))maker;

#pragma mark - 公开方法

typedef NS_ENUM(NSInteger,HDDataChangeType){
    HDDataChangeSetAll,
    HDDataChangeAppendSec,
    HDDataChangeAppendCellModel,
    HDDataChangeDeleteSec,
    HDDataChangeChangeSec,
};

void HDDoSomeThingInMode(NSRunLoopMode mode,void(^thingsToDo)(void));

/*
    important/important/important
    所有的数据更改都应该在以下提供的接口中进行，不要直接对某个数组增删元素，变更后无需调用 reloadData（内部会调用）
 */

/**
 一次性初始化所有数据 (完成后会回调 dataChangeFinishedCallBack)
 */
- (void)hd_setAllDataArr:(NSArray<id<HDSectionModelProtocol>>* _Nullable)dataArr;

/**
直接添加一个新的secModel (完成后会回调 dataChangeFinishedCallBack)
 */
- (void)hd_appendDataWithSecModel:(id<HDSectionModelProtocol>)secModel animated:(BOOL)animated;

/**
 向某个段内增加cell/默认的sectionKey是第几段
 该方法目前对于瀑布流元素的增加，内部计算是增量计算的。但对于HDYogaFlowLayout会对该段整体重新计算
 如果想增量计算HDYogaFlowLayout，使用hd_appendDataWithSecModel，新增一个新的段。
 */
- (void)hd_appendDataWithCellModelArr:(NSArray<id<HDCellModelProtocol>>*)itemArr sectionKey:(NSString*)sectionKey animated:(BOOL)animated animationFinishCallback:(void(^ _Nullable)(void))animationFinish;
- (void)hd_appendDataWithCellModelArr:(NSArray<id<HDCellModelProtocol>>*)itemArr sectionKey:(NSString*)sectionKey animated:(BOOL)animated;

/**
 如果仅仅是向secModel新增cellModel，使用 hd_appendDataWithCellModelArr方法
 该方法改变已有的某个section内的数据，比如对sectionDataArr增删
 如果设置了SectionModel的sectionKey，则可以通过sectionKey来获取secModel。默认的sectionKey是当前段数
 想要刷新一个或几个cell的UI时，调用此方法
 */
- (void)hd_changeSectionModelWithKey:(nullable NSString*)sectionKey animated:(BOOL)animated changingIn:(void(^)(id<HDSectionModelProtocol> secModel))changeBlock animationFinishCallback:(void(^ _Nullable)(void))animationFinish;
- (void)hd_changeSectionModelWithKey:(nullable NSString*)sectionKey animated:(BOOL)animated changingIn:(void(^)(id<HDSectionModelProtocol> secModel))changeBlock;

/**
 删除某段的所有内容
 */
- (void)hd_deleteSectionWithKey:(nullable NSString*)sectionKey animated:(BOOL)animated animationFinishCallback:(void(^ _Nullable)(void))animationFinish;
- (void)hd_deleteSectionWithKey:(nullable NSString*)sectionKey animated:(BOOL)animated;
/**
 某个key的sectionModel是否存在
 */
- (BOOL)hd_sectionModelExist:(NSString*)sectionKey;

/**
包含所有数据改变相关方法完成后的回调（即setAll/append/delete/change相关的函数完成后都会在此回调）
 */
- (void)hd_dataChangeFinishedCallBack:(void(^)(HDDataChangeType changeType))finishCallback;

/**
 刷新colletionView
 */
- (void)hd_reloadData;

/**
 重新计算某段的布局，其后的段只会更新x/y坐标/
 */
- (void)hd_reloadDataAndSecitonLayout:(NSString*)sectionKey;

/**
 忽视缓存，重新计算所有布局(会重新读取cellSize，如果设置了自动算高这里并不会重算)
 */
- (void)hd_reloadDataAndAllLayout;

/**
 刷新所有，包含cell高度（如果需要自动算高）(一般情况不需要调用此函数)
 */
- (void)hd_reloadAll;

/**
 设置cell/header/footer/decoration中的事件回调
 */
- (void)hd_setAllEventCallBack:(void (^)(id backModel,HDCallBackType type))callback;

#pragma mark - 部分系统回调
// 1、如果需要更多其他回调，可继承HDCollectionView来实现，复写方法前先判断父类是否实现，实现了先调父类。比如@interface YourHDCollectionView:HDCollectionView
// 2、对于内部的UICollectionView，可以让YourHDCollectionView遵循 HDInnerCollectionViewClass协议 来自定义内部的UICollectionView

/**
 设置内部UICollectionView手势与其他手势间的响应 (CollectionView多层嵌套时可能使用)
 */
- (void)hd_setShouldRecognizeSimultaneouslyWithGestureRecognizer:(BOOL(^)(UIGestureRecognizer*selfGestture,UIGestureRecognizer*otherGesture))multiGestureCallBack;

//contentSize发生变化的回调(当数据源较少时，可用于获取colletionView合适的大小)
- (void)hd_setContentSizeChangeCallBack:(void(^)(CGSize newContentSize))contentSizeChangeCallBack;

//滑动事件的相关回调
- (void)hd_setScrollViewDidScrollCallback:(void(^)(UIScrollView *scrollView))callback;
- (void)hd_setScrollViewWillBeginDraggingCallback:(void(^)(UIScrollView *scrollView))callback;
- (void)hd_setScrollViewDidEndDraggingCallback:(void(^)(UIScrollView *scrollView, BOOL decelerate))callback;
- (void)hd_setScrollViewDidEndDeceleratingCallback:(void(^)(UIScrollView *scrollView))callback;

/**
 设置cell及section后的回调
 */
- (void)hd_setCellUIUpdateCallback:(void(^)(__kindof UICollectionViewCell*cell,NSIndexPath*indexP))setedCallback;
- (void)hd_setSecViewUIUpdateCallback:(void(^)(__kindof UICollectionReusableView*secView,NSIndexPath*indexP,NSString* kind))setedCallback;

/**
 用于存储所有子view回调的处理策略，需要外部对字典增删元素，来实现控制某个事件的回调策略
 */
@property (nonatomic, strong, readonly) NSMutableDictionary *allSubViewEventDealPolicy;
@property (nonatomic, strong, readonly) NSArray *innerAllData;
@property (nonatomic, strong, readonly) HDInnerCollectionView *collectionV;
@property (nonatomic, assign, readonly) BOOL isNeedTopStop;
@property (nonatomic, assign, readonly) BOOL isUseSystemFlowLayout;
@property (nonatomic, assign, readonly) UICollectionViewScrollDirection scrollDirection;
@property (nonatomic, assign, readonly) BOOL isNeedAdaptScreenRotaion;
@property (nonatomic, assign, readonly) BOOL isInnerDataEmpty;//内部数据是否为空
@property (nonatomic, assign, readonly) BOOL isDeletingSection;
@property (nonatomic, assign, readonly) BOOL isAppendingSection;

- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithFrame:(CGRect)frame NS_UNAVAILABLE;
- (instancetype)new NS_UNAVAILABLE;

@end

NS_ASSUME_NONNULL_END
