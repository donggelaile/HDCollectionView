//
//  HDMultipleScrollListSubVC.m
//  HDCollectionView_Example
//
//  Created by HaoDong chen on 2019/5/21.
//  Copyright © 2019 donggelaile. All rights reserved.
//

#import "HDMultipleScrollListSubVC.h"
#import "HDMultipleScrollListMainVC.h"
#import "HDCollectionView+MultipleScroll.h"
#import <objc/runtime.h>
@interface HDMultipleScrollListSubVC ()<HDMultipleScrollListViewScrollViewDidScroll>
{
    void (^scrollCallBack)(UIScrollView*);
    void (^hd_cvConfiger)(HDCollectionViewMaker *);
}
@end

@implementation HDMultipleScrollListSubVC
@synthesize collectionV = _collectionV;
- (void)hd_setCvConfiger:(void (^)(HDCollectionViewMaker * _Nonnull))hdcvConfiger
{
    if (hdcvConfiger) {
        hd_cvConfiger = hdcvConfiger;
    }else{
        hdcvConfiger = ^(HDCollectionViewMaker*maker){
            maker.hd_isNeedTopStop(YES);
        };
    }
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.gapOfBottomWhenSmallData = 20;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUp];
}
- (void)setUp
{
    self.automaticallyAdjustsScrollViewInsets = NO;
    _collectionV = [HDCollectionView hd_makeHDCollectionView:hd_cvConfiger];
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
    
    CGFloat safeBottom = 0;
    if (@available(iOS 11.0, *)) {
        safeBottom = [[UIApplication sharedApplication].delegate window].safeAreaInsets.bottom;
        self.collectionV.collectionV.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
        // Fallback on earlier versions
    }
    self.collectionV.collectionV.contentInset = UIEdgeInsetsMake(0, 0, safeBottom, 0);
    
    [self.view addSubview:self.collectionV];
    
}
- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    self.collectionV.frame = self.view.bounds;
}

- (void)scDicScroll:(UIScrollView*)sc
{
    HDMultipleScrollListMainVC *mainVC = [self mainVC];
    if (mainVC && self.isNeedBottomGap) {
        CGRect lastSecRect = [[(HDSectionModel*)[self.collectionV.innerAllData lastObject] secProperRect] CGRectValue];
        CGFloat maxMainVCOffsetY = CGRectGetMaxY(lastSecRect) + [self topH] - mainVC.multipleSc.mainCollecitonV.frame.size.height;
        objc_setAssociatedObject(sc, mianCVMaxOffsetYKey, @(MAX(-1, (NSInteger)maxMainVCOffsetY)), OBJC_ASSOCIATION_RETAIN);
    }
    
    if (scrollCallBack) {
        scrollCallBack(sc);
    }
}
- (HDMultipleScrollListMainVC*)mainVC
{
    if ([self.parentViewController isKindOfClass:[HDMultipleScrollListMainVC class]]) {
        return (HDMultipleScrollListMainVC*)self.parentViewController;
    }
    return nil;
}
- (CGFloat)topH
{
    HDMultipleScrollListView *rootView = [self mainVC].multipleSc;
    UIScrollView *mainRealSc = rootView.mainCollecitonV.collectionV;
    UIView *viewCell = self.view.superview.superview;
    CGFloat topH = [viewCell convertRect:viewCell.frame toView:mainRealSc].origin.y;
    return topH+self.gapOfBottomWhenSmallData;
}
- (void)HDMultipleScrollListViewScrollViewDidScroll:(nonnull void (^)(UIScrollView * _Nonnull))ScrollCallback {
    scrollCallBack = ScrollCallback;
}
- (UIView *)HDMultipleScrollListViewSubVCView
{
    return self.view;
}
@end
