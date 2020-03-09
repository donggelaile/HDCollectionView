//
//  HDCollectionView+MultipleScroll.h
//  HDCollectionView_Example
//
//  Created by HaoDong chen on 2019/5/19.
//  Copyright © 2019 donggelaile. All rights reserved.
//

#import "HDCollectionView.h"
static char * _Nonnull HDMUltipleCurrentSubScrollKey = "HDMUltipleCurrentSubScrollKey";
NS_ASSUME_NONNULL_BEGIN
static char * _Nonnull mianCVMaxOffsetYKey = "mianCVMaxOffsetYKey";
@interface HDCollectionView(MultipleScroll)
@property (nonatomic, weak) UIScrollView *currentSubSc;
- (void)hd_autoDealScrollViewDidScrollEvent:(UIView*)subScrollContentView topH:(CGFloat)topH callback:(void(^)(UIScrollView*))didScrollCb;
@end

NS_ASSUME_NONNULL_END
