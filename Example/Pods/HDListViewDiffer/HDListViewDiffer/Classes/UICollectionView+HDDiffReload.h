//
//  UICollectionView+HDDiffReload.h
//  HDListViewDiffer_Example
//
//  Created by chenhaodong on 2019/10/18.
//  Copyright © 2019 chenhaodong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HDListViewDiffer.h"
NS_ASSUME_NONNULL_BEGIN

@interface UICollectionView (HDDiffReload)

/// 配置数据，仅支持操作同一段内的数据
/// @param oldArr 数组内元素遵循HDListViewDifferProtocol的旧数据数组
/// @param newArrGenerateCode 生成新数组的代码块
/// @param calculateDiffFinishCb 计算差异完成回调
/// @param sourceDataChangeCode 数据源变更放到此处
/// @param animationFinishCallback 刷新完毕回调
- (void)hd_reloadWithSection:(NSInteger)section
                     oldData:(NSArray<id<HDListViewDifferProtocol>>*)oldArr
          newArrGenerateCode:(NSArray<id<HDListViewDifferProtocol>>*(^)(void))newArrGenerateCode
       calculateDiffFinishCb:(nullable void(^)(void))calculateDiffFinishCb
        sourceDataChangeCode:(void(^)(NSArray<id<HDListViewDifferProtocol>>* newArr))sourceDataChangeCode
     animationFinishCallback:(nullable void(^)(void))animationFinishCallback;


- (void)hd_reloadWithSection:(NSInteger)section
                     oldData:(NSArray<id<HDListViewDifferProtocol>>*)oldArr
                     newData:(NSArray<id<HDListViewDifferProtocol>>*)newArr
        sourceDataChangeCode:(void(^)(NSArray<id<HDListViewDifferProtocol>>* newArr))sourceDataChangeCode
     animationFinishCallback:(nullable void(^)(void))animationFinishCallback;

@end

NS_ASSUME_NONNULL_END
