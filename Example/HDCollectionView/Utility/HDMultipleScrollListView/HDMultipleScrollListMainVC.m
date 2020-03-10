//
//  HDMultipleScrollListMainVC.m
//  HDCollectionView_Example
//
//  Created by HaoDong chen on 2019/5/21.
//  Copyright © 2019 donggelaile. All rights reserved.
//

#import "HDMultipleScrollListMainVC.h"
#import "HDMultipleScrollListView.h"
#import "HDCollectionView+MultipleScroll.h"
#import <objc/runtime.h>
@interface HDMultipleScrollListMainVC ()<HDMultipleScrollListViewDelegate>
{
    void (^scrollCallBack)(UIScrollView*);
}
@property (nonatomic, weak) id<HDMultipleScrollListViewDelegate> userSetDelegate;
@end

@implementation HDMultipleScrollListMainVC
@synthesize multipleSc = _multipleSc;
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.gapOfBottomWhenSmallData = 0;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUp];
    // Do any additional setup after loading the view.
}
- (void)setUp
{
    self.automaticallyAdjustsScrollViewInsets = NO;
    _multipleSc = [[HDMultipleScrollListView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:self.multipleSc];
    
    __weak typeof(self) weakSelf = self;
    [self.multipleSc configFinishCallback:^(HDMultipleScrollListConfiger * _Nonnull configer) {
        [weakSelf configFinish:configer];
    }];
    
    if ([self mainVC]) {
        if (self.multipleSc.delegate) {
            self.userSetDelegate = self.multipleSc.delegate;
        }
        self.multipleSc.delegate = self;
    }
}
- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    self.multipleSc.frame = self.view.bounds;
}
- (void)configFinish:(HDMultipleScrollListConfiger*)configer
{
    [configer.controllers enumerateObjectsUsingBlock:^(UIViewController<HDMultipleScrollListViewScrollViewDidScroll> * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [self addChildViewController:obj];
    }];
}


#pragma mark 嵌套时使用(即mainVC作为另一个mainVC的子VC)

- (void)mainScrollViewOrContentScDidScroll:(UIScrollView*)sc
{
    if (sc == self.multipleSc.mainCollecitonV.collectionV) {
        [self scDicScroll:sc];
    }
    if ([self.userSetDelegate respondsToSelector:@selector(mainScrollViewOrContentScDidScroll:)]) {
        [self.userSetDelegate mainScrollViewOrContentScDidScroll:sc];
    }
}
- (void)hxContentScDidScroll:(UIScrollView*)sc
{
    if ([self.userSetDelegate respondsToSelector:@selector(hxContentScDidScroll:)]) {
        [self.userSetDelegate hxContentScDidScroll:sc];
    }
}


- (void)scDicScroll:(UIScrollView*)sc
{
    HDMultipleScrollListMainVC *mainVC = [self mainVC];
    if (mainVC && self.isNeedBottomGap) {
        CGRect lastSecRect = [[(HDSectionModel*)[self.multipleSc.mainCollecitonV.innerAllData lastObject] secProperRect] CGRectValue];
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
- (void)dealloc
{
    
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
