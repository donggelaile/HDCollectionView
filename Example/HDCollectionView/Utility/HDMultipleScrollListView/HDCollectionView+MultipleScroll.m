//
//  HDCollectionView+MultipleScroll.m
//  HDCollectionView_Example
//
//  Created by HaoDong chen on 2019/5/19.
//  Copyright © 2019 donggelaile. All rights reserved.
//

#import "HDCollectionView+MultipleScroll.h"
#import "HDMultipleScrollListView.h"
#import "HDWeakHashMap.h"
@implementation HDCollectionView(MultipleScroll)
- (void)hd_autoDealScrollViewDidScrollEvent:(UIView*)subScrollContentView topH:(CGFloat)topH
{
    if (!subScrollContentView) {
        return;
    }
    __weak typeof(self) weakS = self;
    __weak typeof (subScrollContentView) weakContentV = subScrollContentView;
    [self hd_setScrollViewDidScrollCallback:^(UIScrollView *scrollView) {

        UIScrollView *currentSubSc = [[HDWeakHashMap shareInstance] hd_getValueForKey:HDMUltipleCurrentSubScrollKey];
        if ((NSInteger)scrollView.contentInset.top == HDMainDefaultTopEdge) {
            CGFloat fitY = MAX(0, weakS.collectionV.contentOffset.y);
            scrollView.contentOffset = CGPointMake(0, fitY);
        }
        if (currentSubSc.contentOffset.y>0) {
            scrollView.contentOffset = CGPointMake(scrollView.contentOffset.x, topH);
        }
        if (weakS.collectionV.contentOffset.y < topH) {
            [weakS dealAllSubScrollViewScrollEnabled:weakContentV];
        }

    }];

}

- (void)dealAllSubScrollViewScrollEnabled:(UIView*)scrollContent
{
    //层次遍历sc
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
