//
//  HDCollectionView+MultipleScroll.m
//  HDCollectionView_Example
//
//  Created by HaoDong chen on 2019/5/19.
//  Copyright © 2019 donggelaile. All rights reserved.
//

#import "HDCollectionView+MultipleScroll.h"

@implementation HDCollectionView(MultipleScroll)
- (void)hd_autoDealScrollViewDidScrollEvent:(UIView*)subScrollContentView currentScrollingSubView:(nonnull UIScrollView *)currentScrollV topH:(CGFloat)topH
{
    if (!subScrollContentView || !currentScrollV) {
        return;
    }
    __weak typeof(self) weakS = self;
    [self hd_setScrollViewDidScrollCallback:^(UIScrollView *scrollView) {

        if (currentScrollV.contentOffset.y>0) {
            weakS.collectionV.contentOffset = CGPointMake(weakS.collectionV.contentOffset.x, topH);
        }
        if (weakS.collectionV.contentOffset.y < topH) {
            [weakS dealAllSubScrollViewScrollEnabled:subScrollContentView];
        }
    }];
}

- (void)dealAllSubScrollViewScrollEnabled:(UIView*)scrollContent
{
    //层次遍历
    NSMutableArray *queue = scrollContent.subviews.mutableCopy;

    while (queue.count) {
        UIView *firstView = [queue firstObject];
        //出队
        [queue removeObjectAtIndex:0];
        //子view入队
        [queue addObjectsFromArray:firstView.subviews];
        
        if ([firstView isKindOfClass:[UICollectionView class]] || [firstView isKindOfClass:[UITableView class]]){
            UIScrollView *sc = (UIScrollView *)firstView;
            if (sc.contentSize.height>sc.frame.size.height) {
                sc.contentOffset = CGPointMake(0, -sc.contentInset.top);
            }
        }
        
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
