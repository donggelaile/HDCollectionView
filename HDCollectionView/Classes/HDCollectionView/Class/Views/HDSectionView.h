//
//  HDSectionView.h
//  
//
//  Created by CHD on 2018/8/9.
//  Copyright © 2018年 chd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HDUpdateUIProtocol.h"
@class HDCollectionView;
@interface HDSectionView : UICollectionReusableView<HDUpdateUIProtocol>
@property (nonatomic, weak, readonly, nullable) HDCollectionView *superCollectionV;
@property (nonatomic, copy, readonly, nonnull) void(^callback)(id _Nullable par);
@property (nonatomic, strong, readonly, nullable) __kindof id<HDSectionModelProtocol> hdSecModel;
@property (nonatomic, strong, readonly, nullable) NSString *currentElementKind;

/// SectionView首次展示时内部调用 (重新reloadData也不会再次调用,  对应的hdModel重新创建后会再次调用)
- (void)sectionViewFirstTimeShow;

/// SectionView 即将展示  ( 来回滑动及reloadData可能会多次调用)
- (void)sectionViewWillShow;

/// SectionView 结束了展示 (来回滑动及reloadData可能会多次调用)
- (void)sectionViewDidEndShow;

@end
