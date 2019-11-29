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
