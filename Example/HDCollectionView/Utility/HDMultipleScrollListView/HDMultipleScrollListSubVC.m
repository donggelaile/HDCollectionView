//
//  HDMultipleScrollListSubVC.m
//  HDCollectionView_Example
//
//  Created by HaoDong chen on 2019/5/21.
//  Copyright © 2019 donggelaile. All rights reserved.
//

#import "HDMultipleScrollListSubVC.h"
#import "HDMultipleScrollListMainVC.h"
@interface HDMultipleScrollListSubVC ()<HDMultipleScrollListViewScrollViewDidScroll>
{
    void (^scrollCallBack)(UIScrollView*);
}
@end

@implementation HDMultipleScrollListSubVC
@synthesize collectionV = _collectionV;
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUp];
}
- (void)setUp
{
    _collectionV = [HDCollectionView hd_makeHDCollectionView:^(HDCollectionViewMaker *maker) {
        maker.hd_isNeedTopStop(YES);
    }];
    _collectionV.collectionV.showsVerticalScrollIndicator = NO;
    
    [self.collectionV hd_setShouldRecognizeSimultaneouslyWithGestureRecognizer:^BOOL(UIGestureRecognizer *selfGestture, UIGestureRecognizer *otherGesture) {
        if ([otherGesture.view isKindOfClass:[UICollectionView class]]) {
            UICollectionView *cv = (UICollectionView*)otherGesture.view;
            if (cv.contentSize.width > cv.frame.size.width) {
                return NO;//不同时响应横向滑动的手势
            }
        }
        return YES;//响应最底层的mainSc
    }];
    
    __hd_WeakSelf
    [self.collectionV hd_setScrollViewDidScrollCallback:^(UIScrollView *scrollView) {
        [weakSelf scDicScroll:scrollView];
    }];
    [self.view addSubview:self.collectionV];
}
- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    self.collectionV.frame = self.view.bounds;
}

- (void)scDicScroll:(UIScrollView*)sc
{
    if (scrollCallBack) {
        scrollCallBack(sc);
    }
}
- (void)HDMultipleScrollListViewScrollViewDidScroll:(nonnull void (^)(UIScrollView * _Nonnull))ScrollCallback {
    scrollCallBack = ScrollCallback;
}
@end
