//
//  HDCollectionView.m
//
//
//  Created by CHD on 2018/8/9.
//  Copyright © 2018年 chd. All rights reserved.
//

#import "HDCollectionView.h"
#import "HDCollectionViewFlowLayout.h"
#import "HDCellFrameCacheHelper.h"
#import "HDCollectionCell.h"
#import "HDDefines.h"
#import "HDCollectionViewLayout.h"
#import "HDBaseLayout+Cache.h"
#import <HDListViewDiffer/UICollectionView+HDDiffReload.h>
#import <objc/runtime.h>

static NSString *const hd_default_hf_class = @"HDSectionView";
static NSString *const hd_default_cell_class = @"HDCollectionCell";
static char *const hd_default_colletionView_maker = "hd_default_colletionView_maker";

@implementation HDInnerCollectionView

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    ;
    BOOL(^multiGesCallBack)(UIGestureRecognizer*ges1,UIGestureRecognizer*ges2) = [self.superview valueForKeyPath:@"multiGesCallBack"];
    if (multiGesCallBack) {
        return multiGesCallBack(gestureRecognizer,otherGestureRecognizer);
    }else{
        if (![gestureRecognizer isKindOfClass:UIPanGestureRecognizer.class]) {
            return NO;
        }
        
        //这里默认处理横向滑动的父scrollView手势以及横向全屏返回手势
        BOOL isScrollToLeftEdge = self.contentOffset.x <= 1 - self.contentInset.left;
        BOOL isScrollToRightEdge = self.contentOffset.x >= self.contentSize.width + self.contentInset.right - 1 - self.frame.size.width;
        CGPoint translationP = [(UIPanGestureRecognizer*)gestureRecognizer translationInView:self];

        BOOL isScrollToEdge  = (isScrollToLeftEdge && translationP.x>0) || (isScrollToRightEdge && translationP.x<0);
        if (isScrollToEdge) {
            BOOL isHXScrollView = NO;
            if ([otherGestureRecognizer.view isKindOfClass:UIScrollView.class]) {
                UIScrollView *scView = (UIScrollView*)otherGestureRecognizer.view;
                if (scView.contentSize.width>scView.frame.size.width+scView.contentInset.left+scView.contentInset.right) {
                    isHXScrollView = YES;
                }
            }
            //如果碰到了横向滚动的scrollView,则返回YES
            if (isHXScrollView) {
                //当前列表也是横向的，则禁止当前列表的bounces属性。因为此时会内外同时滑动。
                if (self.contentSize.width>self.frame.size.width+self.contentInset.left+self.contentInset.right) {
                    self.bounces = NO;
                }
                return YES;
            }
            //如果碰到了全屏返回手势，则返回YES
            if ([otherGestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]] &&
                [otherGestureRecognizer.view isKindOfClass:HDClassFromString(@"UILayoutContainerView")]) {
                return YES;
            }
        }
        return NO;
    }
}

@end

#pragma mark - ChainMaker
@interface HDCollectionViewMaker()
@property (nonatomic)  BOOL  isNeedTopStop;
@property (nonatomic)  BOOL  isUseSystemFlowLayout;
@property (nonatomic)  BOOL  isNeedAdaptScreenRotaion;
@property (nonatomic)  UICollectionViewScrollDirection  scrollDirection;
@property (nonatomic)  NSMutableDictionary *keysSetedMap;
@property (nonatomic)  CGRect frame;
@property (nonatomic, weak) Class HDCollectionViewCls;

@end

@implementation HDCollectionViewMaker
    
- (NSMutableDictionary *)keysSetedMap
{
    if (!_keysSetedMap) {
        _keysSetedMap = @{}.mutableCopy;
    }
    return _keysSetedMap;
}

- (HDCollectionView *)generateObj
{
    HDCollectionViewMaker *defultMaker = objc_getAssociatedObject([HDCollectionView class], hd_default_colletionView_maker);
    
    HDCollectionView *obj = [self.HDCollectionViewCls new];
    if (self.keysSetedMap[@"isNeedTopStop"]){
        [obj setValue:@(self.isNeedTopStop) forKeyPath:@"isNeedTopStop"];
    }else{
        [obj setValue:@(defultMaker.isNeedTopStop) forKeyPath:@"isNeedTopStop"];
    }

    if (self.keysSetedMap[@"isUseSystemFlowLayout"]){
        [obj setValue:@(self.isUseSystemFlowLayout) forKeyPath:@"isUseSystemFlowLayout"];
    }else{
        [obj setValue:@(defultMaker.isUseSystemFlowLayout) forKeyPath:@"isUseSystemFlowLayout"];
    }
    if (self.keysSetedMap[@"scrollDirection"]){
        [obj setValue:@(self.scrollDirection) forKeyPath:@"scrollDirection"];
    }else{
        [obj setValue:@(defultMaker.scrollDirection) forKeyPath:@"scrollDirection"];
    }
    if (self.keysSetedMap[@"frame"]){
        [obj setValue:@(self.frame) forKeyPath:@"frame"];
    }else{
        [obj setValue:@(defultMaker.frame) forKeyPath:@"frame"];
    }
    if (self.keysSetedMap[@"isNeedAdaptScreenRotaion"]) {
        [obj setValue:@(self.isNeedAdaptScreenRotaion) forKey:@"isNeedAdaptScreenRotaion"];
    }else{
        [obj setValue:@(defultMaker.isNeedAdaptScreenRotaion) forKey:@"isNeedAdaptScreenRotaion"];
    }
    [obj collectionV];
    
    return obj;
}

- (HDCollectionViewMaker *(^)(CGRect))hd_frame
{
    return ^(CGRect  frame){
        self.frame = frame;
        self.keysSetedMap[@"frame"] = @(YES);
        return self;
    };
}

-(HDCollectionViewMaker* (^)(BOOL ))hd_isNeedTopStop
{
    return ^(BOOL  isNeedTopStop){
        self.isNeedTopStop = isNeedTopStop;
        self.keysSetedMap[@"isNeedTopStop"] = @(YES);
        return self;
    };
}

-(HDCollectionViewMaker* (^)(BOOL ))hd_isNeedAdaptScreenRotaion
{
    return ^(BOOL  isNeedAdaptScreenRotaion){
        self.isNeedAdaptScreenRotaion = isNeedAdaptScreenRotaion;
        self.keysSetedMap[@"isNeedAdaptScreenRotaion"] = @(YES);
        return self;
    };
}

-(HDCollectionViewMaker* (^)(BOOL ))hd_isUseSystemFlowLayout
{
    return ^(BOOL  isUseSystemFlowLayout){
        self.isUseSystemFlowLayout = isUseSystemFlowLayout;
        self.keysSetedMap[@"isUseSystemFlowLayout"] = @(YES);
        return self;
    };
}

-(HDCollectionViewMaker* (^)(UICollectionViewScrollDirection ))hd_scrollDirection
{
    return ^(UICollectionViewScrollDirection  scrollDirection){
        self.scrollDirection = scrollDirection;
        self.keysSetedMap[@"scrollDirection"] = @(YES);
        return self;
    };
}

- (void (^)(void))hd_endConfig
{
    return ^(void){
        
    };
}

@end


#pragma mark - HDCollectionView

@interface HDCollectionView()
{
    void (^allEventCallbcak)(id backModel, HDCallBackType);
    void (^setedCellCallback)(__kindof UICollectionViewCell *, NSIndexPath *);
    void (^setedSecViewCallback)(__kindof UICollectionViewCell *, NSIndexPath *,NSString*);
    void (^dataDealFinishCallback)(HDDataChangeType);
    void (^scDidScrollCallback)(UIScrollView *sc);
    void (^scWillBeginDraggingCallback)(UIScrollView *sc);
    void (^scDidEndDraggingCallback)(UIScrollView *sc,BOOL slowDown);
    void (^scDidEndDeceleratingCallback)(UIScrollView *sc);
    void (^hdChangeDataFailedCallback)(void);
    UIInterfaceOrientation lastOrientation;
    BOOL isChangingLayout;
    BOOL isObserveContentSize;
}
@property (nonatomic, strong) NSMutableArray *allDataCopy;
@property (nonatomic, strong, readonly) NSMutableArray<id<HDSectionModelProtocol>>* allDataArr;
@property (nonatomic, copy) BOOL (^multiGesCallBack)(UIGestureRecognizer*ges1,UIGestureRecognizer*ges2);
@property (nonatomic, copy) void(^contentSizeChangeCallBack)(CGSize newSize);
@property (nonatomic, strong) NSMutableDictionary *allSecDict;
@end

@implementation HDCollectionView
@synthesize collectionV = _collectionV;
@synthesize allDataArr = _allDataArr;
@synthesize allSubViewEventDealPolicy = _allSubViewEventDealPolicy;

- (NSMutableArray *)allDataCopy
{
    if (!_allDataCopy) {
        _allDataCopy = self.allDataArr;
    }
    return _allDataCopy;
}

+ (void)doSomeThing:(void(^)(void))thingsToDo
{
    if (thingsToDo) {
        thingsToDo();
    }
}
    
void HDDoSomeThingInMode(NSRunLoopMode mode,void(^thingsToDo)(void)){
    if (mode == NSRunLoopCommonModes) {
        if (thingsToDo) {
            thingsToDo();
        }
    }else{
        dispatch_async(dispatch_get_main_queue(), ^{
           [HDCollectionView performSelector:@selector(doSomeThing:) withObject:thingsToDo afterDelay:0 inModes:@[mode]];
        });
    }
}

void HDDoSomeThingInMainQueue(void(^thingsToDo)(void))
{
    if ([NSThread currentThread].isMainThread) {
        if (thingsToDo) {
            thingsToDo();
        }
    }else{
        dispatch_async(dispatch_get_main_queue(), ^{
            if (thingsToDo) {
                thingsToDo();
            }
        });
    }
}
    
+ (void)load
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        HDCollectionViewMaker *maker = [HDCollectionViewMaker new];
        maker.isNeedTopStop = NO;
        maker.isUseSystemFlowLayout = NO;
        maker.scrollDirection = UICollectionViewScrollDirectionVertical;
        maker.isNeedAdaptScreenRotaion = NO;
        maker.frame = CGRectZero;
        objc_setAssociatedObject(self, hd_default_colletionView_maker, maker, OBJC_ASSOCIATION_RETAIN);
    });
}

+ (void)hd_globalConfigDefaultValue:(void (^)(HDCollectionViewMaker *))maker
{
    HDCollectionViewMaker *makerObj = objc_getAssociatedObject(self, hd_default_colletionView_maker);
    if (maker) {
        maker(makerObj);
    }
}

- (BOOL)isInnerDataEmpty
{
    __block NSInteger allCount = 0;
    [self.allDataCopy enumerateObjectsUsingBlock:^(id<HDSectionModelProtocol> _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        allCount += obj.sectionDataArr.count;
    }];
    return allCount == 0;
}
#pragma mark - lazyload
- (NSMutableDictionary *)allSubViewEventDealPolicy
{
    if (!_allSubViewEventDealPolicy) {
        _allSubViewEventDealPolicy = @{}.mutableCopy;
    }
    return _allSubViewEventDealPolicy;
}

- (NSMutableDictionary *)allSecDict{
    if (!_allSecDict) {
        _allSecDict = @{}.mutableCopy;
    }
    return _allSecDict;
}

- (NSMutableArray<id<HDSectionModelProtocol>> *)allDataArr
{
    if (!_allDataArr) {
        _allDataArr = @[].mutableCopy;
    }
    return _allDataArr;
}

- (void)setAllDataArr:(NSMutableArray<id<HDSectionModelProtocol>> *)allDataArr
{
    _allDataArr = allDataArr;
}

- (NSArray *)innerAllData
{
    return self.allDataCopy;
}

- (UICollectionView *)collectionV
{
    if (!_collectionV) {
        UICollectionViewLayout *layout;

        if (_isUseSystemFlowLayout) {
            HDCollectionViewFlowLayout*flowLayout =  [[HDCollectionViewFlowLayout alloc] init];
            flowLayout.scrollDirection = _scrollDirection;
            layout = flowLayout;
        }else{
            HDCollectionViewLayout *hdLayout = [[HDCollectionViewLayout alloc] init];
            hdLayout.scrollDirection = _scrollDirection;
            layout = hdLayout;
        }
        Class collectionClass = [self HDInnerCollectionViewClass];
        if (![collectionClass isKindOfClass:object_getClass([UICollectionView class])]) {
            collectionClass = [HDInnerCollectionView class];
        }
        _collectionV = [[collectionClass alloc] initWithFrame:self.bounds collectionViewLayout:layout];
        _collectionV.delegate = self;
        _collectionV.dataSource = self;
        _collectionV.alwaysBounceVertical = YES;
        _collectionV.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
        _collectionV.contentInset = UIEdgeInsetsZero;
        [self registerWithCellClass:hd_default_cell_class cellReuseID:hd_default_cell_class headerClass:hd_default_hf_class footerClass:hd_default_hf_class decorationClass:nil];
        [self addSubview:_collectionV];
    }
    return _collectionV;
}
- (Class)HDInnerCollectionViewClass
{
    return [HDInnerCollectionView class];
}

#pragma mark - init
+ (HDCollectionView *)hd_makeHDCollectionView:(void (^)(HDCollectionViewMaker *))maker
{
    HDCollectionViewMaker *hdMaker = [HDCollectionViewMaker new];
    hdMaker.HDCollectionViewCls = self;
    if (maker) {
        maker(hdMaker);
    }
    return [hdMaker generateObj];
}

-(instancetype)init
{
    self = [super init];
    lastOrientation = [UIApplication sharedApplication].statusBarOrientation;
    return self;
}

- (void)hd_reloadData
{
    [self.collectionV reloadData];
}

-(void)hd_reloadDataAndSecitonLayout:(NSString *)sectionKey
{
    id<HDSectionModelProtocol> sec = _allSecDict[sectionKey];
    if (sec) {
        void (^refreshDataLayout)(void) = ^(){
            sec.layout.needUpdate = YES;
            [self reloadSectionAfter:sec.section];
            [self updateHDColltionViewDataType:HDDataChangeChangeSec start:[NSValue valueWithCGPoint:sec.layout.cacheStart]];
            [self hd_reloadData];
        };
        if (sec.isNeedAutoCountCellHW) {
            [self hd_autoCountCellsHeight:sec ignoreCache:YES];
            refreshDataLayout();
        }else{
            refreshDataLayout();
        }
    }
    
}

- (void)hd_reloadDataAndAllLayout
{
    if ([self.collectionV.collectionViewLayout isKindOfClass:[HDCollectionViewLayout class]]) {
        HDCollectionViewLayout *layout = (HDCollectionViewLayout*)self.collectionV.collectionViewLayout;
        [layout setAllNeedUpdate];
        [self updateHDColltionViewDataType:HDDataChangeSetAll start:[NSValue valueWithCGPoint:CGPointZero]];
    }
    [self updateSecitonModelDict:YES];
    [self hd_reloadData];
}

- (void)hd_reloadAll
{
    [self.allDataArr enumerateObjectsUsingBlock:^(id<HDSectionModelProtocol>  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj.sectionDataArr enumerateObjectsUsingBlock:^(id<HDCellModelProtocol>  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            obj.isConvertedToVM = NO;
        }];
    }];
    [self hd_setAllDataArr:self.allDataArr];
}
#pragma mark - allCallBack
- (void)hd_setAllEventCallBack:(void (^)(id , HDCallBackType))callback
{
    if (callback) {
        allEventCallbcak = callback;
    }
}

//Public
#pragma mark - dataSet
- (void)hd_setAllDataArr:(NSArray<id<HDSectionModelProtocol>>*)dataArr
{
    HDDoSomeThingInMainQueue(^{
        self.allSecDict = nil;
        if (!dataArr) {
            self.allDataCopy = @[].mutableCopy;
        }else{
            self.allDataCopy = dataArr.mutableCopy;
        }
        [self hd_autoCountAllViewsHeight];
        [self layoutIfNeeded];
    });
}

- (void)hd_appendDataWithSecModel:(id<HDSectionModelProtocol> )secModel animated:(BOOL)animated
{
    HDDoSomeThingInMainQueue(^{
        if (!secModel) {
            return;
        }
        self->_isAppendingOrInsertingSection = YES;
        if (self.allDataArr.count == 0) {
            [self layoutIfNeeded];
        }
        
        void(^updateLayout)(void) = ^(){
            [(NSObject*)secModel setValue:@(self.allDataArr.count) forKey:@"section"];
            if (secModel.isNeedAutoCountCellHW) {
                [self hd_autoCountCellsHeight:secModel ignoreCache:YES];
                [self updateHDColltionViewDataType:HDDataChangeAppendSec start:nil];
                [self insertOneSection:secModel atIndex:NSIntegerMax];
            }else{
                [self updateHDColltionViewDataType:HDDataChangeAppendSec start:nil];
                [self insertOneSection:secModel atIndex:NSIntegerMax];
            }
        };
        
        if (animated) {
            //这里是插入一个段
            [self.collectionV performBatchUpdates:^{
                updateLayout();
                [self.collectionV insertSections:[NSIndexSet indexSetWithIndex:self.allDataArr.count-1]];
            } completion:^(BOOL finished) {
                self->_isAppendingOrInsertingSection = NO;
                [self hd_dataDealFinishCallback:HDDataChangeAppendSec animated:animated];
            }];

        }else{
            updateLayout();
            self->_isAppendingOrInsertingSection = NO;
            [self hd_dataDealFinishCallback:HDDataChangeAppendSec];
        }
    });
}

- (void)hd_appendDataWithSecModelArr:(NSArray<id<HDSectionModelProtocol>> *)secModels animated:(BOOL)animated
{
    HDDoSomeThingInMainQueue(^{
        if (![secModels isKindOfClass:NSArray.class]) {
            return;
        }
        self->_isAppendingOrInsertingSection = YES;
        NSMutableArray<id<HDSectionModelProtocol>> *filterSecArr = @[].mutableCopy;
        [secModels enumerateObjectsUsingBlock:^(id<HDSectionModelProtocol>  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj conformsToProtocol:@protocol(HDSectionModelProtocol)]) {
                [filterSecArr addObject:obj];
            }
        }];
        if (self.allDataArr.count == 0) {
            [self layoutIfNeeded];
        }
        NSInteger insertBeginIndex = self.allDataArr.count;
        void(^updateLayout)(void) = ^(){
            [filterSecArr enumerateObjectsUsingBlock:^(id<HDSectionModelProtocol> _Nonnull secModel, NSUInteger idx, BOOL * _Nonnull stop) {
                [(NSObject*)secModel setValue:@(self.allDataArr.count) forKey:@"section"];
                if (secModel.isNeedAutoCountCellHW) {
                    [self hd_autoCountCellsHeight:secModel ignoreCache:YES];
                }
            }];
            [self updateHDColltionViewDataType:HDDataChangeAppendSecs start:nil];
            [self appendSections:secModels];
        };
        
        if (animated) {
            [self.collectionV performBatchUpdates:^{
                updateLayout();
                NSIndexSet *indexSet = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(insertBeginIndex, filterSecArr.count)];
                [self.collectionV insertSections:indexSet];
            } completion:^(BOOL finished) {
                self->_isAppendingOrInsertingSection = NO;
                [self hd_dataDealFinishCallback:HDDataChangeAppendSecs animated:animated];
            }];

        }else{
            updateLayout();
            self->_isAppendingOrInsertingSection = NO;
            [self hd_dataDealFinishCallback:HDDataChangeAppendSecs];
        }
        
        
    });
}

- (void)hd_insertDataWithSecModel:(id<HDSectionModelProtocol>)secModel atIndex:(NSInteger)index animated:(BOOL)animated
{
    HDDoSomeThingInMainQueue(^{
        if (!secModel) {
            return;
        }
        self->_isAppendingOrInsertingSection = YES;
        if (self.allDataArr.count == 0) {
            [self layoutIfNeeded];
        }
        
        NSValue *finalStart = nil;
        if (index <= 0) {
            finalStart = [NSValue valueWithCGPoint:CGPointZero];
        }else if (index >= self.allDataArr.count){
            //append 到最后,布局起点坐标无需更新
        }else{
            //插入到哪个section的后面，起点就是那个section的结尾
            //找到前面的那个section
            HDSectionModel *frontSec = nil;
            if (index-1<self.allDataArr.count) {
                frontSec = self.allDataArr[index-1];
            }
            if (!frontSec) {
                finalStart = [NSValue valueWithCGPoint:CGPointZero];
            }else{
                finalStart = [NSValue valueWithCGPoint:frontSec.layout.cacheEnd];
                secModel.layout.cacheStart = finalStart.CGPointValue;
            }
        }
        
        NSInteger finalInsertIndex = [self getFinalIndexWithArr:self.allDataArr wantInsertIndex:index];
        void(^updateLayout)(void) = ^(){
            [(NSObject*)secModel setValue:@(finalInsertIndex) forKey:@"section"];
            
            if (secModel.isNeedAutoCountCellHW) {
                [self hd_autoCountCellsHeight:secModel ignoreCache:YES];
                [self updateHDColltionViewDataType:HDDataChangeInsertSec start:finalStart];
                [self insertOneSection:secModel atIndex:index];
            }else{
                [self updateHDColltionViewDataType:HDDataChangeInsertSec start:finalStart];
                [self insertOneSection:secModel atIndex:index];
            }
        };
        
        if (animated) {
            //这里是插入一个段
            [self.collectionV performBatchUpdates:^{
                updateLayout();
                [self.collectionV insertSections:[NSIndexSet indexSetWithIndex:finalInsertIndex]];
            } completion:^(BOOL finished) {
                self->_isAppendingOrInsertingSection = NO;
                [self hd_dataDealFinishCallback:HDDataChangeInsertSec animated:animated];
                
                /*
                   经过测试当使用系统的UICollectionViewFlowLayout时，performBatchUpdates 方法对header/footer/cell的刷新都正常
                   但是使用HDCollectionViewLayout时，
                   performBatchUpdates没有统计到header/footer的变化(它们没有动画，也可能没刷新)，所以这里需要整体重新刷新
                   具体可以对比demo1的footer点击 和 demo6的footer点击
                   目前尚不清楚系统 UICollectionViewFlowLayout 是如何处理header/footer的，如果有知道的同学，请告知下。。。
                   综上，建议使用 HDCollectionViewLayout 时，animated 参数传NO
                 */
                if (![self.collectionV.collectionViewLayout isKindOfClass:UICollectionViewFlowLayout.class]) {
                    [self hd_reloadData];
                }
            }];

        }else{
            updateLayout();
            self->_isAppendingOrInsertingSection = NO;
            [self hd_dataDealFinishCallback:HDDataChangeInsertSec];
        }
        
    });
}

- (void)hd_appendDataWithCellModelArr:(NSArray<id<HDCellModelProtocol>> *)itemArr sectionKey:(NSString *)sectionKey animated:(BOOL)animated animationFinishCallback:(void (^)(void))animationFinish
{
    HDDoSomeThingInMainQueue(^{
        id<HDSectionModelProtocol> secModel = self.allSecDict[sectionKey];
        if (![(NSObject*)secModel conformsToProtocol:@protocol(HDSectionModelProtocol)]) {
            return;
        }
                
        __block NSArray *finalAddItemArr = itemArr;
        if (secModel.isNeedAutoCountCellHW) {
            id<HDSectionModelProtocol> copy = [(NSObject*)secModel copy];
            copy.sectionDataArr = itemArr.mutableCopy;
            [self hd_autoCountCellsHeight:copy ignoreCache:YES];
            finalAddItemArr = copy.sectionDataArr;
        }
        
        void(^updateLayout)(void) = ^(){
            [self updateHDColltionViewDataType:HDDataChangeAppendCellModel start:[NSValue valueWithCGPoint:secModel.layout.cacheStart]];
            [self reloadSectionAfter:secModel.section];
        };
        
        if (animated) {
            NSMutableArray *oldDataArr = secModel.sectionDataArr.mutableCopy;
            NSMutableArray *newArr = secModel.sectionDataArr.mutableCopy;
            [newArr addObjectsFromArray:finalAddItemArr];
            
            [self.collectionV hd_reloadWithSection:secModel.section oldData:oldDataArr newData:newArr sourceDataChangeCode:^(NSArray<id<HDListViewDifferProtocol>> * _Nonnull newArr) {
                secModel.sectionDataArr = newArr.mutableCopy;
                updateLayout();
                
            } animationFinishCallback:^{
                [self hd_dataDealFinishCallback:HDDataChangeAppendCellModel animated:animated];
                if (animationFinish) {
                    animationFinish();
                }
            }];
        }else{
            [secModel.sectionDataArr addObjectsFromArray:finalAddItemArr];
            updateLayout();
            [self hd_dataDealFinishCallback:HDDataChangeAppendCellModel];
        }
    });
}

- (void)hd_appendDataWithCellModelArr:(NSArray<id<HDCellModelProtocol>> *)itemArr sectionKey:(NSString *)sectionKey animated:(BOOL)animated
{
    [self hd_appendDataWithCellModelArr:itemArr sectionKey:sectionKey animated:animated animationFinishCallback:nil];
}

- (void)hd_changeSectionModelWithKey:(NSString *)sectionKey animated:(BOOL)animated changingIn:(void (^)(id<HDSectionModelProtocol>))changeBlock animationFinishCallback:(void (^)(void))animationFinish {
    [self hd_changeSectionModelWithKey:sectionKey animated:animated needReCalculateAllCellHeight:YES changingIn:changeBlock animationFinishCallback:animationFinish];
}

- (void)hd_changeSectionModelWithKey:(NSString *)sectionKey animated:(BOOL)animated changingIn:(void (^)(id<HDSectionModelProtocol>))changeBlock {
    [self hd_changeSectionModelWithKey:sectionKey animated:animated changingIn:changeBlock animationFinishCallback:nil];
}

- (void)hd_changeSectionModelWithKey:(nullable NSString*)sectionKey
                            animated:(BOOL)animated
        needReCalculateAllCellHeight:(BOOL)isNeedReCalculateAllCellHeight
                          changingIn:(void(^)(id<HDSectionModelProtocol> secModel))changeBlock {
    [self hd_changeSectionModelWithKey:sectionKey animated:animated needReCalculateAllCellHeight:isNeedReCalculateAllCellHeight changingIn:changeBlock animationFinishCallback:nil];
}

- (void)hd_changeSectionModelWithKey:(NSString *)sectionKey animated:(BOOL)animated needReCalculateAllCellHeight:(BOOL)isNeedReCalculateAllCellHeight changingIn:(void (^)(id<HDSectionModelProtocol>))changeBlock animationFinishCallback:(void (^)(void))animationFinish
{
    HDDoSomeThingInMainQueue(^{
        if (!sectionKey) {
            return;
        }
        id<HDSectionModelProtocol> secModel = self.allSecDict[sectionKey];
        if (!secModel) {
            return;
        }
        
        if (changeBlock && !animated) {
            changeBlock(secModel);
        }
        
        void(^updateLayout)(void) = ^(){
            if (secModel.isNeedAutoCountCellHW) {
                [self hd_autoCountCellsHeight:secModel ignoreCache:isNeedReCalculateAllCellHeight];
                secModel.layout.needUpdate = YES;
                [self updateHDColltionViewDataType:HDDataChangeChangeSec
                                             start:[NSValue valueWithCGPoint:secModel.layout.cacheStart]];
                [self reloadSectionAfter:secModel.section];
            }else{
                secModel.layout.needUpdate = YES;
                [self updateHDColltionViewDataType:HDDataChangeChangeSec start:[NSValue valueWithCGPoint:secModel.layout.cacheStart]];
                [self reloadSectionAfter:secModel.section];
            }
        };
        
        if (animated) {
            NSMutableArray *oldDataArr = secModel.sectionDataArr.mutableCopy;
            [self.collectionV hd_reloadWithSection:secModel.section oldData:oldDataArr newArrGenerateCode:^NSArray<id<HDListViewDifferProtocol>> * _Nonnull{
                
                if (changeBlock) {
                    changeBlock(secModel);
                }
                NSArray *newArr = secModel.sectionDataArr.mutableCopy;
                return newArr;
                
            } calculateDiffFinishCb:^{
                
                secModel.sectionDataArr = oldDataArr;//数据源的变更要发生在sourceDataChangeCode中，因为changeBlock()调用后更改了数据源，这里再改回来
                
            } sourceDataChangeCode:^(NSArray<id<HDListViewDifferProtocol>> * _Nonnull newArr) {
                
                secModel.sectionDataArr = newArr.mutableCopy;
                updateLayout();
                
            } animationFinishCallback:^{
                [self hd_dataDealFinishCallback:HDDataChangeChangeSec animated:animated];
                if (animationFinish) {
                    animationFinish();
                }
            }];
            
        }else{
            updateLayout();
            [self hd_dataDealFinishCallback:HDDataChangeChangeSec];
        }
        
    });
}

- (void)hd_deleteSectionWithKey:(NSString *)sectionKey animated:(BOOL)animated animationFinishCallback:(void (^ _Nullable)(void))animationFinish
{
    HDDoSomeThingInMainQueue(^{
        if (!sectionKey || self->_isDeletingSection) {
            return;
        }
        id<HDSectionModelProtocol> secModel = self.allSecDict[sectionKey];
        if (!secModel) {
            return;
        }
        self->_isDeletingSection = YES;
        NSInteger secIndex = NSNotFound;
        secIndex = [self.allDataArr indexOfObject:secModel];
                
        void(^updateLayout)(void) = ^(){
            [self.allSecDict removeObjectForKey:sectionKey];
            if (secIndex != NSNotFound) {
                [self.allDataArr removeObjectAtIndex:secIndex];
                [self updateSecitonModelDict:NO];
                [self updateHDColltionViewDataType:HDDataChangeDeleteSec start:[NSValue valueWithCGPoint:secModel.layout.cacheStart]];
                [self reloadSectionAfter:secIndex];
            }
            
        };
        
        if (animated) {
            [self.collectionV performBatchUpdates:^{
                updateLayout();
                [self.collectionV deleteSections:[NSIndexSet indexSetWithIndex:secIndex]];
            } completion:^(BOOL finished) {
                self->_isDeletingSection = NO;
                [self.collectionV reloadData];
                if (animationFinish) {
                    animationFinish();
                }
                [self hd_dataDealFinishCallback:HDDataChangeDeleteSec animated:animated];
            }];
        }else{
            updateLayout();
            self->_isDeletingSection = NO;
            [self hd_dataDealFinishCallback:HDDataChangeDeleteSec];
        }
    });
}

- (void)hd_deleteSectionWithKey:(NSString *)sectionKey animated:(BOOL)animated
{
    [self hd_deleteSectionWithKey:sectionKey animated:animated animationFinishCallback:nil]; 
}

- (BOOL)hd_sectionModelExist:(NSString *)sectionKey
{
    if (!sectionKey) {
        return NO;
    }
    return self.allSecDict[sectionKey] != nil;
}

//Private
- (void)updateSecitonModelDict:(BOOL)needUpdateLayout
{
    [self.allDataArr enumerateObjectsUsingBlock:^(id<HDSectionModelProtocol> _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [(NSObject*)obj setValue:@(idx) forKey:@"section"];
        [self updateSectionKey:obj];
        obj.layout.needUpdate = needUpdateLayout;
        [self.allSecDict setValue:obj forKey:obj.sectionKey];
    }];
}

- (void)updateSectionKey:(id<HDSectionModelProtocol>)secM
{
    //如果没有自定义sectionKey就更新(这里认为只要是纯数字就不是自定义的)
    if ([self regexIsMatchWithPattern:@"\\d+" needRegexStr:secM.sectionKey]) {
        secM.sectionKey = @(secM.section).stringValue;
    }
}

- (BOOL)regexIsMatchWithPattern:(NSString*)regex needRegexStr:(NSString*)oriStr
{
    if (!oriStr || !regex) {
        return NO;
    }
    NSRegularExpression *regExp = [NSRegularExpression regularExpressionWithPattern:regex options:kNilOptions error:nil];
    NSRange firstMatchR = [regExp rangeOfFirstMatchInString:oriStr options:kNilOptions range:NSMakeRange(0, oriStr.length)];
    return firstMatchR.location != NSNotFound && firstMatchR.length == oriStr.length;
}

- (NSInteger)getFinalIndexWithArr:(NSMutableArray*)arr wantInsertIndex:(NSInteger)index
{
    NSInteger finalIndex = 0;
    if (index <= 0) {
        finalIndex = 0;
    }else if (index >= arr.count){
        finalIndex = arr.count;
    }else{
        finalIndex = index;
    }
    return finalIndex;
}

//添加多段到数据源并更新布局
- (void)appendSections:(NSArray<id<HDSectionModelProtocol>>*)sections
{
    NSInteger reloadBeginIndex = self.allDataArr.count;
    [sections enumerateObjectsUsingBlock:^(id<HDSectionModelProtocol>  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [self.allDataArr addObject:obj];
    }];
    [self updateSecitonModelDict:YES];
    [self reloadSectionAfter:reloadBeginIndex];
}

//添加某段数据到数据源并更新其布局
- (void)insertOneSection:(id<HDSectionModelProtocol>)section atIndex:(NSInteger)index
{
    NSInteger reloadBeginIndex = [self getFinalIndexWithArr:self.allDataArr wantInsertIndex:index];
    if (index <= 0) {
        [self.allDataArr insertObject:section atIndex:0];
    }else if (index >= self.allDataArr.count){
        [self.allDataArr addObject:section];
    }else{
        [self.allDataArr insertObject:section atIndex:index];
    }
    
    [self updateSecitonModelDict:NO];
    section.layout.needUpdate = YES;
    [self reloadSectionAfter:reloadBeginIndex];
}

- (void)reloadSectionAfter:(NSInteger)sectionIndex
{
    HDCollectionViewLayout *layout = (HDCollectionViewLayout*)self.collectionV.collectionViewLayout;
    if ([layout isKindOfClass:[HDCollectionViewLayout class]]) {
        [layout reloadSetionAfter:sectionIndex];
    }
}

- (void)updateHDColltionViewDataType:(HDDataChangeType)type start:(NSValue*)start
{
    if ([self.collectionV.collectionViewLayout isKindOfClass:[HDCollectionViewLayout class]]) {
        HDCollectionViewLayout *layout = (HDCollectionViewLayout*)self.collectionV.collectionViewLayout;
        [layout setHDDataChangeType:type];
    }
    //start为Nil 则不更新，使用原有值
    if (start) {
        [self updateHDCollectionViewLayoutStart:[start CGPointValue]];
    }
}

- (void)updateHDCollectionViewLayoutStart:(CGPoint)start
{
    if ([self.collectionV.collectionViewLayout isKindOfClass:[HDCollectionViewLayout class]]) {
        HDCollectionViewLayout *layout = (HDCollectionViewLayout*)self.collectionV.collectionViewLayout;
        [layout updateCurrentXY:start];
    }
    
}
#pragma mark - 支持原生layout
#pragma mark UICollectionViewDelegate
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    id<HDSectionModelProtocol> secModel = _allDataArr[indexPath.section];
    id<HDCellModelProtocol> cellM = secModel.sectionDataArr[indexPath.item];
    [(NSObject*)secModel setValue:@(indexPath.section) forKey:@"section"];
    [(NSObject*)cellM setValue:indexPath forKey:@"indexP"];
    [(NSObject*)cellM setValue:secModel forKey:@"secModel"];
    if (cellM.cellSizeCb) {
        cellM.cellSize = cellM.cellSizeCb();
    }
    return cellM.cellSize;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    id<HDSectionModelProtocol> secM = _allDataArr[section];
    return secM.layout.secInset;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    id<HDSectionModelProtocol> secM = _allDataArr[section];
    return secM.layout.verticalGap;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    id<HDSectionModelProtocol> secM = _allDataArr[section];
    return secM.layout.horizontalGap;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    id<HDSectionModelProtocol> secM = _allDataArr[section];
    return secM.layout.headerSize;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
{
    id<HDSectionModelProtocol> secM = _allDataArr[section];
    return secM.layout.footerSize;
}

#pragma mark - UIScrollViewDelgate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    //横向滚动时禁止纵向滑动
    if (self.scrollDirection == UICollectionViewScrollDirectionHorizontal) {
        scrollView.contentOffset = CGPointMake(scrollView.contentOffset.x, 0);
    }
    if (scDidScrollCallback) {
        scDidScrollCallback(scrollView);
    }
    //这个用的地方比较多，所以单独做成通知了
    [[NSNotificationCenter defaultCenter] postNotificationName:HDCVScrollViewDidScrollNotificationName object:self];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if (scWillBeginDraggingCallback) {
        scWillBeginDraggingCallback(scrollView);
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (scDidEndDraggingCallback) {
        scDidEndDraggingCallback(scrollView,decelerate);
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (scDidEndDeceleratingCallback) {
        scDidEndDeceleratingCallback(scrollView);
    }
}

#pragma mark -
#pragma mark UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    id<HDSectionModelProtocol> secM;
    if (section<_allDataArr.count) {
        secM = _allDataArr[section];
    }
    return secM.sectionDataArr.count;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return _allDataArr.count;
}

- (UICollectionReusableView*)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    id<HDSectionModelProtocol> secM;
    if (indexPath.section < _allDataArr.count) {
        secM = _allDataArr[indexPath.section];
    }
    [self registerWithCellClass:nil cellReuseID:nil headerClass:secM.sectionHeaderClassStr footerClass:secM.sectionFooterClassStr decorationClass:secM.decorationClassStr];
    __kindof UICollectionReusableView<HDUpdateUIProtocol> * secView = nil;
    if ([HDClassFromString(secM.sectionHeaderClassStr) isSubclassOfClass:[UICollectionReusableView class]]  && [kind isEqualToString:UICollectionElementKindSectionHeader]) {
        //自定义段头
        secView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:[self getSupplementReuseidWithClass:secM.sectionHeaderClassStr kind:UICollectionElementKindSectionHeader] forIndexPath:indexPath];
        [secView setValue:UICollectionElementKindSectionHeader forKey:@"currentElementKind"];
    }else if ([HDClassFromString(secM.sectionFooterClassStr) isSubclassOfClass:[UICollectionReusableView class]] && [kind isEqualToString:UICollectionElementKindSectionFooter]){
        //自定义段尾
        secView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:[self getSupplementReuseidWithClass:secM.sectionFooterClassStr kind:UICollectionElementKindSectionFooter] forIndexPath:indexPath];
        [secView setValue:UICollectionElementKindSectionFooter forKey:@"currentElementKind"];
    }else if ([HDClassFromString(secM.decorationClassStr) isSubclassOfClass:[UICollectionReusableView class]] && [kind isEqualToString:HDDecorationViewKind]){
        //自定义装饰(一段一个)
        secView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:[self getSupplementReuseidWithClass:secM.decorationClassStr kind:HDDecorationViewKind] forIndexPath:indexPath];
        [secView setValue:HDDecorationViewKind forKey:@"currentElementKind"];
    }else{
        //默认段view
        if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
            secView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:[self getSupplementReuseidWithClass:secM.sectionHeaderClassStr kind:UICollectionElementKindSectionHeader] forIndexPath:indexPath];
        }else{
            secView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:[self getSupplementReuseidWithClass:secM.sectionFooterClassStr kind:UICollectionElementKindSectionFooter] forIndexPath:indexPath];
        }
    }
    __hd_WeakSelf
    if ([secView respondsToSelector:@selector(superUpdateSecVUI:callback:)]) {
        id secCallback = ^(id secModel,HDCallBackType type) {
            [weakSelf dealAllCallback:secModel type:type];
        };
        [secView superUpdateSecVUI:secM callback:secCallback];
    }
    if ([secView respondsToSelector:@selector(updateSecVUI:)]) {
        [secView updateSecVUI:secM];
    }
    if (setedSecViewCallback) {
        setedSecViewCallback(secView,indexPath,kind);
    }
    if (indexPath.section == _allDataArr.count-1) {
        [(NSObject*)secM setValue:@(YES) forKey:@"isFinalSection"];
    }else{
        [(NSObject*)secM setValue:@(NO) forKey:@"isFinalSection"];
    }
    
    return secView;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    __hd_WeakSelf
    id<HDSectionModelProtocol> secM = _allDataArr[indexPath.section];
    [(NSObject*)secM setValue:@(indexPath.section) forKey:@"section"];
    
    id<HDCellModelProtocol> cellModel = secM.sectionDataArr[indexPath.item];
    [(NSObject*)cellModel setValue:indexPath forKey:@"indexP"];
    [(NSObject*)cellModel setValue:secM forKey:@"secModel"];
    UICollectionViewLayoutAttributes *cellAtt = [collectionView layoutAttributesForItemAtIndexPath:indexPath];
    [(NSObject*)cellModel setValue:[NSValue valueWithCGPoint:cellAtt.frame.origin] forKey:@"cellFrameXY"];
    
    
    if (![HDClassFromString(cellModel.cellClassStr) isSubclassOfClass:[UICollectionViewCell class]]) {
        cellModel.cellClassStr = secM.sectionCellClassStr;
    }
    
    [self registerWithCellClass:cellModel.cellClassStr cellReuseID:cellModel.reuseIdentifier headerClass:nil footerClass:nil decorationClass:nil];
    
    HDCollectionCell<HDUpdateUIProtocol> *cell;
    
    if (![HDClassFromString(cellModel.cellClassStr) isSubclassOfClass:[UICollectionViewCell class]]) {
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:hd_default_cell_class forIndexPath:indexPath];
#ifdef DEBUG
        NSLog(@"使用了默认cell");
#endif
        
    }else{
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellModel.reuseIdentifier forIndexPath:indexPath];
    }
    
    id callback = ^(id cellModel, HDCallBackType type) {
        [weakSelf dealAllCallback:cellModel type:type];
    };

    //这里先设置frame的原因是后面的函数可能需要用到子view的frame
    //使用isNeedCacheSubviewsFrame时isNeedAutoCountCellHW必须为YES
    if (cellModel.subviewsFrame) {
        if ([cell respondsToSelector:@selector(cacheSubviewsFrameBySetLayoutWithCellModel:)]) {
            [cell setCacheKeysIfNeed];
            [HDCellFrameCacheHelper resetViewSubviewFrame:cell subViewFrame:cellModel.subviewsFrame];
        }
    }
    if ([cell respondsToSelector:@selector(superUpdateCellUI:callback:)]) {
        [cell superUpdateCellUI:cellModel callback:callback];
    }
    if ([cell respondsToSelector:@selector(updateCellUI:)]) {
        [cell updateCellUI:cellModel];
    }
    if (setedCellCallback) {
        setedCellCallback(cell,indexPath);
    }
    return cell;
}

#pragma mark -
#pragma mark register

- (void)registerWithCellClass:(NSString*)cellClassStr cellReuseID:(NSString*)cellID headerClass:(NSString*)headerClassStr footerClass:(NSString*)footerClassStr decorationClass:(NSString*)decorationClassStr
{
    if ((!cellClassStr && !headerClassStr && !footerClassStr && !decorationClassStr) ||
        !self.collectionV) {
        return ;
    }
    if (!cellID) {
        cellID = cellClassStr;
    }
    
    static dispatch_semaphore_t gcd_lock;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        gcd_lock = dispatch_semaphore_create(1);
    });
    
    
    static NSMapTable *weakRegisterRecordMap = nil;
    static dispatch_once_t onceToken2;
    dispatch_once(&onceToken2, ^{
        weakRegisterRecordMap = [NSMapTable mapTableWithKeyOptions:NSPointerFunctionsWeakMemory valueOptions:NSPointerFunctionsCopyIn];
    });
    
    void(^registCell)(NSString*,NSString*,UICollectionView*,NSMapTable *) = ^(NSString*cellCls,NSString*cellReID,UICollectionView*collectionView,NSMapTable *CVMap) {
        if (HDClassFromString(cellCls) && collectionView) {
            dispatch_semaphore_wait(gcd_lock, DISPATCH_TIME_FOREVER);
            
            [collectionView registerClass:HDClassFromString(cellCls) forCellWithReuseIdentifier:cellReID];
            [CVMap setObject:@(1) forKey:cellReID];
            
            dispatch_semaphore_signal(gcd_lock);
        }
    };
    
    void(^registHeader)(NSString*idFd,UICollectionView*collectionView,NSMapTable *CVMap) = ^(NSString*idFd,UICollectionView*collectionView,NSMapTable *CVMap) {
        if (HDClassFromString(idFd) && collectionView) {
            dispatch_semaphore_wait(gcd_lock, DISPATCH_TIME_FOREVER);
            
            NSString *headerID = [self getSupplementReuseidWithClass:idFd kind:UICollectionElementKindSectionHeader];
            [collectionView registerClass:HDClassFromString(idFd) forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headerID];
            [CVMap setObject:@(1) forKey:headerID];
    
            dispatch_semaphore_signal(gcd_lock);
        }
    };
    
    void(^registFooter)(NSString*idFd,UICollectionView*collectionView,NSMapTable *CVMap) = ^(NSString*idFd,UICollectionView*collectionView,NSMapTable *CVMap) {
        if (HDClassFromString(idFd) && collectionView) {
            dispatch_semaphore_wait(gcd_lock, DISPATCH_TIME_FOREVER);
            
            NSString *footerID = [self getSupplementReuseidWithClass:idFd kind:UICollectionElementKindSectionFooter];
            [collectionView registerClass:HDClassFromString(idFd) forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:footerID];
            [CVMap setObject:@(1) forKey:footerID];
            
            dispatch_semaphore_signal(gcd_lock);
        }
    };
    void(^registDecoration)(NSString*idFd,UICollectionView*collectionView,NSMapTable *CVMap) = ^(NSString*idFd,UICollectionView*collectionView,NSMapTable *CVMap) {
        if (HDClassFromString(idFd) && collectionView) {
            dispatch_semaphore_wait(gcd_lock, DISPATCH_TIME_FOREVER);
            
            NSString *decID = [self getSupplementReuseidWithClass:idFd kind:HDDecorationViewKind];
            [collectionView registerClass:HDClassFromString(idFd) forSupplementaryViewOfKind:HDDecorationViewKind withReuseIdentifier:decID];
            [CVMap setObject:@(1) forKey:decID];
            
            dispatch_semaphore_signal(gcd_lock);
        }
    };
    
    NSMapTable *CVMap = [weakRegisterRecordMap objectForKey:self.collectionV];
    if (CVMap) {
        //查找cell是否注册过
        if (![CVMap objectForKey:cellID] && cellID && ![cellID isEqualToString:@""]) {
            registCell(cellClassStr,cellID,self.collectionV,CVMap);
        }
        //查找header是否注册过
        if (![CVMap objectForKey:[self getSupplementReuseidWithClass:headerClassStr kind:UICollectionElementKindSectionHeader]] && headerClassStr && ![headerClassStr isEqualToString:@""]) {
            registHeader(headerClassStr,self.collectionV,CVMap);
        }
        //查找footer是否注册过
        if (![CVMap objectForKey:[self getSupplementReuseidWithClass:footerClassStr kind:UICollectionElementKindSectionFooter]] && footerClassStr && ![footerClassStr isEqualToString:@""]) {
            registFooter(footerClassStr,self.collectionV,CVMap);
        }
        //查找decoration是否注册过
        if (![CVMap objectForKey:[self getSupplementReuseidWithClass:decorationClassStr kind:HDDecorationViewKind]] && decorationClassStr && ![decorationClassStr isEqualToString:@""]) {
            registDecoration(decorationClassStr,self.collectionV,CVMap);
        }
        
    }else{
        dispatch_semaphore_wait(gcd_lock, DISPATCH_TIME_FOREVER);
        CVMap = [NSMapTable mapTableWithKeyOptions:NSPointerFunctionsWeakMemory valueOptions:NSPointerFunctionsCopyIn];
        [weakRegisterRecordMap setObject:CVMap forKey:self.collectionV];
        dispatch_semaphore_signal(gcd_lock);
        [self registerWithCellClass:cellClassStr cellReuseID:cellID headerClass:headerClassStr footerClass:footerClassStr decorationClass:decorationClassStr];
    }
}

- (NSString*)getSupplementReuseidWithClass:(NSString*)clsStr kind:(NSString*)elementKind
{
    if (!clsStr || [clsStr isEqualToString:@""]) {
        clsStr = hd_default_hf_class;
    }
    if ([elementKind isEqualToString:UICollectionElementKindSectionHeader]) {
        return [NSString stringWithFormat:@"%@_header",clsStr];
    }
    if ([elementKind isEqualToString:UICollectionElementKindSectionFooter]) {
        return [NSString stringWithFormat:@"%@_footer",clsStr];
    }
    if ([elementKind isEqualToString:HDDecorationViewKind]) {
        return [NSString stringWithFormat:@"%@_decoration",clsStr];
    }
    return clsStr;
}

#pragma mark - countCellH
- (void)hd_autoCountAllViewsHeight
{
    [self.allDataCopy enumerateObjectsUsingBlock:^(id<HDSectionModelProtocol>  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [(NSObject*)obj setValue:@(idx) forKey:@"section"];
        if (obj.isNeedAutoCountCellHW) {
            [self hd_autoCountCellsHeight:obj ignoreCache:YES];
        }
    }];
    self.allDataArr = self.allDataCopy;
    [self hd_dataDealFinishCallback:HDDataChangeSetAll];
}

- (void)hd_autoCountCellsHeight:(id<HDSectionModelProtocol>)secModel ignoreCache:(BOOL)ignoreCache
{
    NSArray *cellModelArr = secModel.sectionDataArr;
    
    //计算cell的高度/宽度
    [cellModelArr enumerateObjectsUsingBlock:^(id<HDCellModelProtocol> _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [(NSObject*)obj setValue:[NSIndexPath indexPathForItem:idx inSection:secModel.section] forKey:@"indexP"];
        [(NSObject*)obj setValue:secModel forKey:@"secModel"];
        if (obj.cellSizeCb) {
            obj.cellSize = obj.cellSizeCb();
        }
        if (CGSizeEqualToSize(CGSizeZero, obj.cellSize)) {
            obj.cellSize = secModel.layout.cellSize;
        }

        if (![HDClassFromString(obj.cellClassStr) isSubclassOfClass:[UICollectionViewCell class]]) {
            obj.cellClassStr = secModel.sectionCellClassStr;
        }
        if (ignoreCache) {
            [obj calculateCellProperSize:NO];
        }else{
            [obj calculateCellProperSizeWhenNoCache:NO];
        }
    }];
}

-(void)hd_dataChangeFinishedCallBack:(void (^)(HDDataChangeType))finishCallback
{
    dataDealFinishCallback = finishCallback;
}

- (void)hd_dataDealFinishCallback:(HDDataChangeType)type
{
    [self hd_dataDealFinishCallback:type animated:NO];
}

- (void)hd_dataDealFinishCallback:(HDDataChangeType)type animated:(BOOL)animated
{
    if (type == HDDataChangeSetAll) {
        [self hd_reloadDataAndAllLayout];
    }else{
        if (!animated) {
            [self hd_reloadData];
        }
    }
    
    if (dataDealFinishCallback) {
        dataDealFinishCallback(type);
    }
}

#pragma mark -
#pragma mark callBack
- (void)dealAllCallback:(id)model type:(HDCallBackType)type
{
    if (allEventCallbcak) {
        allEventCallbcak(model,type);
    }
}

- (void)hd_setShouldRecognizeSimultaneouslyWithGestureRecognizer:(BOOL (^)(UIGestureRecognizer *, UIGestureRecognizer *))multiGestureCallBack
{
    if (multiGestureCallBack) {
        self.multiGesCallBack = multiGestureCallBack;
    }
}

- (void)hd_setContentSizeChangeCallBack:(void (^)(CGSize))contentSizeChangeCallBack
{
    //确保即使外部多次调用也只 添加一次观察者，否则外部多次调用后，dealloc时将异常
    //非线程安全，多线程调用时外部自行加锁即可
    if (!isObserveContentSize) {
        isObserveContentSize = YES;
        [self.collectionV addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew context:nil];
    }
    self.contentSizeChangeCallBack = contentSizeChangeCallBack;
}

- (void)hd_setChagneDataAndLayoutFailedCallback:(void (^)(void))failedBlock
{
    hdChangeDataFailedCallback = failedBlock;
}

- (void)hd_setScrollViewDidScrollCallback:(void (^)(UIScrollView *))callback
{
    scDidScrollCallback = callback;
}

- (void)hd_setScrollViewWillBeginDraggingCallback:(void (^)(UIScrollView *))callback
{
    scWillBeginDraggingCallback = callback;
}

- (void)hd_setScrollViewDidEndDraggingCallback:(void (^)(UIScrollView *, BOOL))callback
{
    scDidEndDraggingCallback = callback;
}

- (void)hd_setScrollViewDidEndDeceleratingCallback:(void (^)(UIScrollView *))callback
{
    scDidEndDeceleratingCallback = callback;
}

- (void)hd_setCellUIUpdateCallback:(void (^)(__kindof UICollectionViewCell *, NSIndexPath *))setedCallback
{
    setedCellCallback = setedCallback;
}

- (void)hd_setSecViewUIUpdateCallback:(void (^)(__kindof UICollectionReusableView *, NSIndexPath *,NSString*))setedCallback
{
    setedSecViewCallback = setedCallback;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"contentSize"]) {
        if (self.contentSizeChangeCallBack) {
            CGSize newSize = [change[NSKeyValueChangeNewKey] CGSizeValue];
            if (newSize.width!=0 && newSize.height!=0) {
                self.contentSizeChangeCallBack(newSize);
            }
        }
    } else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

#pragma mark -

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.collectionV.frame = self.bounds;
    if (self.isNeedAdaptScreenRotaion) {
        UIInterfaceOrientation oritation = [UIApplication sharedApplication].statusBarOrientation;
        if (lastOrientation != oritation) {
            [self hd_reloadAll];
            lastOrientation = oritation;
        }
    }
}

- (void)dealloc
{
    if (isObserveContentSize) {
        [self.collectionV removeObserver:self forKeyPath:@"contentSize"];
    }
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}
@end

