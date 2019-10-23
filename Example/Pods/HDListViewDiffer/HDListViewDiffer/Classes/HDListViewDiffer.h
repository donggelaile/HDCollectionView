//
//  HDListViewDiffer.h
//  HDListViewDiffer_Example
//
//  Created by chenhaodong on 2019/10/17.
//  Copyright © 2019 chenhaodong. All rights reserved.
//

// 不考虑存在相同元素的情况,原因如下:
// 1、相同元素时比如 oldArr [1,1,1] newArr [1,1,1,1,1] 此时存在多种解法，且并没有哪种是最优的，因为不清楚实际想在哪里插入
// 2、使用自定义类包装基本数据，并自定义hdDiffIdentifier方法使每项元素不同（内部值仍然相同，假如仍为1），
//    则完全可实现上面的变化，且此时的变化解法相对固定了，与原始动画意图基本一致
// 3、算法简单。。。(好吧，这才是重点)
// 因此，当发现旧数组自己内部存在两个相同元素 或 新数组自己内部存在两个相同元素时，将直接调用 reloadData

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HDCollectionViewUpdateItem : NSObject
@property (nonatomic, readonly, nullable) NSIndexPath *indexPathBeforeUpdate;
@property (nonatomic, readonly, nullable) NSIndexPath *indexPathAfterUpdate;
- (instancetype)initWithIndexPathBeforeUpdate:(nullable NSIndexPath *)indexPathBeforeUpdate
                         indexPathAfterUpdate:(nullable NSIndexPath *)indexPathAfterUpdate;
@end

NS_ASSUME_NONNULL_END


NS_ASSUME_NONNULL_BEGIN

@protocol HDListViewDifferProtocol <NSObject>
@optional
- (NSString*)hdDiffIdentifier;//元素的唯一id
@end

@interface HDListViewDiffer : NSObject
//索引为旧数组索引
@property (nonatomic, strong, readonly, nullable) NSArray<NSIndexPath*> *deletItems;
//索引为新数组索引
@property (nonatomic, strong, readonly, nullable) NSArray<NSIndexPath*> *insertItems;
//索引新旧一致
@property (nonatomic, strong, readonly, nullable) NSArray<NSIndexPath*> *updateItems;
//indexPathBeforeUpdate为旧数组索引，indexPathAfterUpdate为新数组索引
@property (nonatomic, strong, readonly, nullable) NSArray<HDCollectionViewUpdateItem*> *moveItems;
//是否在oldArr中存在相同元素 或 在newArr中存在相同元素
@property (nonatomic, assign) BOOL isExistEqualItemInOldOrNewArr;

/// 配置数据，仅支持同一 section内的数据变化
/// @param oldArr 数组内元素遵循HDListViewDifferProtocol的旧数据数组
/// @param newArr 数组内元素遵循HDListViewDifferProtocol的新数据数组
- (void)setSection:(NSInteger)section oldData:(NSArray<id<HDListViewDifferProtocol>>*)oldArr
                        newData:(NSArray<id<HDListViewDifferProtocol>>*)newArr finishCalback:(void(^)(void))finishcb;


@end

NS_ASSUME_NONNULL_END

