//
//  HDCollectionCell.h
//  
//
//  Created by CHD on 2018/8/9.
//  Copyright © 2018年 chd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HDUpdateUIProtocol.h"
#import "HDDefines.h"
@class HDCollectionView;

@interface HDCollectionCell : UICollectionViewCell<HDUpdateUIProtocol>

/**
 cell内部调用此callback会调到HDCollectionView对象设置的hd_setAllEventCallBack回调块
 外部无需赋值，直接调用即可，无需判断callback是否为空
 */
@property (nonatomic, copy, readonly) void(^callback)(id par);
@property (nonatomic, strong, readonly) __kindof HDCellModel * hdModel;
@property (nonatomic, weak, readonly) HDCollectionView *superCollectionV;


- (void)hd_superDataSetFinishCallback:(void(^)(void))dataSetFinish;
@end

