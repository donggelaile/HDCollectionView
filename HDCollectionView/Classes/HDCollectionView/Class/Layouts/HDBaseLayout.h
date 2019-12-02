//
//  HDBaseLayout.h
//  HDCollectionView
//
//  Created by HaoDong chen on 2019/4/4.
//  Copyright © 2019 CHD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HDLayoutProtocol.h"
NS_ASSUME_NONNULL_BEGIN

@interface HDBaseLayoutChainMaker : NSObject
@property (nonatomic, strong, readonly) NSMutableDictionary *allValues;

@property (nonatomic, strong, readonly)  HDBaseLayoutChainMaker* (^hd_headerSize)(CGSize headerSize);
@property (nonatomic, strong, readonly)  HDBaseLayoutChainMaker* (^hd_footerSize)(CGSize footerSize);
/// 该段内cell的size,优先级低于HDCellModel的cellSize
@property (nonatomic, strong, readonly)  HDBaseLayoutChainMaker* (^hd_cellSize)(CGSize cellSize);
@property (nonatomic, strong, readonly)  HDBaseLayoutChainMaker* (^hd_secInset)(UIEdgeInsets secInset);
@property (nonatomic, strong, readonly)  HDBaseLayoutChainMaker* (^hd_verticalGap)(CGFloat verticalGap);
@property (nonatomic, strong, readonly)  HDBaseLayoutChainMaker* (^hd_horizontalGap)(CGFloat horizontalGap);

- (__kindof HDBaseLayout*)hd_generateObj;
- (Class)hd_generateLayoutClass;
@end

@interface HDBaseLayout : NSObject<HDLayoutProtocol,NSCopying>
@property (nonatomic, assign) CGSize headerSize;
@property (nonatomic, assign) CGSize footerSize;
@property (nonatomic, assign) CGSize cellSize;
@property (nonatomic, assign) UIEdgeInsets secInset;
@property (nonatomic, assign) CGFloat verticalGap;
@property (nonatomic, assign) CGFloat horizontalGap;


/*
 下面这两个block设置就不提供链式调用了。如果需要，可以在拿到layout对象后再进行以下设置
 主要是担心链式block中再进行block属性的设置时会导致使用者发晕...
 */
/**
 回调方式获取headerSize,优先级最高（一般需要适配横竖屏时使用,内部必须弱引用self）
 */
@property (nonatomic, copy) CGSize(^headerSizeCb)(void);

/**
 回调方式获取footerSize,优先级最高（一般需要适配横竖屏时使用,内部必须弱引用self）
 */
@property (nonatomic, copy) CGSize(^footerSizeCb)(void);
@end

NS_ASSUME_NONNULL_END
