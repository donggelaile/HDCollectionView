//
//  HDCollectionView+HDHelper.h
//
//  Created by chd on 2019/9/24.
//  Copyright © 2019 chd. All rights reserved.
//

// 该分类是为解决外部一次性赋值大量数据时出现卡顿而添加的
// 尤其当设置sectionModel需要自动算高时，一次性设置大量数据会造成短时间内主线程卡顿
// 本质就是将hd_setAllDataArr拆分为hd_appendDataWithSecModel，按需加载

#import <HDCollectionView/HDCollectionView.h>

NS_ASSUME_NONNULL_BEGIN

@interface HDCollectionView (HDHelper)

/**
* 内部按段(section)加载，渐进式加载
 该函数的目的是拆分计算cell宽高，因为同时计算dataArr中所有cell的宽高有时会耗费大量时间，造成主线程卡顿
 计算cell宽高指的是通过autoLayout计算cell合适高度，真正布局阶段也会耗费一定时间(计算cell.frame.orign)
 适用场景：某个页面服务端一次性返回1000条数据，服务器不提供分页。此时一次性计算所有cell的宽高会特别卡
 此时外部可以分成100个section，每个section放10个cell。内部会自动根据滑动的范围计算当前需要计算哪段数据。(注意不要分成1个section，里面1000个cell，因为内部是按段加载的)
 
 需要加载更多时请调用 hd_appendSecSlowly函数,其他函数不要调用
 
* @param dataArr 全部数据
*/
- (void)hd_setAllDataArrSlowly:(NSArray<id<HDSectionModelProtocol>> *)dataArr preloadOffset:(NSInteger)preloadOffset currentCalculateSectionFinishCallback:(nullable void(^)(NSInteger curSection))callback;

/**
专门配合hd_setAllDataArrSlowly使用，其他情况调用无效
*/
- (void)hd_appendSecSlowly:(id<HDSectionModelProtocol>)secModel;


/**
 根据cellModelArr，pageCount 获取分段的HDSectionModel数组
 secConfig中无需配置secModel.sectionDataArr，内部会设置
*/
+ (NSArray<HDSectionModel*>*)hd_getSectionsByPageCount:(NSInteger)pageCount hdCellModelArr:(NSArray<id<HDCellModelProtocol>>*)cellModelArr secConfiger:(id<HDSectionModelProtocol>(^)(NSInteger section))secConfig;
@end

NS_ASSUME_NONNULL_END
