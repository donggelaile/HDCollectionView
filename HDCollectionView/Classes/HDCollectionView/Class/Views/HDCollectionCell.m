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

@implementation HDCollectionCell

- (void)hd_ReloadCollectionView
{
    [self.superCollectionV hd_reloadData];
}
- (HDCollectionView *)superCollectionV
{
    if (!_superCollectionV) {
        UIView *view = self;
        while (view!=nil && ![view isKindOfClass:NSClassFromString(@"HDCollectionView")]) {
            view = view.superview;
        }
        _superCollectionV = (HDCollectionView*)view;
    }
    return _superCollectionV;
}


- (void)superUpdateCellUI:(HDCellModel *)model callback:(void (^)(id, HDCallBackType))callback
{
    self.callback = callback;
    self.hdModel = model;
}
- (void)superAutoLayoutDefaultSet:(HDCellModel *)cellModel
{
    //设置宽度约束，自适应高度时设定父view宽度 才能准备计算需要的高度，尤其iOS8及以下
    self.contentView.translatesAutoresizingMaskIntoConstraints = NO;
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.contentView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeTop multiplier:1.0 constant:0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.contentView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.contentView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.contentView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:cellModel.cellSize.width]];
}
- (void)applyLayoutAttributes:(UICollectionViewLayoutAttributes *)layoutAttributes
{
    [super applyLayoutAttributes:layoutAttributes];
    self.layer.zPosition = layoutAttributes.zIndex;
}
@end


