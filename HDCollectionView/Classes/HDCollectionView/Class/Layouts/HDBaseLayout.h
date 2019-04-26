//
//  HDBaseLayout.h
//  HDCollectionView
//
//  Created by HaoDong chen on 2019/4/4.
//  Copyright © 2019 CHD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HDLayoutProtocol.h"
NS_ASSUME_NONNULL_BEGIN

@interface HDBaseLayout : NSObject<HDLayoutProtocol,NSCopying>
@property (nonatomic, assign) CGSize headerSize;
@property (nonatomic, assign) CGSize footerSize;
@property (nonatomic, assign) CGSize cellSize;
@property (nonatomic, assign) UIEdgeInsets secInset;
@property (nonatomic, assign) CGFloat verticalGap;
@property (nonatomic, assign) CGFloat horizontalGap;

/**
 回调方式获取headerSize,优先级最高（一般需要适配横竖屏时使用,内部必须弱应用self）
 */
@property (nonatomic, copy) CGSize(^headerSizeCb)(void);

/**
 回调方式获取footerSize,优先级最高（一般需要适配横竖屏时使用,内部必须弱应用self）
 */
@property (nonatomic, copy) CGSize(^footerSizeCb)(void);
@end

NS_ASSUME_NONNULL_END
