//
//  HDCollectionView+MultipleScroll.h
//  HDCollectionView_Example
//
//  Created by HaoDong chen on 2019/5/19.
//  Copyright © 2019 donggelaile. All rights reserved.
//

#import <HDCollectionView/HDCollectionView.h>

NS_ASSUME_NONNULL_BEGIN

@interface HDCollectionView(MultipleScroll)
- (void)hd_autoDealScrollViewDidScrollEvent:(UIView*)subScrollContentView currentScrollingSubView:(UIScrollView*)currentScrollV topH:(CGFloat)topH;
@end

NS_ASSUME_NONNULL_END
