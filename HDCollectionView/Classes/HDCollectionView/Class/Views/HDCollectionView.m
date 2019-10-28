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
#import "UICollectionView+HDDiffReload.h"
#import <objc/runtime.h>

static NSString *const hd_secmodel_key = @"hd_secmodel_key";
static NSString *const hd_is_all_key   = @"hd_is_all_key";
static NSString *const hd_data_finished_type_key = @"hd_data_finished_type_key";
static NSString *const hd_default_hf_class = @"HDSectionView";
static NSString *const hd_default_cell_class = @"HDCollectionCell";
static NSString *const hd_inner_count_cellH_back_key = @"hd_inner_count_cellH_back_key";
static NSString *const hd_inner_animation_imp_key = @"hd_inner_animation_imp_key";

static char * hd_default_colletionView_maker = "hd_default_colletionView_maker";

@implementation HDInnerCollectionView
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    BOOL(^multiGesCallBack)(UIGestureRecognizer*ges1,UIGestureRecognizer*ges2) = [self.superview valueForKeyPath:@"multiGesCallBack"];
    if (multiGesCallBack) {
        return multiGesCallBack(gestureRecognizer,otherGestureRecognizer);
    }else{
        //默认不响应其他手势
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
    obj.backgroundColor = [UIColor whiteColor];
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
    UIInterfaceOrientation lastOrientation;
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

void HDDoSomeThingInMainQueueSyn(void(^thingsToDo)(void))
{
    if ([NSThread currentThread].isMainThread) {
        if (thingsToDo) {
            thingsToDo();
        }else{
            dispatch_sync(dispatch_get_main_queue(), ^{
                thingsToDo();
            });
        }
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
    _collectionV.backgroundColor = [UIColor clearColor];
    
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
            [self hd_autoCountCellsHeight:sec isAll:NO type:HDDataChangeChangeSec finishCallback:^{
                refreshDataLayout();
            }];
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
    HDDoSomeThingInMainQueueSyn(^{
        self.allDataCopy = dataArr.mutableCopy;
        [self hd_autoCountAllViewsHeight];
    });
}

- (void)hd_appendDataWithSecModel:(id<HDSectionModelProtocol> )secModel animated:(BOOL)animated
{
    HDDoSomeThingInMainQueueSyn(^{
        if (!secModel) {
            return;
        }
        void (^animationImp)(void) = nil;
        if (animated) {
            animationImp = ^(){
                //这块只是让 animationImp 不为空
            };
        }
        
        void(^updateLayout)(void) = ^(){
            if (secModel.isNeedAutoCountCellHW) {
                [self hd_autoCountCellsHeight:secModel isAll:NO type:HDDataChangeAppendSec animationImp:animationImp finishCallback:^{
                    [self updateHDColltionViewDataType:HDDataChangeAppendSec start:nil];
                    [self addOneSection:secModel];
                }];
            }else{
                [self updateHDColltionViewDataType:HDDataChangeAppendSec start:nil];
                [self addOneSection:secModel];
                [self hd_dataDealFinishCallback:HDDataChangeAppendSec reloadDataImp:animationImp];
            }
        };
        
        if (animated) {
            //这里是插入一个段
            updateLayout();//动画前需要先计算要展示view的frame,这里将secModel添加到了数据源
            [self.collectionV performBatchUpdates:^{
                [self.collectionV insertSections:[NSIndexSet indexSetWithIndex:self.allDataArr.count-1]];
            } completion:^(BOOL finished) {
                [self.collectionV reloadData];
            }];

        }else{
            updateLayout();
        }
        

    });
}
- (void)hd_appendDataWithCellModelArr:(NSArray<id<HDCellModelProtocol>> *)itemArr sectionKey:(NSString *)sectionKey animated:(BOOL)animated animationFinishCallback:(void (^)(void))animationFinish
{
    HDDoSomeThingInMainQueueSyn(^{
        id<HDSectionModelProtocol> secModel = self.allSecDict[sectionKey];
        if (![(NSObject*)secModel conformsToProtocol:@protocol(HDSectionModelProtocol)]) {
            return;
        }
        
        void (^animationImp)(void) = nil;
        if (animated) {
            animationImp = ^(){
                //这块只是让 animationImp 不为空
            };
        }
        
        void(^updateLayout)(void) = ^(){
            if (secModel.isNeedAutoCountCellHW) {
                id<HDSectionModelProtocol> copy = [(NSObject*)secModel copy];
                copy.sectionDataArr = itemArr.mutableCopy;
                [self hd_autoCountCellsHeight:copy isAll:NO type:HDDataChangeAppendCellModel animationImp:animationImp finishCallback:^{
                    [secModel.sectionDataArr addObjectsFromArray:copy.sectionDataArr];
                    [self updateHDColltionViewDataType:HDDataChangeAppendCellModel start:[NSValue valueWithCGPoint:secModel.layout.cacheStart]];
                    [self reloadSectionAfter:secModel.section];
                }];
            }else{
                [secModel.sectionDataArr addObjectsFromArray:itemArr];
                [self updateHDColltionViewDataType:HDDataChangeAppendCellModel start:[NSValue valueWithCGPoint:secModel.layout.cacheStart]];
                [self reloadSectionAfter:secModel.section];
                [self hd_dataDealFinishCallback:HDDataChangeAppendCellModel reloadDataImp:animationImp];
            }
        };
        
        
        if (animated) {
            NSMutableArray *oldDataArr = secModel.sectionDataArr.mutableCopy;
            updateLayout();
            NSMutableArray *newArr = secModel.sectionDataArr.mutableCopy;
            secModel.sectionDataArr = oldDataArr;
            
            [self.collectionV hd_reloadWithSection:secModel.section oldData:oldDataArr newData:newArr sourceDataChangeCode:^(NSArray<id<HDListViewDifferProtocol>> * _Nonnull newArr) {
                
                secModel.sectionDataArr = newArr.mutableCopy;
                
            } animationFinishCallback:animationFinish];
        }else{
            updateLayout();
        }
        
    });
}
- (void)hd_appendDataWithCellModelArr:(NSArray<id<HDCellModelProtocol>> *)itemArr sectionKey:(NSString *)sectionKey animated:(BOOL)animated
{
    [self hd_appendDataWithCellModelArr:itemArr sectionKey:sectionKey animated:animated animationFinishCallback:nil];
}
- (void)hd_changeSectionModelWithKey:(NSString *)sectionKey animated:(BOOL)animated changingIn:(void (^)(id<HDSectionModelProtocol>))changeBlock animationFinishCallback:(void (^)(void))animationFinish
{
    HDDoSomeThingInMainQueueSyn(^{
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
        void (^animationImp)(void) = nil;
        if (animated) {
            animationImp = ^(){

            };
        }
        
        void(^updateLayout)(void) = ^(){
            if (secModel.isNeedAutoCountCellHW) {
                [self hd_autoCountCellsHeight:secModel isAll:NO type:HDDataChangeChangeSec animationImp:animationImp finishCallback:^{
                    secModel.layout.needUpdate = YES;
                    [self updateHDColltionViewDataType:HDDataChangeChangeSec start:[NSValue valueWithCGPoint:secModel.layout.cacheStart]];
                    [self reloadSectionAfter:secModel.section];
                }];
                
            }else{
                secModel.layout.needUpdate = YES;
                [self updateHDColltionViewDataType:HDDataChangeChangeSec start:[NSValue valueWithCGPoint:secModel.layout.cacheStart]];
                [self reloadSectionAfter:secModel.section];
                [self hd_dataDealFinishCallback:HDDataChangeChangeSec reloadDataImp:animationImp];
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
                
                updateLayout();
                secModel.sectionDataArr = oldDataArr;//数据源的变更要发生在sourceDataChangeCode中，因为changeBlock()调用后更改了数据源，这里再改回来
                
            } sourceDataChangeCode:^(NSArray<id<HDListViewDifferProtocol>> * _Nonnull newArr) {
                
                secModel.sectionDataArr = newArr.mutableCopy;
                
            } animationFinishCallback:animationFinish];
            
        }else{
            updateLayout();
        }
        
    });
}
- (void)hd_changeSectionModelWithKey:(NSString *)sectionKey animated:(BOOL)animated changingIn:(void (^)(id<HDSectionModelProtocol>))changeBlock
{
    [self hd_changeSectionModelWithKey:sectionKey animated:animated changingIn:changeBlock animationFinishCallback:nil];
}
- (void)hd_deleteSectionWithKey:(NSString *)sectionKey animated:(BOOL)animated
{
    HDDoSomeThingInMainQueueSyn(^{
        if (!sectionKey) {
            return;
        }
        id<HDSectionModelProtocol> secModel = self.allSecDict[sectionKey];
        if (!secModel) {
            return;
        }
        
        id<HDSectionModelProtocol> nextSecM = nil;
        NSInteger secIndex = 0;
        
        if (self.allDataArr.count>secModel.section+1) {
            nextSecM = self.allDataArr[secModel.section+1];
        }
        secIndex = [self.allDataArr indexOfObject:secModel];
        if (secIndex != NSNotFound) {
            [self.allDataArr removeObjectAtIndex:secIndex];
        }
        [self.allSecDict removeObjectForKey:sectionKey];
        
        void (^animationImp)(void) = nil;
        if (animated) {
            animationImp = ^(){
                [self.collectionV performBatchUpdates:^{
                    [self.collectionV deleteSections:[NSIndexSet indexSetWithIndex:secIndex]];
                } completion:^(BOOL finished) {
                    [self.collectionV reloadData];
                }];
            };
        }
        
        
        [self updateSecitonModelDict:NO];
        [self updateHDColltionViewDataType:HDDataChangeDeleteSec start:[NSValue valueWithCGPoint:secModel.layout.cacheStart]];
        [self reloadSectionAfter:secIndex];
        [self hd_dataDealFinishCallback:HDDataChangeDeleteSec reloadDataImp:animationImp];
    });
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
    return firstMatchR.location != NSNotFound && firstMatchR.length != 0;
}
- (void)addOneSection:(id<HDSectionModelProtocol>)section
{
    [self.allDataArr addObject:section];
    [self updateSecitonModelDict:NO];
    section.layout.needUpdate = YES;
    [self reloadSectionAfter:self.allDataArr.count-1];
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
    if (!secModel.isNeedAutoCountCellHW) {
        if (cellM.cellSizeCb) {
            cellM.cellSize = cellM.cellSizeCb();
        }
    }
    if (CGSizeEqualToSize(cellM.cellSize, CGSizeZero)) {
        cellM.cellSize = secModel.layout.cellSize;
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
    id<HDSectionModelProtocol> secM = _allDataArr[indexPath.section];
    [self registerWithCellClass:nil cellReuseID:nil headerClass:secM.sectionHeaderClassStr footerClass:secM.sectionFooterClassStr decorationClass:secM.decorationClassStr];
    __kindof UICollectionReusableView<HDUpdateUIProtocol> * secView = nil;
    if ([NSClassFromString(secM.sectionHeaderClassStr) isSubclassOfClass:[UICollectionReusableView class]]  && [kind isEqualToString:UICollectionElementKindSectionHeader]) {
        //自定义段头
        secView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:[self getSupplementReuseidWithClass:secM.sectionHeaderClassStr kind:UICollectionElementKindSectionHeader] forIndexPath:indexPath];
        [secView setValue:UICollectionElementKindSectionHeader forKey:@"currentElementKind"];
    }else if ([NSClassFromString(secM.sectionFooterClassStr) isSubclassOfClass:[UICollectionReusableView class]] && [kind isEqualToString:UICollectionElementKindSectionFooter]){
        //自定义段尾
        secView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:[self getSupplementReuseidWithClass:secM.sectionFooterClassStr kind:UICollectionElementKindSectionFooter] forIndexPath:indexPath];
        [secView setValue:UICollectionElementKindSectionFooter forKey:@"currentElementKind"];
    }else if ([NSClassFromString(secM.decorationClassStr) isSubclassOfClass:[UICollectionReusableView class]] && [kind isEqualToString:HDDecorationViewKind]){
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
    
    if (![NSClassFromString(cellModel.cellClassStr) isSubclassOfClass:[UICollectionViewCell class]]) {
        cellModel.cellClassStr = secM.sectionCellClassStr;
    }
    
    [self registerWithCellClass:cellModel.cellClassStr cellReuseID:cellModel.reuseIdentifier headerClass:nil footerClass:nil decorationClass:nil];
    
    HDCollectionCell<HDUpdateUIProtocol> *cell;
    
    if (![NSClassFromString(cellModel.cellClassStr) isSubclassOfClass:[UICollectionViewCell class]]) {
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
    if (secM.isNeedAutoCountCellHW&&secM.isNeedCacheSubviewsFrame) {
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
    if ((!cellClassStr && !headerClassStr && !footerClassStr) ||
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
        if (NSClassFromString(cellCls) && collectionView) {
            dispatch_semaphore_wait(gcd_lock, DISPATCH_TIME_FOREVER);
            
            [collectionView registerClass:NSClassFromString(cellCls) forCellWithReuseIdentifier:cellReID];
            [CVMap setObject:@(1) forKey:cellReID];
            
            dispatch_semaphore_signal(gcd_lock);
        }
    };
    
    void(^registHeader)(NSString*idFd,UICollectionView*collectionView,NSMapTable *CVMap) = ^(NSString*idFd,UICollectionView*collectionView,NSMapTable *CVMap) {
        if (NSClassFromString(idFd) && collectionView) {
            dispatch_semaphore_wait(gcd_lock, DISPATCH_TIME_FOREVER);
            
            NSString *headerID = [self getSupplementReuseidWithClass:idFd kind:UICollectionElementKindSectionHeader];
            [collectionView registerClass:NSClassFromString(idFd) forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headerID];
            [CVMap setObject:@(1) forKey:headerID];
    
            dispatch_semaphore_signal(gcd_lock);
        }
    };
    
    void(^registFooter)(NSString*idFd,UICollectionView*collectionView,NSMapTable *CVMap) = ^(NSString*idFd,UICollectionView*collectionView,NSMapTable *CVMap) {
        if (NSClassFromString(idFd) && collectionView) {
            dispatch_semaphore_wait(gcd_lock, DISPATCH_TIME_FOREVER);
            
            NSString *footerID = [self getSupplementReuseidWithClass:idFd kind:UICollectionElementKindSectionFooter];
            [collectionView registerClass:NSClassFromString(idFd) forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:footerID];
            [CVMap setObject:@(1) forKey:footerID];
            
            dispatch_semaphore_signal(gcd_lock);
        }
    };
    void(^registDecoration)(NSString*idFd,UICollectionView*collectionView,NSMapTable *CVMap) = ^(NSString*idFd,UICollectionView*collectionView,NSMapTable *CVMap) {
        if (NSClassFromString(idFd) && collectionView) {
            dispatch_semaphore_wait(gcd_lock, DISPATCH_TIME_FOREVER);
            
            NSString *decID = [self getSupplementReuseidWithClass:idFd kind:HDDecorationViewKind];
            [collectionView registerClass:NSClassFromString(idFd) forSupplementaryViewOfKind:HDDecorationViewKind withReuseIdentifier:decID];
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
    [self hd_inner_autoCountAllViewsHeight];
    
}
//计算所有宽高
-(void)hd_inner_autoCountAllViewsHeight
{
    [self.allDataCopy enumerateObjectsUsingBlock:^(id<HDSectionModelProtocol>  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [(NSObject*)obj setValue:@(idx) forKey:@"section"];
        if (obj.isNeedAutoCountCellHW) {
            //当计算整体section的时候，内部的每个section将不会再延时执行
            [self hd_autoCountCellsHeight:obj isAll:YES type:HDDataChangeSetAll finishCallback:^{
                
            }];
        }
    }];
    self.allDataArr = self.allDataCopy;
    [self updateHDColltionViewDataType:HDDataChangeSetAll start:[NSValue valueWithCGPoint:CGPointZero]];
    [self hd_dataDealFinishCallback:HDDataChangeSetAll];
}

//计算宽高
- (void)hd_realCountCellsH:(NSDictionary*)pars
{
    void(^innerFinishCallBack)(void)  = pars[hd_inner_count_cellH_back_key];
    void(^animationBlock)(void) = pars[hd_inner_animation_imp_key];
    id<HDSectionModelProtocol> secModel = pars[hd_secmodel_key];
    BOOL isAll = [pars[hd_is_all_key] boolValue];
    HDDataChangeType type = [pars[hd_data_finished_type_key] integerValue];
    
    void(^executeFinish)(void) = ^(void){
        //内部回调 通知某个setion计算完成
        if (innerFinishCallBack) {
            innerFinishCallBack();
        }
        //1、当需要的是只计算单个section的时候才调用该回调，用于通知外部完成计算 2、所有的setion计算完成回调在setAlldata完成之后
        if (!isAll) {
            [self hd_dataDealFinishCallback:type reloadDataImp:animationBlock];
        }
    };
    if (!secModel.isNeedAutoCountCellHW) {
        executeFinish();
        return;
    }
    
    NSArray *cellModelArr = secModel.sectionDataArr;
    
    //计算cell的高度/宽度
//    __block CGFloat cellWidth = secCellSize.width;
//    __block CGFloat cellFitH = 0;
    [cellModelArr enumerateObjectsUsingBlock:^(id<HDCellModelProtocol> _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [(NSObject*)obj setValue:[NSIndexPath indexPathForItem:idx inSection:secModel.section] forKey:@"indexP"];
        if (obj.cellSizeCb) {
            obj.cellSize = obj.cellSizeCb();
        }
        if (CGSizeEqualToSize(CGSizeZero, obj.cellSize)) {
            obj.cellSize = secModel.layout.cellSize;
        }

        if (![NSClassFromString(obj.cellClassStr) isSubclassOfClass:[UICollectionViewCell class]]) {
            obj.cellClassStr = secModel.sectionCellClassStr;
        }
        [obj calculateCellProperSize:secModel.isNeedCacheSubviewsFrame forceUseAutoLayout:NO];
    }];

    executeFinish();
}

- (void)hd_autoCountCellsHeight:(id<HDSectionModelProtocol>)secModel isAll:(BOOL)isAll type:(HDDataChangeType)type finishCallback:(void(^)(void))finishCb
{
    [self hd_autoCountCellsHeight:secModel isAll:isAll type:type animationImp:nil finishCallback:finishCb];
}
- (void)hd_autoCountCellsHeight:(id<HDSectionModelProtocol>)secModel isAll:(BOOL)isAll type:(HDDataChangeType)type animationImp:(void(^)(void))animationBlock finishCallback:(void(^)(void))finishCb
{
    NSMutableDictionary *par = @{hd_secmodel_key:secModel,hd_is_all_key:@(isAll),hd_data_finished_type_key:@(type)}.mutableCopy;
    if (animationBlock) {
        par[hd_inner_animation_imp_key] = animationBlock;
    }
    if (finishCb) {
        par[hd_inner_count_cellH_back_key] = finishCb;
    }
    if (isAll) {
        [self hd_realCountCellsH:par];
    }else{
        [self hd_realCountCellsH:par];
    }
}
-(void)hd_dataChangeFinishedCallBack:(void (^)(HDDataChangeType))finishCallback
{
    dataDealFinishCallback = finishCallback;
}
- (void)hd_dataDealFinishCallback:(HDDataChangeType)type
{
    [self hd_dataDealFinishCallback:type reloadDataImp:nil];
}
- (void)hd_dataDealFinishCallback:(HDDataChangeType)type reloadDataImp:(void(^)(void))reloadDataBlock
{
    if (type == HDDataChangeSetAll) {
        [self hd_reloadDataAndAllLayout];
    }else{
        if (reloadDataBlock) {
            reloadDataBlock();
        }else{
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
}
@end

