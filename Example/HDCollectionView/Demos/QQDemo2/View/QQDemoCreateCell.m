//
//  QQDemoCreateCell.m
//  HDCollectionView_Example
//
//  Created by HaoDong chen on 2019/5/15.
//  Copyright © 2019 donggelaile. All rights reserved.
//

#import "QQDemoCreateCell.h"
#import "Masonry.h"
@interface QQDemoCreateCell()
@property (nonatomic, strong) UILabel *titleL;
@end

@implementation QQDemoCreateCell
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.titleL = [UILabel new];
        [self.contentView addSubview:self.titleL];
        
        UIView *line = [UIView new];
        line.backgroundColor = [UIColor colorWithRed:0.871 green:0.875 blue:0.878 alpha:1.000];
        [self.contentView addSubview:line];
        
        
        [self.titleL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(15);
            make.centerY.mas_equalTo(self.contentView);
        }];
        
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.mas_equalTo(0);
            make.height.mas_equalTo(0.5);
        }];
    }
    return self;
}

- (void)updateCellUI:(__kindof HDCellModel *)model
{
    self.titleL.text = model.orgData;
}
- (CGSize)hdSizeThatFits:(CGSize)size
{
    return CGSizeMake(size.width, 50);
}
@end
