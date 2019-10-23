//
//  HDMultipleScrollListView.m
//  HDCollectionView_Example
//
//  Created by HaoDong chen on 2019/5/20.
//  Copyright © 2019 donggelaile. All rights reserved.
//

#import "HDMultipleScrollListView.h"
#import "HDCollectionView+MultipleScroll.h"
#import "HDMultipleScrollListSubVC.h"
#import <objc/runtime.h>

@implementation HDMultipleScrollListViewTitleHeader
- (void)layoutSubviews
{
    [super layoutSubviews];
    if (![self.subviews containsObject:[self rootView].jxTitle]) {
        [self insertSubview:self.rootView.jxTitle atIndex:0];
    }
    self.rootView.jxTitle.frame = self.bounds;
}
- (void)updateSecVUI:(__kindof id<HDSectionModelProtocol>)model
{
    
}
- (HDMultipleScrollListView *)rootView
{
    HDMultipleScrollListView *resultView;
    if (!resultView) {
        UIView *view = self;
        while (view!=nil && ![view isKindOfClass:NSClassFromString(@"HDMultipleScrollListView")]) {
            view = view.superview;
        }
        resultView = (HDMultipleScrollListView*)view;
    }
    return resultView;
}
@end


@interface HDMultipleScrollListViewContentCell : HDCollectionCell

@end

@implementation HDMultipleScrollListViewContentCell
- (void)updateCellUI:(__kindof HDCellModel *)model
{
    [self.contentView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj removeFromSuperview];
    }];
    HDMultipleScrollListSubVC <HDMultipleScrollListViewScrollViewDidScroll>*VC = model.orgData;
    __weak typeof(self) weakSelf = self;
    if ([VC isKindOfClass:[UIViewController class]] && [VC respondsToSelector:@selector(HDMultipleScrollListViewScrollViewDidScroll:)]) {
        [VC HDMultipleScrollListViewScrollViewDidScroll:^(UIScrollView * _Nonnull sc) {
            if ([sc isKindOfClass:[UIScrollView class]]) {
                [weakSelf hd_setSubScrollViewDidScrollCallback:sc];
            }
        }];
        VC.view.frame = self.bounds;
        [self.contentView addSubview:VC.view];
    }
    if ([VC isKindOfClass:[HDMultipleScrollListSubVC class]]) {
        //监听主HDCollectionView的滑动回调
        HDMultipleScrollListView *rootView = [self rootView];
        [rootView.mainCollecitonV hd_autoDealScrollViewDidScrollEvent:self.superCollectionV topH:[self topH]];
    }
}
- (void)hd_setSubScrollViewDidScrollCallback:(UIScrollView *)sc
{
    UIScrollView *mainRealSc = [self mainScrollV];
    HDCollectionView *mainHDCV = [self rootView].mainCollecitonV;
    [mainHDCV setCurrentSubSc:sc];
    CGFloat topH = [self topH];
    
    if (mainRealSc.contentOffset.y < topH) {
        sc.contentOffset = CGPointMake(0, -sc.contentInset.top);
    }else{
        mainRealSc.contentOffset = CGPointMake(mainRealSc.contentOffset.x, topH);
    }
}
- (UIScrollView*)mainScrollV
{
    HDMultipleScrollListView *rootView = [self rootView];
    UIScrollView *mainRealSc = rootView.mainCollecitonV.collectionV;
    return mainRealSc;
}
- (CGFloat)topH
{
    HDMultipleScrollListView *rootView = [self rootView];
    NSIndexPath *titleHeaderIndexP = [NSIndexPath indexPathWithIndex:rootView.confingers.topSecArr.count];
    UICollectionViewLayoutAttributes*titleHeaderAtt = [rootView.mainCollecitonV.collectionV layoutAttributesForSupplementaryElementOfKind:UICollectionElementKindSectionHeader atIndexPath:titleHeaderIndexP];
    CGFloat titleHeaderY = titleHeaderAtt.frame.origin.y;
    UIScrollView *mainRealSc = rootView.mainCollecitonV.collectionV;
    
    CGFloat topH = floor([self convertRect:self.frame toView:mainRealSc].origin.y);
    if (rootView.confingers.isHeaderNeedStop) {
        topH = floor(titleHeaderY);
    }
    return topH;
}

- (HDMultipleScrollListView*)rootView
{
    HDMultipleScrollListView *resultView;
    if (!resultView) {
        UIView *view = self;
        while (view!=nil && ![view isKindOfClass:NSClassFromString(@"HDMultipleScrollListView")]) {
            view = view.superview;
        }
        resultView = (HDMultipleScrollListView*)view;
    }
    return resultView;
}
@end



@interface HDMultipleScrollListViewContentHeader:HDSectionView
@property (nonatomic, strong) HDCollectionView *contentCV;
@end

@implementation HDMultipleScrollListViewContentHeader
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.contentCV = [HDCollectionView hd_makeHDCollectionView:^(HDCollectionViewMaker *maker) {
            maker
            .hd_scrollDirection(UICollectionViewScrollDirectionHorizontal);
        }];
        self.contentCV.collectionV.pagingEnabled = YES;
        self.contentCV.collectionV.bounces = NO;
        if (@available(iOS 11.0, *)) {
            _contentCV.collectionV.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        } else {
            // Fallback on earlier versions
        }
        [self addSubview:self.contentCV];
    }
    __hd_WeakSelf
    [self.contentCV hd_setShouldRecognizeSimultaneouslyWithGestureRecognizer:^BOOL(UIGestureRecognizer *selfGestture, UIGestureRecognizer *otherGesture) {
        return [weakSelf dealFullScrrenBackGesture:otherGesture];
    }];
    return self;
}
- (BOOL)dealFullScrrenBackGesture:(UIGestureRecognizer*)otherGes
{
    BOOL isRes = NO;
    NSInteger curPage = self.contentCV.collectionV.contentOffset.x/self.contentCV.frame.size.width;
    if (curPage == 0) {
        if ([otherGes isKindOfClass:[UIPanGestureRecognizer class]] &&
            [otherGes.view isKindOfClass:NSClassFromString(@"UILayoutContainerView")]) {
            isRes = YES;
        }
    }
    return isRes;
}
- (void)updateSecVUI:(__kindof id<HDSectionModelProtocol>)model
{
    id<HDSectionModelProtocol> firstSec = [self.contentCV.innerAllData firstObject];
    if (!firstSec.sectionDataArr.count) {
        [self.contentCV hd_setAllDataArr:model.headerObj];
    }
    [self rootView].jxTitle.contentScrollView = self.contentCV.collectionV;

}
- (HDMultipleScrollListView*)rootView
{
    HDMultipleScrollListView *resultView;
    if (!resultView) {
        UIView *view = self;
        while (view!=nil && ![view isKindOfClass:NSClassFromString(@"HDMultipleScrollListView")]) {
            view = view.superview;
        }
        resultView = (HDMultipleScrollListView*)view;
    }
    return resultView;
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    self.contentCV.frame = self.bounds;
}
@end



#pragma mark - configer
@implementation HDMultipleScrollListConfiger
@end

@interface HDMultipleScrollListView()
{
    void(^configFinishGlobal)(HDMultipleScrollListConfiger*);
}
@property (nonatomic, strong) NSMutableArray *finalSecArr;
@end

#pragma mark - HDMultipleScrollListView
@implementation HDMultipleScrollListView
{
    CGRect lastViewFrame;
}
@synthesize mainCollecitonV = _mainCollecitonV,jxTitle = _jxTitle, jxLineView = _jxLineView, confingers = _confingers;
- (instancetype)init
{
    self = [super init];
    if (self) {
    }
    lastViewFrame = CGRectZero;
    return self;
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
    }
    lastViewFrame = CGRectZero;
    return self;
}
- (NSMutableArray *)finalSecArr
{
    if (!_finalSecArr) {
        _finalSecArr = @[].mutableCopy;
    }
    return _finalSecArr;
}
- (JXCategoryTitleView *)jxTitle
{
    if (!_jxTitle) {
        _jxTitle = [[JXCategoryTitleView alloc] init];
        _jxTitle.indicators = @[self.jxLineView];
        _jxTitle.backgroundColor = [UIColor whiteColor];
    }
    return _jxTitle;
}
- (JXCategoryIndicatorLineView *)jxLineView
{
    if (!_jxLineView) {
        _jxLineView = [[JXCategoryIndicatorLineView alloc] init];
        _jxLineView.indicatorHeight = 2;
        _jxLineView.indicatorCornerRadius = JXCategoryViewAutomaticDimension;
    }
    return _jxLineView;
}
- (HDCollectionView *)mainCollecitonV
{
    if (!_mainCollecitonV) {
        _mainCollecitonV = [HDCollectionView hd_makeHDCollectionView:^(HDCollectionViewMaker *maker) {
            maker.hd_isNeedTopStop(YES);
        }];
//        _mainCollecitonV.collectionV.bounces = NO;
        _mainCollecitonV.collectionV.showsVerticalScrollIndicator = NO;
        if (@available(iOS 11.0, *)) {
            _mainCollecitonV.collectionV.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        } else {
            // Fallback on earlier versions
        }
        //让主滑动view contentSize不至于过小，从而存在一个滑动惯性。
        //这样可以使顶部高度过低时，从底部滑动到顶部时不卡顿
        _mainCollecitonV.collectionV.contentInset = UIEdgeInsetsMake(HDMainDefaultTopEdge, 0, 0, 0);
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            self->_mainCollecitonV.collectionV.contentOffset=CGPointZero;
        });
        
        //初始化时仅保证大于0
        [_mainCollecitonV hd_setScrollViewDidScrollCallback:^(UIScrollView *scrollView) {
            if (scrollView.contentOffset.y<0) {
                scrollView.contentOffset = CGPointZero;
            }
        }];
    }
    [self addSubview:_mainCollecitonV];
    _mainCollecitonV.collectionV.bounces = NO;

    return _mainCollecitonV;
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    self.mainCollecitonV.frame = self.bounds;
    if (!CGRectEqualToRect(lastViewFrame, self.frame)) {
        [self updateData];
    }
    lastViewFrame = self.frame;
}
- (void)configWithConfiger:(void (^)(HDMultipleScrollListConfiger * _Nonnull configer))config
{
    HDMultipleScrollListConfiger *configer = [HDMultipleScrollListConfiger new];
    if (config) {
        config(configer);
    }
    _confingers = configer;
    self.jxTitle.titles = configer.titles;
    if (configFinishGlobal) {
        configFinishGlobal(configer);
    }
    
    [self updateData];
}
- (void)configFinishCallback:(void (^)(HDMultipleScrollListConfiger * _Nonnull))configFinish
{
    if (configFinish) {
        configFinishGlobal = configFinish;
    }
}
- (void)updateData
{
    if (self.confingers.controllers.count != self.confingers.titles.count) {
        return;
    }
    self.finalSecArr = @[].mutableCopy;
    [self.finalSecArr addObjectsFromArray:self.confingers.topSecArr];
    [self addMiddleData];
    [self.mainCollecitonV hd_setAllDataArr:self.finalSecArr];
}
- (void)addMiddleData
{
    [self.finalSecArr addObject:[self HDMultipleScrollListViewTitleHeaderSec]];
    [self.finalSecArr addObject:[self HDMultipleScrollListViewContentHeaderSec]];
}
- (id<HDSectionModelProtocol>)HDMultipleScrollListViewTitleHeaderSec
{
    NSString *clsStr = @"HDMultipleScrollListViewTitleHeader";
    if (self.confingers.diyHeaderClsStr) {
        Class cls = NSClassFromString(self.confingers.diyHeaderClsStr);
        if ([cls isKindOfClass:object_getClass(NSClassFromString(clsStr))]) {
            clsStr = self.confingers.diyHeaderClsStr;
        }
    }
    id<HDSectionModelProtocol> titleSec = [self normalSecWithCellModelArr:nil headerSize:self.confingers.titleContentSize headerClsStr:clsStr autoCountCellH:NO];
    titleSec.headerObj = self.confingers.titles;;
    titleSec.headerTopStopType = self.confingers.isHeaderNeedStop?HDHeaderStopOnTopTypeAlways:HDHeaderStopOnTopTypeNone;
    return titleSec;
}

- (id<HDSectionModelProtocol>)HDMultipleScrollListViewContentHeaderSec
{
    id<HDSectionModelProtocol> secModel = [self normalSecWithCellModelArr:@[].mutableCopy headerSize:[self realContentSize] headerClsStr:@"HDMultipleScrollListViewContentHeader" autoCountCellH:NO];
    secModel.headerObj = @[[self realContentSec]];
    secModel.headerTopStopType = HDHeaderStopOnTopTypeAlways;
    
    return secModel;
}
- (id<HDSectionModelProtocol>)realContentSec
{
    //该段cell数据源
    static NSInteger index = 0;
    NSMutableArray *cellModelArr = @[].mutableCopy;
    NSInteger cellCount = self.confingers.controllers.count;
    
    for (int i =0; i<cellCount; i++) {
        UIViewController *vc = self.confingers.controllers[i];
        HDCellModel *model = [HDCellModel new];
        model.orgData      = vc;
        model.cellSize     = [self realContentSize];
        model.cellClassStr = @"HDMultipleScrollListViewContentCell";
        model.reuseIdentifier = [NSString stringWithFormat:@"HDMultipleScrollListViewContentCell_%zd",index];
        [cellModelArr addObject:model];
        index ++;
    }
    
    //该段layout
    HDYogaFlowLayout *layout = [HDYogaFlowLayout new];//isUseSystemFlowLayout为YES时只支持HDBaseLayout
    
    //该段的所有数据封装
    id<HDSectionModelProtocol> secModel = [HDSectionModel new];
    secModel.sectionDataArr           = cellModelArr;
    secModel.layout                   = layout;
    return secModel;
}
- (CGSize)realContentSize
{
    if (self.confingers.isHeaderNeedStop) {
        return CGSizeMake(self.mainCollecitonV.frame.size.width, self.mainCollecitonV.frame.size.height- self.confingers.titleContentSize.height);
    }else{
        return self.mainCollecitonV.frame.size;
    }
}

- (id<HDSectionModelProtocol>)normalSecWithCellModelArr:(NSArray*)cellModelArr headerSize:(CGSize)headerSize headerClsStr:(NSString*)headerClsStr autoCountCellH:(BOOL)autoCountCellH
{
    //该段layout
    HDYogaFlowLayout *layout = [HDYogaFlowLayout new];//isUseSystemFlowLayout为YES时只支持HDBaseLayout
    layout.justify       = YGJustifySpaceBetween;
    layout.headerSize    = headerSize;
    
    //该段的所有数据封装
    id<HDSectionModelProtocol> secModel = [HDSectionModel new];
    secModel.sectionHeaderClassStr    = headerClsStr;
    secModel.isNeedAutoCountCellHW    = autoCountCellH;
    secModel.sectionDataArr           = cellModelArr.mutableCopy;
    secModel.layout                   = layout;
    return secModel;
}
- (void)dealloc
{
    
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
