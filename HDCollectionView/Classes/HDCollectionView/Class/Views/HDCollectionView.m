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
#import <objc/runtime.h>

static NSString *const hd_secmodel_key = @"hd_secmodel_key";
static NSString *const hd_is_all_key   = @"hd_is_all_key";
static NSString *const hd_data_finished_type_key = @"hd_data_finished_type_key";
static NSString *const hd_default_hf_class = @"HDSectionView";
static NSString *const hd_inner_count_cellH_back_key = @"hd_inner_count_cellH_back_key";
static char * hd_default_colletionView_maker = "hd_default_colletionView_maker";

@implementation HDInnerCollectionView
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    BOOL(^multiGesCallBack)(UIGestureRecognizer*ges1,UIGestureRecognizer*ges2) = [self.superview valueForKeyPath:@"multiGesCallBack"];
    if (multiGesCallBack) {
        return multiGesCallBack(gestureRecognizer,otherGestureRecognizer);
    }else{
        return [gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]] && [otherGestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]];
    }
}
@end

#pragma mark - ChainMaker
@interface HDCollectionViewMaker()
@property (nonatomic)  BOOL  isNeedTopStop;
@property (nonatomic)  BOOL  isCalculateCellHOnCommonModes;
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
    if (self.keysSetedMap[@"isCalculateCellHOnCommonModes"]){
        [obj setValue:@(self.isCalculateCellHOnCommonModes) forKeyPath:@"isCalculateCellHOnCommonModes"];
    }else{
        [obj setValue:@(defultMaker.isCalculateCellHOnCommonModes) forKeyPath:@"isCalculateCellHOnCommonModes"];
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
-(HDCollectionViewMaker* (^)(BOOL ))hd_isCalculateCellHOnCommonModes
{
    return ^(BOOL  isCalculateCellHOnCommonModes){
        self.isCalculateCellHOnCommonModes = isCalculateCellHOnCommonModes;
        self.keysSetedMap[@"isCalculateCellHOnCommonModes"] = @(YES);
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
    void(^allEventCallbcak)(id backModel, HDCallBackType);
    void (^setedCellCallback)(__kindof UICollectionViewCell *, NSIndexPath *);
    void (^setedSecViewCallback)(__kindof UICollectionViewCell *, NSIndexPath *,NSString*);
    void (^dataDealFinishCallback)(HDDataChangeType);
    UIInterfaceOrientation lastOrientation;
}
@property (nonatomic, strong) NSMutableArray *allDataCopy;
@property (nonatomic, strong, readonly) NSMutableArray<HDSectionModel*>* allDataArr;
@property (nonatomic, copy) BOOL (^multiGesCallBack)(UIGestureRecognizer*ges1,UIGestureRecognizer*ges2);
@property (nonatomic, strong) NSMutableDictionary *allSecDict;
@end

@implementation HDCollectionView
@synthesize collectionV = _collectionV;
@synthesize allDataArr = _allDataArr;
    
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
    
    
+ (void)load
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        HDCollectionViewMaker *maker = [HDCollectionViewMaker new];
        maker.isNeedTopStop = NO;
        maker.isCalculateCellHOnCommonModes = NO;
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

#pragma mark - lazyload
- (NSMutableDictionary *)allSecDict{
    if (!_allSecDict) {
        _allSecDict = @{}.mutableCopy;
    }
    return _allSecDict;
}
- (NSMutableArray<HDSectionModel *> *)allDataArr
{
    if (!_allDataArr) {
        _allDataArr = @[].mutableCopy;
    }
    return _allDataArr;
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
        _collectionV.backgroundColor = [UIColor whiteColor];
        _collectionV.contentInset = UIEdgeInsetsZero;
        [self registerWithCellClass:nil headerClass:hd_default_hf_class footerClass:hd_default_hf_class decorationClass:nil];
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
    HDSectionModel *sec = _allSecDict[sectionKey];
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
- (void)hd_setAllDataArr:(NSMutableArray<HDSectionModel*>*)dataArr
{
    self.allDataCopy = dataArr.mutableCopy;
    [self hd_autoCountAllViewsHeight];

}
- (void)setAllDataArr:(NSMutableArray<HDSectionModel *> *)allDataArr
{
    _allDataArr = allDataArr;
}
- (void)hd_appendDataWithSecModel:(HDSectionModel *)secModel
{
    if (!secModel) {
        return;
    }

    if (secModel.isNeedAutoCountCellHW) {
        [self hd_autoCountCellsHeight:secModel isAll:NO type:HDDataChangeAppendSec finishCallback:^{
            [self updateHDColltionViewDataType:HDDataChangeAppendSec start:nil];
            [self addOneSection:secModel];
        }];
    }else{
        [self updateHDColltionViewDataType:HDDataChangeAppendSec start:nil];
        [self addOneSection:secModel];
        [self hd_dataDealFinishCallback:HDDataChangeAppendSec];
    }

}

- (void)hd_appendDataWithCellModelArr:(NSArray<HDCellModel *> *)itemArr sectionKey:(NSString *)sectionKey
{
    if (!sectionKey) {
        return;
    }
    HDSectionModel *secModel = self.allSecDict[sectionKey];
    if (!secModel) {
        return;
    }
    if (secModel.isNeedAutoCountCellHW) {
        HDSectionModel *copy = [secModel copy];
        copy.sectionDataArr = itemArr.mutableCopy;
        [self hd_autoCountCellsHeight:copy isAll:NO type:HDDataChangeAppendCellModel finishCallback:^{
            [secModel.sectionDataArr addObjectsFromArray:copy.sectionDataArr];
            [self updateHDColltionViewDataType:HDDataChangeAppendCellModel start:[NSValue valueWithCGPoint:secModel.layout.cacheStart]];
            [self reloadSectionAfter:secModel.section];
        }];
    }else{
        
        void(^appendAction)(void) = ^(){
            [secModel.sectionDataArr addObjectsFromArray:itemArr];
            [self updateHDColltionViewDataType:HDDataChangeAppendCellModel start:[NSValue valueWithCGPoint:secModel.layout.cacheStart]];
            [self reloadSectionAfter:secModel.section];
            [self hd_dataDealFinishCallback:HDDataChangeAppendCellModel];
        };
        
        if (_isCalculateCellHOnCommonModes) {
            appendAction();
        }else{
            HDDoSomeThingInMode(NSDefaultRunLoopMode, ^{
                appendAction();
            });
        }
    }
    
}
- (void)hd_changeSectionModelWithKey:(NSString *)sectionKey changingIn:(void (^)(HDSectionModel *))changeBlock
{
    if (!sectionKey) {
        return;
    }
    HDSectionModel *secModel = self.allSecDict[sectionKey];
    if (!secModel) {
        return;
    }
    if (changeBlock) {
        changeBlock(secModel);
    }
    if (secModel.isNeedAutoCountCellHW) {
        [self hd_autoCountCellsHeight:secModel isAll:NO type:HDDataChangeChangeSec finishCallback:^{
            secModel.layout.needUpdate = YES;
            [self updateHDColltionViewDataType:HDDataChangeChangeSec start:[NSValue valueWithCGPoint:secModel.layout.cacheStart]];
            [self reloadSectionAfter:secModel.section];
        }];
    }else{
        secModel.layout.needUpdate = YES;
        [self updateHDColltionViewDataType:HDDataChangeChangeSec start:[NSValue valueWithCGPoint:secModel.layout.cacheStart]];
        [self reloadSectionAfter:secModel.section];
        [self hd_dataDealFinishCallback:HDDataChangeChangeSec];
    }
    
}
- (void)hd_deleteSectionWithKey:(NSString *)sectionKey
{
    if (!sectionKey) {
        return;
    }
    HDSectionModel *secModel = self.allSecDict[sectionKey];
    if (!secModel) {
        return;
    }
    HDSectionModel *nextSecM = nil;
    NSInteger secIndex = 0;

    if (self.allDataArr.count>secModel.section+1) {
        nextSecM = self.allDataArr[secModel.section+1];
    }
    secIndex = [self.allDataArr indexOfObject:secModel];
    if (secIndex != NSNotFound) {
        [self.allDataArr removeObjectAtIndex:secIndex];
    }
    
    [self.allSecDict removeObjectForKey:sectionKey];
    
    [self updateSecitonModelDict:NO];
    [self updateHDColltionViewDataType:HDDataChangeDeleteSec start:[NSValue valueWithCGPoint:secModel.layout.cacheStart]];
    [self reloadSectionAfter:secIndex];
    [self hd_dataDealFinishCallback:HDDataChangeDeleteSec];
    
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
    [self.allDataArr enumerateObjectsUsingBlock:^(HDSectionModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj setValue:@(idx) forKey:@"section"];
        [self updateSectionKey:obj];
        obj.layout.needUpdate = needUpdateLayout;
        [self.allSecDict setValue:obj forKey:obj.sectionKey];
    }];
}
- (void)updateSectionKey:(HDSectionModel*)secM
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
- (void)addOneSection:(HDSectionModel*)section
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
    HDSectionModel *secModel = _allDataArr[indexPath.section];
    HDCellModel *cellM = secModel.sectionDataArr[indexPath.item];
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
    HDSectionModel *secM = _allDataArr[section];
    return secM.layout.secInset;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    HDSectionModel *secM = _allDataArr[section];
    return secM.layout.verticalGap;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    HDSectionModel *secM = _allDataArr[section];
    return secM.layout.horizontalGap;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    HDSectionModel *secM = _allDataArr[section];
    return secM.layout.headerSize;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
{
    HDSectionModel *secM = _allDataArr[section];
    return secM.layout.footerSize;
}

#pragma mark - UIScrollViewDelgate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    //横向滚动时禁止纵向滑动
    if (self.scrollDirection == UICollectionViewScrollDirectionHorizontal) {
        scrollView.contentOffset = CGPointMake(scrollView.contentOffset.x, 0);
    }
}
#pragma mark -
#pragma mark UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    HDSectionModel *secM = _allDataArr[section];
    return secM.sectionDataArr.count;
}
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return _allDataArr.count;
}

- (UICollectionReusableView*)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    HDSectionModel *secM = _allDataArr[indexPath.section];
    [self registerWithCellClass:nil headerClass:secM.sectionHeaderClassStr footerClass:secM.sectionFooterClassStr decorationClass:secM.decorationClassStr];
    __kindof UICollectionReusableView<HDUpdateUIProtocol> * secView = nil;
    if ([NSClassFromString(secM.sectionHeaderClassStr) isSubclassOfClass:[UICollectionReusableView class]]  && [kind isEqualToString:UICollectionElementKindSectionHeader]) {
        //自定义段头
        secView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:[self getSupplementReuseidWithClass:secM.sectionHeaderClassStr kind:UICollectionElementKindSectionHeader] forIndexPath:indexPath];
    }else if ([NSClassFromString(secM.sectionFooterClassStr) isSubclassOfClass:[UICollectionReusableView class]] && [kind isEqualToString:UICollectionElementKindSectionFooter]){
        //自定义段尾
        secView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:[self getSupplementReuseidWithClass:secM.sectionFooterClassStr kind:UICollectionElementKindSectionFooter] forIndexPath:indexPath];
    }else if ([NSClassFromString(secM.decorationClassStr) isSubclassOfClass:[UICollectionReusableView class]] && [kind isEqualToString:HDDecorationViewKind]){
        //自定义装饰(一段一个)
        secView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:[self getSupplementReuseidWithClass:secM.decorationClassStr kind:HDDecorationViewKind] forIndexPath:indexPath];
    }else{
        //默认段view
        if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
            secView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:[self getSupplementReuseidWithClass:secM.sectionHeaderClassStr kind:UICollectionElementKindSectionHeader] forIndexPath:indexPath];
        }else{
            secView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:[self getSupplementReuseidWithClass:secM.sectionFooterClassStr kind:UICollectionElementKindSectionFooter] forIndexPath:indexPath];
        }
    }
    __hd_WeakSelf
    
    if ([secView respondsToSelector:@selector(updateSecVUI:callback:)]) {
        id secCallback = ^(id secModel,HDCallBackType type) {
            [weakSelf dealAllCallback:secModel type:type];
        };
        if ([secView isKindOfClass:NSClassFromString(@"HDSectionView")]) {
            [secView setValue:secCallback forKey:@"callback"];
            [secView setValue:secM forKey:@"hdSecModel"];
        }
        [secView updateSecVUI:secM callback:secCallback];
    }
    if (setedSecViewCallback) {
        setedSecViewCallback(secView,indexPath,kind);
    }
    if (indexPath.section == _allDataArr.count-1) {
        [secM setValue:@(YES) forKey:@"isFinalSection"];
    }else{
        [secM setValue:@(NO) forKey:@"isFinalSection"];
    }
    
    return secView;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
//    NSLog(@"%@",indexPath);
    __hd_WeakSelf
    HDSectionModel *secM = _allDataArr[indexPath.section];
    [secM setValue:@(indexPath.section) forKey:@"section"];
    HDCellModel* cellModel = secM.sectionDataArr[indexPath.item];
    [cellModel setValue:indexPath forKey:@"indexP"];
    [cellModel setValue:secM forKey:@"secModel"];
    
    if (![NSClassFromString(cellModel.cellClassStr) isSubclassOfClass:[UICollectionViewCell class]]) {
        cellModel.cellClassStr = secM.sectionCellClassStr;
    }
    NSAssert([NSClassFromString(cellModel.cellClassStr) isSubclassOfClass:[UICollectionViewCell class]], @"cellModel.cellClassStr 或 secM.sectionCellClassStr必须是 UICollectionViewCell或其子类");
    
    [self registerWithCellClass:cellModel.cellClassStr headerClass:nil footerClass:nil decorationClass:nil];
    
    HDCollectionCell<HDUpdateUIProtocol> *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellModel.cellClassStr forIndexPath:indexPath];
    id callback = ^(id cellModel, HDCallBackType type) {
        [weakSelf dealAllCallback:cellModel type:type];
    };
    if ([cell respondsToSelector:@selector(superUpdateCellUI:callback:)]) {
        [cell superUpdateCellUI:cellModel callback:callback];
    }
    if ([cell respondsToSelector:@selector(updateCellUI:callback:)]) {
        [cell updateCellUI:cellModel callback:callback];
    }
    if (secM.isNeedCacheSubviewsFrame) {
        if ([cell respondsToSelector:@selector(cacheSubviewsFrameBySetLayoutWithCellModel:)]) {
            [HDCellFrameCacheHelper resetViewSubviewFrame:cell subViewFrame:cellModel.subviewsFrame];
        }
    }
    
    if (setedCellCallback) {
        setedCellCallback(cell,indexPath);
    }
//    NSLog(@"%@----%@",indexPath,cell);
    return cell;
}

#pragma mark -
#pragma mark register

- (void)registerWithCellClass:(NSString*)cellClassStr headerClass:(NSString*)headerClassStr footerClass:(NSString*)footerClassStr decorationClass:(NSString*)decorationClassStr
{
    if ((!cellClassStr && !headerClassStr && !footerClassStr) ||
        !self.collectionV) {
        return ;
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
    
    void(^registCell)(NSString*idFd,UICollectionView*collectionView,NSMapTable *CVMap) = ^(NSString*idFd,UICollectionView*collectionView,NSMapTable *CVMap) {
        if (NSClassFromString(idFd) && collectionView) {
            dispatch_semaphore_wait(gcd_lock, DISPATCH_TIME_FOREVER);
            
            [collectionView registerClass:NSClassFromString(idFd) forCellWithReuseIdentifier:idFd];
            [CVMap setObject:@(1) forKey:idFd];
            
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
        if (![CVMap objectForKey:cellClassStr] && cellClassStr && ![cellClassStr isEqualToString:@""]) {
            registCell(cellClassStr,self.collectionV,CVMap);
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
        [self registerWithCellClass:cellClassStr headerClass:headerClassStr footerClass:footerClassStr decorationClass:decorationClassStr];
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
    if (_isCalculateCellHOnCommonModes) {
        [self hd_inner_autoCountAllViewsHeight];
    }else{        
        HDDoSomeThingInMode(NSDefaultRunLoopMode, ^{
            //1、整体放到NSDefaultRunLoopMode延时执行（默认是在NSRunLoopCommonModes）
            //2、原因: 放到NSDefaultRunLoopMode后，加载数据完成后不会立即刷新，如果此时用户正在滑动屏幕，立即计算会引起瞬间的卡顿。主要是为了不与用户争抢CPU。
            //3、效果: 放到NSDefaultRunLoopMode的效果是在加载完数据后，用户手指未脱离屏幕一直不会刷新，直至手指离开屏幕。此时由UITrackingRunLoopMode切换到NSDefaultRunLoopMode，计算才开始执行，参考微信朋友圈刷新。
            [self hd_inner_autoCountAllViewsHeight];
        });
    }
    
}
//计算所有宽高
-(void)hd_inner_autoCountAllViewsHeight
{
    [self.allDataCopy enumerateObjectsUsingBlock:^(HDSectionModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj setValue:@(idx) forKey:@"section"];
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
    HDSectionModel*secModel = pars[hd_secmodel_key];
    BOOL isAll = [pars[hd_is_all_key] boolValue];
    HDDataChangeType type = [pars[hd_data_finished_type_key] integerValue];
    
    void(^executeFinish)(void) = ^(void){
        //内部回调 通知某个setion计算完成
        if (innerFinishCallBack) {
            innerFinishCallBack();
        }
        //1、当需要的是只计算单个section的时候才调用该回调，用于通知外部完成计算 2、所有的setion计算完成回调在setAlldata完成之后
        if (!isAll) {
            [self hd_dataDealFinishCallback:type];
        }
    };
    if (!secModel.isNeedAutoCountCellHW && !secModel.isNeedCacheSubviewsFrame) {
        executeFinish();
        return;
    }
    
    NSArray *cellModelArr = secModel.sectionDataArr;
    
    //计算cell的高度/宽度
//    __block CGFloat cellWidth = secCellSize.width;
//    __block CGFloat cellFitH = 0;
    [cellModelArr enumerateObjectsUsingBlock:^(HDCellModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj setValue:[NSIndexPath indexPathForItem:idx inSection:secModel.section] forKey:@"indexP"];
        if (obj.cellSizeCb) {
            obj.cellSize = obj.cellSizeCb();
        }
        if (CGSizeEqualToSize(CGSizeZero, obj.cellSize)) {
            obj.cellSize = secModel.layout.cellSize;
        }

        if (![NSClassFromString(obj.cellClassStr) isSubclassOfClass:[UICollectionViewCell class]]) {
            obj.cellClassStr = secModel.sectionCellClassStr;
        }
        
        //这个cell只是用来帮助计算的，并不会显示到页面
        HDCollectionCell<HDUpdateUIProtocol>*tempCell = [[NSClassFromString(obj.cellClassStr) alloc] initWithFrame:CGRectMake(0, 0, obj.cellSize.width, obj.cellSize.height)];
        
        if ([tempCell respondsToSelector:@selector(superUpdateCellUI:callback:)]) {
            [tempCell superUpdateCellUI:obj callback:nil];
        }
        if ([tempCell respondsToSelector:@selector(updateCellUI:callback:)]) {
            [tempCell updateCellUI:obj callback:nil];
        }
        
        if (secModel.isNeedCacheSubviewsFrame) {
            if ([tempCell respondsToSelector:@selector(cacheSubviewsFrameBySetLayoutWithCellModel:)]) {
                [tempCell cacheSubviewsFrameBySetLayoutWithCellModel:obj];
            }
        }
        
        if (secModel.isNeedAutoCountCellHW) {
            BOOL isForceUseSizeThatFits = obj.isForceUseSizeThatFitH?YES:secModel.isForceUseHdSizeThatFits;
            if (isForceUseSizeThatFits) {
                CGSize fitSize = obj.cellSize;
                if ([tempCell respondsToSelector:@selector(hdSizeThatFits:)]) {
                    fitSize = [tempCell hdSizeThatFits:CGSizeMake(obj.cellSize.width, obj.cellSize.height)];
                }
                obj.cellSize = fitSize;
            }else{
                if ([tempCell respondsToSelector:@selector(superAutoLayoutDefaultSet:)]) {
                    [tempCell superAutoLayoutDefaultSet:obj];
                }
                CGSize fitSize = [tempCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
                obj.cellSize = fitSize;
            }
            tempCell.contentView.frame = CGRectMake(0, 0, obj.cellSize.width, obj.cellSize.height);
        }
        
        if (secModel.isNeedCacheSubviewsFrame) {
            [tempCell.contentView layoutIfNeeded];
            [obj setValue:[HDCellFrameCacheHelper copySubViewsFrame:tempCell] forKey:@"subviewsFrame"];
        }
    }];

    executeFinish();
}

- (void)hd_autoCountCellsHeight:(HDSectionModel*)secModel isAll:(BOOL)isAll type:(HDDataChangeType)type finishCallback:(void(^)(void))finishCb
{
    NSMutableDictionary *par = @{hd_secmodel_key:secModel,hd_is_all_key:@(isAll),hd_data_finished_type_key:@(type)}.mutableCopy;
    if (finishCb) {
        par[hd_inner_count_cellH_back_key] = finishCb;
    }
    if (isAll) {
        [self hd_realCountCellsH:par];
    }else{
        if (!_isCalculateCellHOnCommonModes) {
            HDDoSomeThingInMode(NSDefaultRunLoopMode, ^{
                [self hd_realCountCellsH:par];
            });
        }else{
            [self hd_realCountCellsH:par];
        }
    }
}

-(void)hd_dataChangeFinishedCallBack:(void (^)(HDDataChangeType))finishCallback
{
    dataDealFinishCallback = finishCallback;
}

- (void)hd_dataDealFinishCallback:(HDDataChangeType)type
{
    if (type == HDDataChangeSetAll) {
        [self hd_reloadDataAndAllLayout];
    }else{
        [self hd_reloadData];
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
- (void)hd_setCellUIUpdateCallback:(void (^)(__kindof UICollectionViewCell *, NSIndexPath *))setedCallback
{
    if (setedCallback) {
        setedCellCallback = setedCallback;
    }
}
- (void)hd_setSecViewUIUpdateCallback:(void (^)(__kindof UICollectionReusableView *, NSIndexPath *,NSString*))setedCallback
{
    if (setedCallback) {
        setedSecViewCallback = setedCallback;
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

}
@end

