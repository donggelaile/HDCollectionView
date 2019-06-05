//
//  HDMultipleScrollListView.m
//  HDCollectionView_Example
//
//  Created by HaoDong chen on 2019/5/20.
//  Copyright © 2019 donggelaile. All rights reserved.
//

#import "HDMultipleScrollListView.h"
#import "HDWeakHashMap.h"
#import "HDCollectionView+MultipleScroll.h"

static NSString *HDMultipleScrollListViewKey = @"HDMultipleScrollListViewKey";
static NSString *HDMultipleScrollListViewTitleHeaderKey = @"HDMultipleScrollListViewTitleHeaderKey";

#pragma mark - HDMultipleScrollListViewTitleHeader
@interface HDMultipleScrollListViewTitleHeader:HDSectionView
@property (nonatomic, weak) HDMultipleScrollListView *rootView;
@end

@implementation HDMultipleScrollListViewTitleHeader
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        HDMultipleScrollListView *rootView = [[HDWeakHashMap shareInstance] hd_getValueForKey:HDMultipleScrollListViewKey];
        self.rootView = rootView;
        [self addSubview:rootView.jxTitle];
    }
    [[HDWeakHashMap shareInstance] hd_saveValue:self forKey:HDMultipleScrollListViewTitleHeaderKey];
    return self;
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    self.rootView.jxTitle.frame = self.bounds;
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
    UIViewController <HDMultipleScrollListViewScrollViewDidScroll>*VC = model.orgData;
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
    
}
- (void)hd_setSubScrollViewDidScrollCallback:(UIScrollView *)sc
{
    HDMultipleScrollListView *rootView = [[HDWeakHashMap shareInstance] hd_getValueForKey:HDMultipleScrollListViewKey];
    HDMultipleScrollListViewTitleHeader *titleHeader = [[HDWeakHashMap shareInstance] hd_getValueForKey:HDMultipleScrollListViewTitleHeaderKey];
    
    UIScrollView *mainRealSc = rootView.mainCollecitonV.collectionV;
    CGFloat topH = [self.superview convertRect:self.frame toView:mainRealSc].origin.y;
    if (rootView.confingers.isHeaderNeedStop) {
        topH = titleHeader.frame.origin.y;
    }
    //监听主HDCollectionView的滑动回调
    [rootView.mainCollecitonV hd_autoDealScrollViewDidScrollEvent:self.superCollectionV currentScrollingSubView:sc topH:topH];
    
    if (mainRealSc.contentOffset.y < topH) {
        sc.contentOffset = CGPointMake(0, -sc.contentInset.top);
    }else{
        mainRealSc.contentOffset = CGPointMake(mainRealSc.contentOffset.x, topH);
    }
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
            .hd_scrollDirection(UICollectionViewScrollDirectionHorizontal)
            .hd_isCalculateCellHOnCommonModes(YES);
        }];
        self.contentCV.collectionV.pagingEnabled = YES;
        [self addSubview:self.contentCV];
    }
    HDMultipleScrollListView *rootView = [[HDWeakHashMap shareInstance] hd_getValueForKey:HDMultipleScrollListViewKey];
    rootView.jxTitle.contentScrollView = self.contentCV.collectionV;
    return self;
}
- (void)updateSecVUI:(__kindof HDSectionModel *)model
{
    if (!self.contentCV.innerAllData.count) {
        [self.contentCV hd_setAllDataArr:model.headerObj];
    }
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
@synthesize mainCollecitonV = _mainCollecitonV,jxTitle = _jxTitle, jxLineView = _jxLineView, confingers = _confingers;
- (instancetype)init
{
    self = [super init];
    if (self) {
        [[HDWeakHashMap shareInstance] hd_saveValue:self forKey:HDMultipleScrollListViewKey];
    }
    return self;
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [[HDWeakHashMap shareInstance] hd_saveValue:self forKey:HDMultipleScrollListViewKey];
    }
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
            maker.hd_isNeedTopStop(YES)
            .hd_isCalculateCellHOnCommonModes(YES);
        }];
//        _mainCollecitonV.collectionV.bounces = NO;
        _mainCollecitonV.collectionV.showsVerticalScrollIndicator = NO;
        if (@available(iOS 11.0, *)) {
            _mainCollecitonV.collectionV.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        } else {
            // Fallback on earlier versions
        }
    }
    [self addSubview:_mainCollecitonV];
    _mainCollecitonV.collectionV.bounces = NO;
//    [_mainCollecitonV hd_setShouldRecognizeSimultaneouslyWithGestureRecognizer:^BOOL(UIGestureRecognizer *selfGestture, UIGestureRecognizer *otherGesture) {
//        return YES;
//    }];
    return _mainCollecitonV;
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    _mainCollecitonV.frame = self.bounds;
    [self updateData];
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
- (HDSectionModel*)HDMultipleScrollListViewTitleHeaderSec
{
    HDSectionModel *titleSec = [self normalSecWithCellModelArr:nil headerSize:self.confingers.titleContentSize headerClsStr:@"HDMultipleScrollListViewTitleHeader" autoCountCellH:NO];
    titleSec.headerObj = self.confingers.titles;;
    titleSec.headerTopStopType = self.confingers.isHeaderNeedStop?HDHeaderStopOnTopTypeAlways:HDHeaderStopOnTopTypeNone;
    return titleSec;
}

- (HDSectionModel*)HDMultipleScrollListViewContentHeaderSec
{
    HDSectionModel *secModel = [self normalSecWithCellModelArr:@[].mutableCopy headerSize:[self realContentSize] headerClsStr:@"HDMultipleScrollListViewContentHeader" autoCountCellH:NO];
    secModel.headerObj = @[[self realContentSec]];
    secModel.headerTopStopType = HDHeaderStopOnTopTypeAlways;
    
    return secModel;
}
- (HDSectionModel *)realContentSec
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
    HDSectionModel *secModel = [HDSectionModel new];
    secModel.sectionDataArr           = cellModelArr;
    secModel.layout                   = layout;
    return secModel;
}
- (CGSize)realContentSize
{
    if (self.confingers.isHeaderNeedStop) {
        return CGSizeMake(_mainCollecitonV.frame.size.width, _mainCollecitonV.frame.size.height- self.confingers.titleContentSize.height);
    }else{
        return _mainCollecitonV.frame.size;
    }
}

- (HDSectionModel*)normalSecWithCellModelArr:(NSArray*)cellModelArr headerSize:(CGSize)headerSize headerClsStr:(NSString*)headerClsStr autoCountCellH:(BOOL)autoCountCellH
{
    //该段layout
    HDYogaFlowLayout *layout = [HDYogaFlowLayout new];//isUseSystemFlowLayout为YES时只支持HDBaseLayout
    layout.justify       = YGJustifySpaceBetween;
    layout.headerSize    = headerSize;
    
    //该段的所有数据封装
    HDSectionModel *secModel = [HDSectionModel new];
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
