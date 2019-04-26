//
//  HDCollectionCell.h
//  
//
//  Created by CHD on 2018/8/9.
//  Copyright © 2018年 chd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HDUpdateUIProtocol.h"

@class HDCollectionView;

@interface HDCollectionCell : UICollectionViewCell<HDUpdateUIProtocol>
@property (nonatomic, copy) void(^callback)(id par, HDCallBackType type);
@property (nonatomic, strong) __kindof HDCellModel * hdModel;
@property (nonatomic, weak) HDCollectionView *superCollectionV;

- (void)hd_ReloadCollectionView;
@end

