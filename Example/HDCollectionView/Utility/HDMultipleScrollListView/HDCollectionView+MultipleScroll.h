//
//  HDCollectionView+MultipleScroll.h
//  HDCollectionView_Example
//
//  Created by HaoDong chen on 2019/5/19.
//  Copyright © 2019 donggelaile. All rights reserved.
//

#import "HDCollectionView.h"
static NSString * _Nullable HDMUltipleCurrentSubScrollKey = @"HDMUltipleCurrentSubScrollKey";
NS_ASSUME_NONNULL_BEGIN

@interface HDCollectionView(MultipleScroll)
- (void)hd_autoDealScrollViewDidScrollEvent:(UIView*)subScrollContentView topH:(CGFloat)topH curSubSc:(UIScrollView*)curSubSc;
@end

NS_ASSUME_NONNULL_END
