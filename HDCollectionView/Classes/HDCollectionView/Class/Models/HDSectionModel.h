//
//  HDSectionModel.h
//  HDCollectionView
//
//  Created by HaoDong chen on 2018/11/5.
//  Copyright © 2018年 CHD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "HDModelProtocol.h"
static NSInteger HDHeaderViewDefaultZindex     = -1000000;
static NSInteger HDFooterViewDefaultZindex     = -1100000;
static NSInteger HDCellDefaultZindex           = -1200000;
static NSInteger HDDecorationViewDefaultZindex = -1500000;

static NSString * _Nonnull HDDecorationViewKind = @"HDDecorationViewKind";

NS_ASSUME_NONNULL_BEGIN

/*
 这里单独使用一个类来进行 HDSectionModel 的链式初始化
 没有放在 HDSectionModel 中是为了防止使用者 将block初始化属性 与 真实属性混淆
 */
@interface HDSectionModelChainMaker : NSObject

//以下所有注释中的默认值，均为HDSectionModel对象对应属性的默认值，并非block的默认值

/**
 默认nil,header类型，如果设置 必须是UICollectionReusableView或其子类
 */
@property (nonatomic, strong, readonly)  HDSectionModelChainMaker* (^hd_sectionHeaderClassStr)(NSString * _Nullable sectionHeaderClassStr);

/**
默认nil,footer类型，如果设置 必须是UICollectionReusableView或其子类
*/
@property (nonatomic, strong, readonly)  HDSectionModelChainMaker* (^hd_sectionFooterClassStr)(NSString * _Nullable sectionFooterClassStr);

/**
 默认nil,section内默认cell的类型, HDCellModel中的cellClassStr不为空时忽略该属性
*/
@property (nonatomic, strong, readonly)  HDSectionModelChainMaker* (^hd_sectionCellClassStr)(NSString * _Nullable sectionCellClassStr);

/**
 默认nil,段头模型对象
*/
@property (nonatomic, strong, readonly)  HDSectionModelChainMaker* (^hd_headerObj)(id _Nullable headerObj);

/**
 默认nil,段尾模型对象
*/
@property (nonatomic, strong, readonly)  HDSectionModelChainMaker* (^hd_footerObj)(id _Nullable footerObj);

/**
 默认NO,是否需要自动算该段cell高度/宽度（为YES时默认首先判断cell是否实现hdSizeThatFits了函数，未实现时则使用AutoLayout计算，需要自动算高则HDCellModel的cellSize的height设为0，自动算宽反之）
 对于需要适配屏幕旋转的页面,设置HDCellModel的cellSizeCb属性即可
*/
@property (nonatomic, strong, readonly)  HDSectionModelChainMaker* (^hd_isNeedAutoCountCellHW)(BOOL isNeedAutoCountCellHW);

/**
 默认NO,当isNeedAutoCountCellHW 为YES才会考虑该属性， 该段内cell是否需要缓存所有子view的frame(如果设置为YES,则该section内的cell需要实现cacheSubviewsFrameBySetLayoutWithCellModel函数)
*/
@property (nonatomic, strong, readonly)  HDSectionModelChainMaker* (^hd_isNeedCacheSubviewsFrame)(BOOL isNeedCacheSubviewsFrame);

/**
 默认HDHeaderStopOnTopTypeNone, 该段 段头悬停类型(HDCollectionView的isNeedTopStop为YES才会生效)
*/
@property (nonatomic, strong, readonly)  HDSectionModelChainMaker* (^hd_headerTopStopType)(HDHeaderStopOnTopType headerTopStopType);

/**
 默认0，header悬浮偏移量 (第0段不建议自定义该值)
*/
@property (nonatomic, strong, readonly)  HDSectionModelChainMaker* (^hd_headerTopStopOffset)(NSInteger headerTopStopOffset);

/**
 默认会初始化一个可变空数组,用于存放所有子model(初始化完毕后，不要直接增删元素。需要增删请使用HDCollectionView提供的接口)
*/
@property (nonatomic, strong, readonly)  HDSectionModelChainMaker* (^hd_sectionDataArr)(NSMutableArray<id<HDCellModelProtocol>>* sectionDataArr);

/**
 默认nil,存放该段布局
*/
@property (nonatomic, strong, readonly)  HDSectionModelChainMaker* (^hd_layout)(__kindof HDBaseLayout *layout);

/**
 默认为section。如果对其赋值了，则可以通过该key来获取对应的sectionModel
 */
@property (nonatomic, strong, readonly)  HDSectionModelChainMaker* (^hd_sectionKey)(NSString * _Nullable sectionKey);

/**
 装饰view的类（仅支持 HDYogaFlowLayout及HDWaterFlowLayout）
 一个段对应一个 decorationView
 */
@property (nonatomic, strong, readonly)  HDSectionModelChainMaker* (^hd_decorationClassStr)(NSString * _Nullable decorationClassStr);

/**
 装饰view的数据
*/
@property (nonatomic, strong, readonly)  HDSectionModelChainMaker* (^hd_decorationObj)(id _Nullable decorationObj);

/**
 一般不需要传，默认生成 HDSectionModel 对象
 传的话，对应类必须遵循 HDSectionModelProtocol协议
 */
@property (nonatomic, strong, readonly)  HDSectionModelChainMaker* (^hd_diySectionModelClassStr)(NSString * _Nullable diySectionModelClassStr);

- (__kindof id<HDSectionModelProtocol>)hd_generateObj;

@end


@interface HDSectionModel: NSObject<NSCopying,HDSectionModelProtocol>

@end

NS_ASSUME_NONNULL_END
