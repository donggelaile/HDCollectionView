//
//  HDCellHeightCountHelper.h
//  HDCollectionView
//
//  Created by HaoDong chen on 2018/11/6.
//  Copyright © 2018 CHD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN


@interface HDCellFrameCacheHelper : NSObject

+ (void)resetViewSubviewFrame:(UIView*)superView subViewFrame:(NSMutableArray<NSValue*>*)subViewFrameArr;
+ (NSMutableArray<NSValue*>*)copySubViewsFrame:(UIView*)superView;

@end

NS_ASSUME_NONNULL_END
