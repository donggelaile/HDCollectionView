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
@property (nonatomic, assign) YGJustify justify;
@property (nonatomic, assign) YGAlign align;
@property (nonatomic, assign) UIEdgeInsets decorationMargin;//decorationView的外边距 不包含heder,footer
@end

NS_ASSUME_NONNULL_END
