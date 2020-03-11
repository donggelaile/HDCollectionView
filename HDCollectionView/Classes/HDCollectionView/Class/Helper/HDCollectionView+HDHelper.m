//
//  HDCollectionView+HDHelper.m
//
//  Created by chd on 2019/9/24.
//  Copyright © 2019 chd. All rights reserved.
//

#import "HDCollectionView+HDHelper.h"
#import <objc/runtime.h>
static char *HDSlowlyDataArrKey;
static char *HDCurrentLoadSecKey;
static char *HDPreloadOffsetKey;
static char *HDCalculateSectionFinishCbKey;

@interface HDCollectionView()
@property (nonatomic, strong) NSMutableArray *slowlyDataArr;
@property (nonatomic, assign) NSInteger currentLoadSec;
@property (nonatomic, assign) NSInteger preloadOffset;
@property (nonatomic, copy) void(^CalculateSectionFinishCb)(NSInteger section);
@end

@implementation HDCollectionView (Helper)

- (void)setCalculateSectionFinishCb:(void (^)(NSInteger))CalculateSectionFinishCb
{
    objc_setAssociatedObject(self, &HDCalculateSectionFinishCbKey, CalculateSectionFinishCb, OBJC_ASSOCIATION_COPY_NONATOMIC);
}
-(void (^)(NSInteger))CalculateSectionFinishCb
{
    void (^callback)(NSInteger) = objc_getAssociatedObject(self, &HDCalculateSectionFinishCbKey);
    return callback;
}
- (void)setCurrentLoadSec:(NSInteger)currentLoadSec
{
    objc_setAssociatedObject(self, &HDCurrentLoadSecKey, @(currentLoadSec), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (NSInteger)currentLoadSec
{
    return [objc_getAssociatedObject(self, &HDCurrentLoadSecKey) integerValue];
}
- (void)setPreloadOffset:(NSInteger)preloadOffset
{
    objc_setAssociatedObject(self, &HDPreloadOffsetKey, @(preloadOffset), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (NSInteger)preloadOffset
{
    NSNumber *num = objc_getAssociatedObject(self, &HDPreloadOffsetKey);
    return [num integerValue];
}
- (void)setSlowlyDataArr:(NSMutableArray *)slowlyDataArr
{
    objc_setAssociatedObject(self, &HDSlowlyDataArrKey, slowlyDataArr, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (NSMutableArray *)slowlyDataArr
{
    return objc_getAssociatedObject(self, &HDSlowlyDataArrKey);
}


- (void)hd_setAllDataArrSlowly:(NSArray<id<HDSectionModelProtocol>> *)dataArr preloadOffset:(NSInteger)preloadOffset currentCalculateSectionFinishCallback:(nullable void (^)(NSInteger))callback
{
    [self hd_setAllDataArr:@[]];
    self.slowlyDataArr = dataArr.mutableCopy;
    self.currentLoadSec = 0;
    self.preloadOffset = preloadOffset;
    self.collectionV.contentOffset = CGPointZero;
    
    self.CalculateSectionFinishCb = callback;
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(hd_scrollViewDidScroll:) name:HDCVScrollViewDidScrollNotificationName object:nil];
    [self loadSectionIfNeeded:callback];
    
    __weak typeof(self) weakSelf = self;
    [self hd_dataChangeFinishedCallBack:^(HDDataChangeType changeType) {
        if (changeType == HDDataChangeDeleteSec || changeType == HDDataChangeChangeSec) {
            [weakSelf loadSectionIfNeeded:callback];
        }
    }];
}
- (void)hd_scrollViewDidScroll:(NSNotification*)noti
{
    HDCollectionView *hdcv;
    if ([noti.object isKindOfClass:[HDCollectionView class]]) {
        hdcv = noti.object;
    }
    [self hd_scrollViewDidScroll:hdcv.collectionV callback:self.CalculateSectionFinishCb];
}
- (void)hd_scrollViewDidScroll:(UIScrollView *)scrollView callback:(nonnull void (^)(NSInteger))callback
{
    NSRunLoopMode mode = NSDefaultRunLoopMode;
    if (self.scrollDirection == UICollectionViewScrollDirectionVertical) {
        NSInteger offset = 0;
        BOOL isSrollToBtttom = (self.collectionV.contentOffset.y >= self.collectionV.contentSize.height + self.collectionV.contentInset.bottom - offset - self.collectionV.frame.size.height);
        if (isSrollToBtttom) {
            mode = NSRunLoopCommonModes;//滑动到边缘位置的时候必须加载了，因此放到commonMode
        }
    }else{
        NSInteger offset = 0;
        BOOL isSrollToRight = (self.collectionV.contentOffset.x >= self.collectionV.contentSize.width + self.collectionV.contentInset.right - offset - self.collectionV.frame.size.width);
        if (isSrollToRight) {
            mode = NSRunLoopCommonModes;
        }
    }
    
    HDDoSomeThingInMode(mode, ^{
        [self loadSectionIfNeeded:callback];
    });
}

+ (NSArray<HDSectionModel*> *)hd_getSectionsByPageCount:(NSInteger)pageCount hdCellModelArr:(nonnull NSArray<id<HDCellModelProtocol>> *)cellModelArr secConfiger:(nonnull id<HDSectionModelProtocol>  _Nonnull (^)(NSInteger))secConfig
{
    NSMutableArray *finalSecArr = @[].mutableCopy;
    NSMutableArray *tempCellVMArr = @[].mutableCopy;
    NSMutableArray *subArr = @[].mutableCopy;
    
    for (int i=0; i<cellModelArr.count; i++) {
        id<HDCellModelProtocol>  _Nonnull obj = cellModelArr[i];
        if (subArr.count<pageCount) {
            [subArr addObject:obj];
            if (i == cellModelArr.count-1) {
                [tempCellVMArr addObject:subArr];
            }
        }else{
            [tempCellVMArr addObject:subArr];
            subArr = @[].mutableCopy;
            i--;
        }
    }
    [tempCellVMArr enumerateObjectsUsingBlock:^(NSMutableArray* obj, NSUInteger idx, BOOL * _Nonnull stop) {
        id<HDSectionModelProtocol> secModel = nil;
        if (secConfig) {
            secModel = secConfig(idx);
        }else{
#ifdef DEBUG
            NSLog(@"分段时必须实现此block，返回对应的sectionModel");
#endif
        }
        if (secModel) {
            [(NSObject*)secModel setValue:@(idx) forKey:@"section"];
            secModel.sectionDataArr = obj;
            [finalSecArr addObject:secModel];
        }
    }];
    return finalSecArr;
}

- (void)loadSectionIfNeeded:(nonnull void (^)(NSInteger))callback
{
    if ([self isNeedLoadMore]) {
        [self addOneSecWithCallback:callback];
    }
}
- (BOOL)isNeedLoadMore
{
    BOOL isNeed = NO;
    NSInteger curSlowLoadSecIndex = self.currentLoadSec;
    id<HDSectionModelProtocol> lastSecModel = [self.innerAllData lastObject];
    id<HDSectionModelProtocol> curSlowLoadSec = [self secModelWithSection:curSlowLoadSecIndex];
    if (!curSlowLoadSec) {
        return isNeed;
    }
    CGFloat offset = self.preloadOffset;
    UIScrollView *scrollView = self.collectionV;
    if (self.scrollDirection == UICollectionViewScrollDirectionVertical) {
        if (scrollView.contentOffset.y+scrollView.frame.size.height>CGRectGetMaxY(lastSecModel.secProperRect.CGRectValue)-offset) {
            isNeed = YES;
        }
    }else{
        if (scrollView.contentOffset.x+scrollView.frame.size.width>CGRectGetMaxX(lastSecModel.secProperRect.CGRectValue)-offset) {
            isNeed = YES;
        }
    }
    return isNeed;
}
- (void)addOneSecWithCallback:(nonnull void (^)(NSInteger))callback
{
    if (self.isDeletingSection) {
        return;
    }
    NSInteger curSecIndex = self.currentLoadSec;
    [self hd_appendDataWithSecModel:[self secModelWithSection:curSecIndex] animated:NO];
    if (callback) {
        callback(self.currentLoadSec);
    }
    self.currentLoadSec ++;
    
    //判断是否当前段仍然无法填满当前可视区域
    [self loadSectionIfNeeded:callback];
}
- (HDSectionModel*)secModelWithSection:(NSInteger)section
{
    HDSectionModel *curSec = nil;
    if (section<self.slowlyDataArr.count) {
        curSec = self.slowlyDataArr[section];
    }
    return curSec;
}
- (void)hd_appendSecSlowly:(id<HDSectionModelProtocol>)secModel
{
    if (self.slowlyDataArr.count && [secModel conformsToProtocol:@protocol(HDSectionModelProtocol)]) {
        [self.slowlyDataArr addObject:secModel];
    }
}
@end
