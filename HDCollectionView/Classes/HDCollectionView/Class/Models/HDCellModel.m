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
@synthesize secModel = _secModel;
@synthesize subviewsFrame = _subviewsFrame;
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
- (CGSize)calculateCellProperSize:(BOOL)isNeedCacheSubviewsFrame
{
    //这个cell只是用来帮助计算的，并不会显示到页面
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
    
    BOOL isUsehdSizeThatFits = [tempCell respondsToSelector:@selector(hdSizeThatFits:)];
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
        if ([tempCell respondsToSelector:@selector(cacheSubviewsFrameBySetLayoutWithCellModel:)]) {
            [tempCell.contentView layoutIfNeeded];
            _subviewsFrame = [HDCellFrameCacheHelper copySubViewsFrame:tempCell];
        }
    }
    return self.cellSize;
}
@end



