//
//  HDCellHeightCountHelper.h
//  HDCollectionView
//
//  Created by HaoDong chen on 2018/11/6.
//  Copyright © 2018 CHD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "HDCollectionCell.h"
NS_ASSUME_NONNULL_BEGIN


@interface HDCollectionCell(subViewFrameCache)
- (void)setCacheKeysIfNeed;
@end

@interface HDCellSubViewFrameCache : NSObject
- (NSString*)cacheKey;
- (CGRect)cacheFrame;
@end

@interface HDCellFrameCacheHelper : NSObject

+ (void)resetViewSubviewFrame:(UIView*)superView subViewFrame:(NSMutableArray<HDCellSubViewFrameCache*>*)subViewFrameArr;
+ (NSMutableArray<HDCellSubViewFrameCache*>*)copySubViewsFrame:(UIView*)superView;
+ (void)setAllsubViewFrameKey:(UIView*)superView;

@end

NS_ASSUME_NONNULL_END
