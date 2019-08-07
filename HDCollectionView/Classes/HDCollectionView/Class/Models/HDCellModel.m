//
//  HDCellModel.m
//  
//
//  Created by CHD on 2018/8/9.
//  Copyright © 2018年 chd. All rights reserved.
//

#import "HDCellModel.h"
#import "HDCollectionCell.h"
#import "HDCellFrameCacheHelper.h"

@implementation HDCellModel

@synthesize secModel        = _secModel;
@synthesize subviewsFrame   = _subviewsFrame;
@synthesize alignSelf       = _alignSelf;
@synthesize cellClassStr    = _cellClassStr;
@synthesize cellFrameXY     = _cellFrameXY;
@synthesize cellSize        = _cellSize;
@synthesize cellSizeCb      = _cellSizeCb;
@synthesize context         = _context;
@synthesize indexP          = _indexP;
@synthesize isConvertedToVM = _isConvertedToVM;
@synthesize margain         = _margain;
@synthesize orgData         = _orgData;
@synthesize reuseIdentifier = _reuseIdentifier;
@synthesize otherParameter  = _otherParameter;
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.cellSize = CGSizeZero;
        self.margain = UIEdgeInsetsZero;
    }
    return self;
}
- (NSString *)reuseIdentifier
{
    if (!_reuseIdentifier) {
        _reuseIdentifier = self.cellClassStr;
    }
    return _reuseIdentifier;
}
- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    
}
- (id)valueForUndefinedKey:(NSString *)key
{
    return nil;
}
- (CGSize)calculateCellProperSize:(BOOL)isNeedCacheSubviewsFrame forceUseAutoLayout:(BOOL)isForceUseAutoLayout
{
    HDCollectionCell<HDUpdateUIProtocol>*tempCell = [[NSClassFromString(self.cellClassStr) alloc] initWithFrame:CGRectMake(0, 0, self.cellSize.width, self.cellSize.height)];
    
    isNeedCacheSubviewsFrame = isNeedCacheSubviewsFrame && [tempCell respondsToSelector:@selector(cacheSubviewsFrameBySetLayoutWithCellModel:)];
    
    if (isNeedCacheSubviewsFrame) {
        [tempCell setCacheKeysIfNeed];
    }
    if ([tempCell respondsToSelector:@selector(superUpdateCellUI:callback:)]) {
        [tempCell superUpdateCellUI:self callback:nil];
    }
    if ([tempCell respondsToSelector:@selector(updateCellUI:)]) {
        [tempCell updateCellUI:self];
    }
    
    if (isNeedCacheSubviewsFrame) {
        if ([tempCell respondsToSelector:@selector(cacheSubviewsFrameBySetLayoutWithCellModel:)]) {
            [tempCell cacheSubviewsFrameBySetLayoutWithCellModel:self];
        }
    }
    
    BOOL isUsehdSizeThatFits = [tempCell respondsToSelector:@selector(hdSizeThatFits:)] && !isForceUseAutoLayout;
    if (isUsehdSizeThatFits) {
        CGSize fitSize = self.cellSize;
        if ([tempCell respondsToSelector:@selector(hdSizeThatFits:)]) {
            fitSize = [tempCell hdSizeThatFits:CGSizeMake(self.cellSize.width, self.cellSize.height)];
        }
        if (fitSize.height>0 && fitSize.width>0) {
            self.cellSize = fitSize;
        }
    }else{
        if ([tempCell respondsToSelector:@selector(superAutoLayoutDefaultSet:)]) {
            [tempCell superAutoLayoutDefaultSet:self];
        }
        CGSize fitSize = [tempCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
        if (fitSize.height>0 && fitSize.width>0) {
            self.cellSize = fitSize;
        }
    }
    tempCell.contentView.frame = CGRectMake(0, 0, self.cellSize.width, self.cellSize.height);
    
    if (isNeedCacheSubviewsFrame) {
        NSLayoutConstraint *heightCons = [NSLayoutConstraint constraintWithItem:tempCell.contentView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:self.cellSize.height];
        heightCons.priority = UILayoutPriorityDefaultLow;
        [NSLayoutConstraint activateConstraints:@[heightCons]];
        if ([tempCell respondsToSelector:@selector(cacheSubviewsFrameBySetLayoutWithCellModel:)]) {
            [tempCell.contentView layoutIfNeeded];
            _subviewsFrame = [HDCellFrameCacheHelper copySubViewsFrame:tempCell];
        }
    }
    return self.cellSize;
}

@end



