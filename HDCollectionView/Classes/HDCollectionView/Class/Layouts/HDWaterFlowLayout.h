//
//  HDWaterFlowLayout.h
//  HDCollectionView
//
//  Created by HaoDong chen on 2019/4/13.
//  Copyright © 2019 CHD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HDBaseLayout.h"
NS_ASSUME_NONNULL_BEGIN

@interface HDWaterFlowLayout : HDBaseLayout
@property (nonatomic, strong) NSArray <NSNumber*>*columnRatioArr;//比如@[@1,@2,@1]
@property (nonatomic, assign) UIEdgeInsets decorationMargin;//decorationView的外边距 不包含heder,footer
@property (nonatomic, strong, readonly) NSArray<NSArray<UICollectionViewLayoutAttributes*>*> *columnAtts;//这是一个二维数组，存放每列/行的属性集合，内部使用
@end

NS_ASSUME_NONNULL_END
