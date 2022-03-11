//
//  HDCollectionCell.m
//  
//
//  Created by CHD on 2018/8/9.
//  Copyright © 2018年 chd. All rights reserved.
//

#import "HDCollectionCell.h"
#import <objc/runtime.h>
#import "HDCellFrameCacheHelper.h"
#import "HDCollectionView.h"

@interface HDCollectionCell()
@property (nonatomic, copy) void(^superCallback)(id par, HDCallBackType type);
@end

@implementation HDCollectionCell
{
    void(^dataSetFinishCb)(void);
}
@synthesize superCollectionV = _superCollectionV;

- (HDCollectionView *)superCollectionV
{
    if (!_superCollectionV) {
        UIView *view = self;
        while (view!=nil && ![view isKindOfClass:HDClassFromString(@"HDCollectionView")]) {
            view = view.superview;
        }
        _superCollectionV = (HDCollectionView*)view;
    }
    return _superCollectionV;
}

- (void)superUpdateCellUI:(id<HDCellModelProtocol>)model callback:(void (^)(id, HDCallBackType))callback
{
    self.superCallback = callback;
    __weak typeof(self)weakS = self;
    void(^subClassCallback)(id) = ^(id par) {
        if (weakS && weakS.superCallback) {
            weakS.superCallback(par, HDCellCallBack);
        }
    };
    [self setValue:subClassCallback forKey:@"callback"];
    [self setValue:model forKey:@"hdModel"];
    //只转换一次
    if ([model respondsToSelector:@selector(convertOrgModelToViewModel)] && !model.isConvertedToVM) {
        [model convertOrgModelToViewModel];
    }
    UIAlertView *view;
    model.isConvertedToVM = YES;
    if (dataSetFinishCb) {
        dataSetFinishCb();
    }
}

- (void)hd_superDataSetFinishCallback:(void (^)(void))dataSetFinish
{
    if (dataSetFinish) {
        dataSetFinishCb = dataSetFinish;
    }
}

- (void)superAutoLayoutDefaultSet:(id<HDCellModelProtocol>)cellModel
{
    //设置宽度约束，自适应高度时设定父view宽度 才能准确使用autolayout计算需要的高度，尤其iOS8及以下
    //这里只计算高度，如果想完全控制cell宽高或者定高算宽 可以在子类cell的 - (CGSize)hdSizeThatFits:(CGSize)size中返回响应的size
    CGFloat fitWidth = cellModel.cellSize.width;
    if (fitWidth == 0) {
        fitWidth = self.frame.size.width;
    }
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.contentView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:fitWidth]];
}
- (void)applyLayoutAttributes:(UICollectionViewLayoutAttributes *)layoutAttributes
{
    [super applyLayoutAttributes:layoutAttributes];
    if ([self.superCollectionV.collectionV.collectionViewLayout isKindOfClass:HDClassFromString(@"HDCollectionViewLayout")]) {
        //对于系统的UICollectionViewFlowLayout 设置后反而会引起视图层级混乱，原因未知
        self.layer.zPosition = layoutAttributes.zIndex;
    }
}

- (void)dealEventByEventKey:(NSString*)eventKey backType:(HDCallBackType)type backModel:(id)backModel self:(void(^)(void))selfDealCode
{
    HDCollectionViewEventDealPolicy policy = HDCollectionViewEventDealPolicyBySubView;
    
    //获取HDCollectionView对该事件设置的处理策略
    if ([eventKey isKindOfClass:[NSString class]] && self.superCollectionV.allSubViewEventDealPolicy[eventKey]) {
        policy = [self.superCollectionV.allSubViewEventDealPolicy[eventKey] integerValue];
        if (policy>HDCollectionViewEventDealPolicyBeforeSubView || policy < 0) {
            policy = HDCollectionViewEventDealPolicyBySubView;
        }
    }
    if (!selfDealCode) {
        policy = HDCollectionViewEventDealPolicyInstead;
    }
    if (policy == HDCollectionViewEventDealPolicyBySubView) {
        if (selfDealCode) {
            selfDealCode();
        }
    }else if (policy == HDCollectionViewEventDealPolicyInstead){
        self.callback(backModel);
    }else if (policy == HDCollectionViewEventDealPolicyAfterSubView){
        if (selfDealCode) {
            selfDealCode();
        }
        self.callback(backModel);
    }else if (policy == HDCollectionViewEventDealPolicyBeforeSubView){
        self.callback(backModel);
        if (selfDealCode) {
            selfDealCode();
        }
    }
    self.hdModel.context = nil;
    self.hdModel.otherParameter = nil;
}
+(BOOL)accessInstanceVariablesDirectly{
    return YES;
}
@end


