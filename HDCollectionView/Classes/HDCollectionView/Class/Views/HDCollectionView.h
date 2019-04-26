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
#import "HDYogaFlowLayout.h"
#import "HDWaterFlowLayout.h"

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
@property (nonatomic, strong, readonly) HDCollectionViewMaker*  (^hd_isNeedTopStop)(BOOL  isNeedTopStop);
/**
 默认NO， 是否在Runloop的commenModes计算cell高度。默认在defaultMode计算(这样做的结果是当网络数据返回后如果用户正在滑动屏幕，则不会刷新数据，直至松开屏幕)
 */
@property (nonatomic, strong, readonly) HDCollectionViewMaker*  (^hd_isCalculateCellHOnCommonModes)(BOOL  isCalculateCellHOnCommonModes);
/**
 默认NO,是否使用基于UICollectionViewFlowLayout的布局(未YES时只支持HDBaseLayout)
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
@end

@interface HDCollectionView : UIView <UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,HDInnerCollectionViewClass>

/**
 全局设置HDCollectionView的默认值
 */
+ (void)hd_globalConfigDefaultValue:(void(^)(HDCollectionViewMaker*maker))maker;

/**
 HDCollectionView 初始化 (配置的参数优先级高于默认值)
 */
+ (__kindof HDCollectionView*)hd_makeHDCollectionView:(void(^)(HDCollectionViewMaker*maker))maker;

#pragma mark - 公开方法

typedef NS_ENUM(NSInteger,HDDataChangeType){
    HDDataChangeSetAll,
    HDDataChangeAppendSec,
    HDDataChangeAppendCellModel,
    HDDataChangeDeleteSec,
    HDDataChangeChangeSec,
};

/*
    important/important/important
    所有的数据更改都应该在以下提供的接口中进行，不要直接对某个数组增删元素
 */

/**
 一次性初始化所有数据 (完成后会回调 dataChangeFinishedCallBack)
 */
- (void)hd_setAllDataArr:(NSMutableArray<HDSectionModel*>*)dataArr;

/**
直接添加一个新的secModel (完成后会回调 dataChangeFinishedCallBack)
 */
- (void)hd_appendDataWithSecModel:(HDSectionModel*)secModel;

/**
 向某个段内增加cell/默认的sectionKey是第几段
 该方法目前对于瀑布流元素的增加，内部计算是增量计算的。但对于HDYogaFlowLayout会对该段整体重新计算
 如果想增量计算HDYogaFlowLayout，使用hd_appendDataWithSecModel，新增一个新的段。
 */
- (void)hd_appendDataWithCellModelArr:(NSArray<HDCellModel*>*)itemArr sectionKey:(NSString*)sectionKey;

/**
 如果仅仅是向secModel新增cellModel，使用 hd_appendDataWithCellModelArr方法
 该方法改变已有的某个section内的数据，比如对sectionDataArr增删
 如果设置了HDSectionModel的sectionKey，则可以通过sectionKey来获取secModel。默认的sectionKey是当前段数
 */
- (void)hd_changeSectionModelWithKey:(NSString*)sectionKey changingIn:(void(^)(HDSectionModel*secModel))changeBlock;

/**
 删除某段的所有内容
 */
- (void)hd_deleteSectionWithKey:(NSString*)sectionKey;

/**
 某个key的ectionModel是否存在
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
 忽视缓存，重新计算所有布局(不会重新计算cell的高度)
 */
- (void)hd_forceReloadData;

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

//设置内部UICollectionView手势与其他手势间的响应 (CollectionView多层嵌套时可能使用)
- (void)hd_setShouldRecognizeSimultaneouslyWithGestureRecognizer:(BOOL(^)(UIGestureRecognizer*selfGestture,UIGestureRecognizer*otherGesture))multiGestureCallBack;
//设置cell及section后的回调 
- (void)hd_setCellUIUpdateCallback:(void(^)(__kindof UICollectionViewCell*cell,NSIndexPath*indexP))setedCallback;
- (void)hd_setSecViewUIUpdateCallback:(void(^)(__kindof UICollectionReusableView*secView,NSIndexPath*indexP,NSString* kind))setedCallback;

@property (nonatomic, strong, readonly) HDInnerCollectionView *collectionV;
@property (nonatomic, assign, readonly) BOOL isNeedTopStop;
@property (nonatomic, assign, readonly) BOOL isCalculateCellHOnCommonModes;
@property (nonatomic, assign, readonly) BOOL isUseSystemFlowLayout;
@property (nonatomic, assign, readonly) UICollectionViewScrollDirection scrollDirection;
@property (nonatomic, assign, readonly) BOOL isNeedAdaptScreenRotaion;

@end
