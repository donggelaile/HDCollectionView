//
//  HDCollectionViewLayout.h
//  HDCollectionView
//
//  Created by HaoDong chen on 2019/3/13.
//  Copyright © 2019 CHD. All rights reserved.
//

#import <UIKit/UIKit.h>
static char * _Nonnull HDAttributesIndexKey = "HDAttributesIndexKey";
NS_ASSUME_NONNULL_BEGIN

@interface HDCollectionViewLayout : UICollectionViewLayout
@property (nonatomic, assign) UICollectionViewScrollDirection scrollDirection;
@property (nonatomic, assign) NSInteger HDDataChangeType;
- (void)setAllNeedUpdate;

/**
 刷新某段及其之后的数据
 @param sectionIndex 段位置
 */
- (void)reloadSetionAfter:(NSInteger)sectionIndex;
- (void)updateCurrentXY:(CGPoint)newStart;
@end

NS_ASSUME_NONNULL_END
