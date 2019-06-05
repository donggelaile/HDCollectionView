//
//  HDFlowLayout.h
//  HDCollectionView
//
//  Created by HaoDong chen on 2019/3/14.
//  Copyright © 2019 CHD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HDBaseLayout.h"
#import "YGEnums.h"
NS_ASSUME_NONNULL_BEGIN

@interface HDYogaFlowLayout : HDBaseLayout
/**
 主轴对齐方式，纵向滑动时为水平对齐方式，横向滑动反之
 */
@property (nonatomic, assign) YGJustify justify;

/**
 侧轴对齐方式(不建议设置为 YGAlignSpaceBetween,YGAlignSpaceAround 设置后出来的效果应该不是你想要的，这可能是Yoga的feature)
 */
@property (nonatomic, assign) YGAlign align;
@property (nonatomic, assign) UIEdgeInsets decorationMargin;//decorationView的外边距 不包含heder,footer
@end

NS_ASSUME_NONNULL_END
