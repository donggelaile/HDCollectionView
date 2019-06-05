//
//  HDCellModel.h
//  
//
//  Created by CHD on 2018/8/9.
//  Copyright © 2018年 chd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "YGEnums.h"

@protocol HDConvertOrgModelToViewModel <NSObject>
@optional
- (void)convertOrgModelToViewModel;
@end

@class HDSectionModel;

@interface HDCellModel : NSObject<HDConvertOrgModelToViewModel>

/**
 原始数据Model
 */
@property (nonatomic, strong) id orgData;

/**
 默认CGSizeZero,优先级高于secM的cellSize。设置后优先使用该属性
 */
@property (nonatomic, assign) CGSize cellSize;

/**
 回调方式获取cellSize,优先级最高（一般需要适配横竖屏时使用该属性返回cell大小,内部必须弱应用self）
 */
@property (nonatomic, copy) CGSize(^cellSizeCb)(void);

/**
 默认nil,优先级高于secM的sectionCellClassStr，设置后优先使用
 */
@property (nonatomic, strong) NSString *cellClassStr;

/**
 自适应高度时是否强制使用对应cell的hd_sizeThatFit返回的高度
 */
@property (nonatomic, assign) BOOL isForceUseSizeThatFitH;

/**
 仅在layout为HDFlowLayout生效，cell在交叉轴的对齐方式
 */
@property (nonatomic, assign) YGAlign alignSelf;

/**
 仅在layout为HDFlowLayout生效，cell外边距。用于单独控制某个cell与其他cell间的间距
 假设纵向滑动下，设置HDYogaFlowLayout的verticalGap为10，并设置第一个cellModel的margin = UIEdgeInsetsMake(0, 0, 20, 0);
 那么第一个cell与第二个cell的纵向间距将为20+10，其他cell纵向间距仍为10
 */
@property (nonatomic, assign) UIEdgeInsets margain;

/**
 默认为cellClassStr
 */
@property (nonatomic, strong) NSString *reuseIdentifier;


/**
 内部自动赋值
 */
@property (nonatomic, strong, readonly) NSIndexPath *indexP;

/**
 开启缓存cell子view frame时内部使用
 */
@property (nonatomic, strong, readonly) NSMutableArray *subviewsFrame;

/**
 当cell中有多个点击事件时，使用context区分
  使用完毕后建议赋值为nil，防止由于保留上个值而出现问题，见DemoVC6Cell
 */
@property (nonatomic, strong) id context;

/**
 对sectionModel的一个弱引用
 */
@property (nonatomic, weak, readonly) HDSectionModel *secModel;

/**
 是否转换了原始model（内部使用，外部无需干预）
 一般可以将子类化的HDCellModel作为cell的viewModel，子类化的HDCellModel实现HDConvertOrgModelToViewModel代理来转换原始model
 每个子类化的HDCellmodel对象只会调用一次 - (void)convertOrgModelToViewModel 转换函数
 */
@property (nonatomic, assign) BOOL isConvertedToVM;

/**
 最终cell在collectionView上的xy坐标
 */
@property (nonatomic, assign, readonly) CGPoint cellFrameXY;
/**
 根据当前配置的参数计算当前cell的大小
 */
- (CGSize)calculateCellProperSize:(BOOL)isNeedCacheSubviewsFrame;

@end


