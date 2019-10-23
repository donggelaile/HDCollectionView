//
//  UITableView+HDDiffReload.h
//  HDListViewDiffer_Example
//
//  Created by chenhaodong on 2019/10/22.
//  Copyright © 2019 chenhaodong. All rights reserved.
//

#import "HDListViewDiffer.h"
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UITableView (HDDiffReload)
/// 配置数据，仅支持操作同一段内的数据
/// @param oldArr 数组内元素遵循HDListViewDifferProtocol的旧数据数组
/// @param newArr 数组内元素遵循HDListViewDifferProtocol的新数据数组
/// @param animation 动画类型
/// @param sourceDataChangeBlock 数据源的变更必须放到此block中
/// @param dataChangeFinishCallback 刷新完毕回调
- (void)hd_reloadWithSection:(NSInteger)section
                     oldData:(NSArray<id<HDListViewDifferProtocol>>*)oldArr
                     newData:(NSArray<id<HDListViewDifferProtocol>>*)newArr
                rowAnimation:(UITableViewRowAnimation)animation
        sourceDataChangeCode:(void(^)(void))sourceDataChangeBlock
    dataChangeFinishCallback:(void(^)(void))dataChangeFinishCallback;
@end

NS_ASSUME_NONNULL_END
