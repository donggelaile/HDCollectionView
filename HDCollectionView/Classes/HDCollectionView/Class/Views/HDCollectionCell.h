//
//  HDCollectionCell.h
//  
//
//  Created by CHD on 2018/8/9.
//  Copyright © 2018年 chd. All rights reserved.
//

// cell的子view建议全部添加到cell.contentView上，而非直接加在cell上
// 否则使用autoLayout计算自适应高度时可能会不对

#import <UIKit/UIKit.h>
#import "HDUpdateUIProtocol.h"
#import "HDDefines.h"

NS_ASSUME_NONNULL_BEGIN

@class HDCollectionView;

@interface HDCollectionCell : UICollectionViewCell<HDUpdateUIProtocol>

/**
 cell内部调用此callback会调到HDCollectionView对象设置的hd_setAllEventCallBack回调块
 外部无需赋值，直接调用即可，无需判断callback是否为空
 */
@property (nonatomic, copy, readonly) void(^callback)(_Nullable id par);
@property (nonatomic, strong, readonly, nullable) __kindof id<HDCellModelProtocol> hdModel;
@property (nonatomic, weak, readonly, nullable) HDCollectionView *superCollectionV;

- (void)hd_superDataSetFinishCallback:(void(^)(void))dataSetFinish;

/// cell首次展示时内部调用 (用于计算宽高的tempCell不会调用此函数, 重新reloadData也不会再次调用,  对应的hdModel重新创建后会再次调用)
- (void)cellFirstTimeShow;

/// cell 即将展示  (用于计算宽高的tempCell不会调用此函数,  来回滑动及reloadData可能会多次调用)
- (void)cellWillShow;

/// cell 结束了展示 (用于计算宽高的tempCell不会调用此函数,  来回滑动及reloadData可能会多次调用)
- (void)cellDidEndShow;


@end

NS_ASSUME_NONNULL_END
