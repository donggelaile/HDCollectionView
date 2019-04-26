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

@class HDSectionModel;

@interface HDCellModel : NSObject

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
 仅在layout为HDFlowLayout生效，cell外边距
 */
@property (nonatomic, assign) UIEdgeInsets margin;


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
 */
@property (nonatomic, strong) id context;

@property (nonatomic, weak, readonly) HDSectionModel *secModel;

@end


