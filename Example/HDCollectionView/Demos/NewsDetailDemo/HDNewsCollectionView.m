//
//  HDNewsCollectionView.m
//  HDCollectionView_Example
//
//  Created by HaoDong chen on 2019/5/29.
//  Copyright © 2019 donggelaile. All rights reserved.
//

#import "HDNewsCollectionView.h"
@interface HDNewsCollectionViewCell:HDCollectionCell
@property (nonatomic, strong) UILabel *titleL;
@end

@implementation HDNewsCollectionViewCell
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.titleL = [UILabel new];
        self.titleL.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:self.titleL];
    }
    return self;
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    self.titleL.frame = self.bounds;
}
- (void)updateCellUI:(__kindof HDCellModel *)model
{
    self.contentView.backgroundColor = [UIColor colorWithRed:(arc4random()%255)/255.0 green:(arc4random()%255)/255.0 blue:(arc4random()%255)/255.0 alpha:1];
    self.titleL.text = [NSString stringWithFormat:@"原生--%@",@(model.indexP.item)];
}
@end

@implementation HDNewsCollectionView
- (nonnull UIScrollView *)hd_ScrollJoinViewRealScroll {
    return self.collectionV;
}
@end
