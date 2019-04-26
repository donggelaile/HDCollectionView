//
//  HDSectionModel.h
//  HDCollectionView
//
//  Created by HaoDong chen on 2018/11/5.
//  Copyright © 2018年 CHD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "HDCellModel.h"
#import "HDBaseLayout.h"

static NSString *HDDecorationViewKind = @"HDDecorationViewKind";

typedef NS_ENUM(NSInteger,HDHeaderStopOnTopType) {
    HDHeaderStopOnTopTypeNone, //不悬停，默认
    HDHeaderStopOnTopTypeNormal,//当本段内的cell及footer滑出后会跟着滑出
    HDHeaderStopOnTopTypeAlways//始终悬停在顶部(纵向滑动)或左部(横向滑动)，多个悬停的相遇后，后面的会在其后悬停
};

@interface HDSectionModel: NSObject<NSCopying>

/**
 默认nil,header类型，如果设置 必须是UICollectionReusableView或其子类
 */
@property (nonatomic, copy, nullable) NSString * sectionHeaderClassStr;

/**
 默认nil,footer类型，如果设置 必须是UICollectionReusableView或其子类
 */
@property (nonatomic, copy, nullable) NSString * sectionFooterClassStr;

/**
 默认nil,section内默认cell的类型, HDCellModel中的cellClassStr不为空时忽略该属性
 */
@property (nonatomic, copy) NSString * sectionCellClassStr;

/**
 默认nil,段头模型对象
 */
@property (nonatomic, strong) id headerObj;

/**
 默认nil,段尾模型对象
 */
@property (nonatomic, strong) id footerObj;

/**
 默认NO,是否需要自动算该段cell高度/宽度（为YES时默认使用AutoLayout计算，需要自动算高则HDCellModel的cellSize的height设为0，自动算宽反之）
 对于需要适配屏幕旋转的页面,设置HDCellModel的cellSizeCb属性即可
 */
@property (nonatomic, assign) BOOL isNeedAutoCountCellHW;

/**
 默认NO, 是否强制使用hdSizeThatFits函数算宽高(需要在cell中实现hdSizeThatFits函数,isNeedAutoCountCellHW为YES时才会考虑该属性)
 */
@property (nonatomic, assign) BOOL isForceUseHdSizeThatFits;

/**
 默认NO, 该段内cell是否需要缓存子view的frame(如果设置为YES,则该section内的cell需要实现cacheSubviewsFrameBySetLayoutWithCellModel函数)
 */
@property (nonatomic, assign) BOOL isNeedCacheSubviewsFrame;

/**
 默认HDHeaderStopOnTopTypeNone, 该段 段头悬停类型(HDCollectionView的isNeedTopStop为YES才会生效)
 */
@property (nonatomic, assign) HDHeaderStopOnTopType headerTopStopType;

/**
 默认会初始化一个可变空数组,用于存放所有子model(初始化完毕后，不要直接增删元素。需要增删请使用HDCollectionView提供的接口)
 */
@property (nonatomic, strong) NSMutableArray<HDCellModel*> *sectionDataArr;

/**
 默认nil,存放该段布局
 */
@property (nonatomic, strong) __kindof HDBaseLayout *layout;

/**
 默认为section。如果对其赋值了，则可以通过该key来获取对应的sectionModel
 */
@property (nonatomic, strong) NSString *sectionKey;

/**
 装饰view的类（仅支持 HDYogaFlowLayout及HDWaterFlowLayout）
 一个段对应一个 decorationView
 */
@property (nonatomic, strong) NSString *decorationClassStr;

/**
 装饰view的数据
 */
@property (nonatomic, strong) id decorationObj;

@property (nonatomic, assign, readonly) BOOL isFinalSection;
@property (nonatomic, assign, readonly) NSInteger section;

/**
 header/footer多个点击事件时，可自行赋值区分
 */
@property (nonatomic, strong) id context;

@end


