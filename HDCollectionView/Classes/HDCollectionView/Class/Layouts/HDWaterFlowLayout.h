//
//  HDWaterFlowLayout.h
//  HDCollectionView
//
//  Created by HaoDong chen on 2019/4/13.
//  Copyright © 2019 CHD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HDBaseLayout.h"
NS_ASSUME_NONNULL_BEGIN

/*
 瀑布流布局内的HDCellModel的cellSize的width设置为0即可,高度需要自己设置
 因为内部会根据secInset/vGap/hGap/columnRatioArr等自动计算该cellModel的width
 对于横向滑动的瀑布流,cellSize.heght设置为0即可
 */

@interface HDWaterFlowLayoutChainMaker : HDBaseLayoutChainMaker

//这里把父类的API拷贝过来,改变block返回值为子类 类型 ,否则在创建时使用了父类block属性后将无法在继续链式调用子类属性
@property (nonatomic, strong, readonly)  HDWaterFlowLayoutChainMaker* (^hd_headerSize)(CGSize headerSize);
@property (nonatomic, strong, readonly)  HDWaterFlowLayoutChainMaker* (^hd_footerSize)(CGSize footerSize);
/// 该段内cell的size,优先级低于HDCellModel的cellSize
@property (nonatomic, strong, readonly)  HDWaterFlowLayoutChainMaker* (^hd_cellSize)(CGSize cellSize);
@property (nonatomic, strong, readonly)  HDWaterFlowLayoutChainMaker* (^hd_secInset)(UIEdgeInsets secInset);
@property (nonatomic, strong, readonly)  HDWaterFlowLayoutChainMaker* (^hd_verticalGap)(CGFloat verticalGap);
@property (nonatomic, strong, readonly)  HDWaterFlowLayoutChainMaker* (^hd_horizontalGap)(CGFloat horizontalGap);

/*
比如@[@1,@2,@1]。代表总共三列(纵向滑动时),三列宽度的权重分别是1/2/1
横向滑动时则代表高度权重
*/
@property (nonatomic, strong, readonly)  HDWaterFlowLayoutChainMaker* (^hd_columnRatioArr)(NSArray <NSNumber*>*columnRatioArr);

/*
decorationView的外边距 不包含heder,footer
*/
@property (nonatomic, strong, readonly)  HDWaterFlowLayoutChainMaker* (^hd_decorationMargin)(UIEdgeInsets decorationMargin);

/*
默认NO，这个参数是来调整第一个数据从哪里开始摆放的。纵向滑动时，默认从左边开始摆放。横向滑动时，默认从顶部开始摆放。
置为YES后将按反方向先开始摆放
*/
@property (nonatomic, strong, readonly)  HDWaterFlowLayoutChainMaker* (^hd_isFirstAddAtRightOrBottom)(BOOL isFirstAddAtRightOrBottom);


@end

@interface HDWaterFlowLayout : HDBaseLayout
/*
 比如@[@1,@2,@1]。代表总共三列(纵向滑动时),三列宽度的权重分别是1/2/1
 横向滑动时则代表高度权重
 */
@property (nonatomic, strong) NSArray <NSNumber*>*columnRatioArr;
//decorationView的外边距 不包含heder,footer
@property (nonatomic, assign) UIEdgeInsets decorationMargin;
/*
 默认NO，这个参数是来调整第一个数据从哪里开始摆放的。纵向滑动时，默认从左边开始摆放。横向滑动时，默认从顶部开始摆放。
 置为YES后将按反方向先开始摆放
*/
@property (nonatomic, assign) BOOL isFirstAddAtRightOrBottom;
@property (nonatomic, strong, readonly) NSArray<NSArray<UICollectionViewLayoutAttributes*>*> *columnAtts;//这是一个二维数组，存放每列/行的属性集合，内部使用
@end

NS_ASSUME_NONNULL_END
