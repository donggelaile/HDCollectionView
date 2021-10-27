//
//  HDFlowLayout.h
//  HDCollectionView
//
//  Created by HaoDong chen on 2019/3/14.
//  Copyright © 2019 CHD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HDBaseLayout.h"
#import <yoga/YGEnums.h>
NS_ASSUME_NONNULL_BEGIN

@interface HDYogaFlowLayoutChainMaker : HDBaseLayoutChainMaker

//这里把父类的API拷贝过来,改变block返回值为子类 类型 ,否则在创建时使用了父类block属性后将无法在继续链式调用子类属性
@property (nonatomic, strong, readonly)  HDYogaFlowLayoutChainMaker* (^hd_headerSize)(CGSize headerSize);
@property (nonatomic, strong, readonly)  HDYogaFlowLayoutChainMaker* (^hd_footerSize)(CGSize footerSize);
/// 该段内cell的size,优先级低于HDCellModel的cellSize
@property (nonatomic, strong, readonly)  HDYogaFlowLayoutChainMaker* (^hd_cellSize)(CGSize cellSize);
@property (nonatomic, strong, readonly)  HDYogaFlowLayoutChainMaker* (^hd_secInset)(UIEdgeInsets secInset);
@property (nonatomic, strong, readonly)  HDYogaFlowLayoutChainMaker* (^hd_verticalGap)(CGFloat verticalGap);
@property (nonatomic, strong, readonly)  HDYogaFlowLayoutChainMaker* (^hd_horizontalGap)(CGFloat horizontalGap);

/**
主轴对齐方式，纵向滑动时为水平对齐方式，横向滑动反之
*/
@property (nonatomic, strong, readonly)  HDYogaFlowLayoutChainMaker* (^hd_justify)(YGJustify justify);

/**
是否反向摆放控件(默认NO,设为YES后纵向滑动将从屏幕最右侧向左侧开始摆放控件,横向滑动时将从最底部开始向顶部摆放控件)
*/
@property (nonatomic, strong, readonly)  HDYogaFlowLayoutChainMaker* (^hd_reverseRowOrColumn)(BOOL reverseRowOrColumn);

/**
侧轴对齐方式(不建议设置为 YGAlignSpaceBetween,YGAlignSpaceAround 设置后出来的效果应该不是你想要的，这可能是Yoga的feature)
*/
@property (nonatomic, strong, readonly)  HDYogaFlowLayoutChainMaker* (^hd_align)(YGAlign align);

/**
decorationView的外边距 不包含heder,footer
*/
@property (nonatomic, strong, readonly)  HDYogaFlowLayoutChainMaker* (^hd_decorationMargin)(UIEdgeInsets decorationMargin);

@end

@interface HDYogaFlowLayout : HDBaseLayout
/**
 主轴对齐方式，纵向滑动时为水平对齐方式，横向滑动反之
 */
@property (nonatomic, assign) YGJustify justify;

/**
 是否反向摆放控件(默认NO,设为YES后纵向滑动将从屏幕最右侧向左侧开始摆放控件,横向滑动时将从最底部开始向顶部摆放控件)
 */
@property (nonatomic, assign) BOOL reverseRowOrColumn;

/**
 侧轴对齐方式(不建议设置为 YGAlignSpaceBetween,YGAlignSpaceAround 设置后出来的效果应该不是你想要的，这可能是Yoga的feature)
 */
@property (nonatomic, assign) YGAlign align;
@property (nonatomic, assign) UIEdgeInsets decorationMargin;//decorationView的外边距 不包含heder,footer
@end

NS_ASSUME_NONNULL_END
