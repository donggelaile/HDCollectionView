//
//  QQDemoSearchCell.m
//  HDCollectionView_Example
//
//  Created by HaoDong chen on 2019/5/15.
//  Copyright © 2019 donggelaile. All rights reserved.
//

#import "QQDemoSearchCell.h"
#import "Masonry.h"
@interface QQDemoSearchCell()
@property (nonatomic, strong) UIView *searchBg;
@property (nonatomic, strong) UILabel *searchL;
@end

@implementation QQDemoSearchCell
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.contentView.backgroundColor = [UIColor whiteColor];
        
        self.searchBg = [UIView new];
        self.searchBg.backgroundColor = [UIColor colorWithRed:0.933 green:0.937 blue:0.953 alpha:1.000];
        self.searchBg.layer.cornerRadius = 2;
        [self.contentView addSubview:self.searchBg];
        
        self.searchL = [UILabel new];
        self.searchL.text = @"搜索";
        self.searchL.textColor = [UIColor colorWithRed:0.651 green:0.651 blue:0.651 alpha:1.000];
        self.searchL.font = [UIFont systemFontOfSize:15];
        [self.searchBg addSubview:self.searchL];
    
    }
    
    UIView *line = [UIView new];
    line.backgroundColor = [UIColor colorWithRed:0.871 green:0.875 blue:0.878 alpha:1.000];
    [self.contentView addSubview:line];
    
    
    [self.searchBg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(10, 10, 10, 10));
    }];
    [self.searchL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.centerY.mas_equalTo(self.searchBg);
    }];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0);
        make.height.mas_equalTo(0.5);
    }];
    
    return self;
}
- (CGSize)hdSizeThatFits:(CGSize)size
{
    return CGSizeMake(size.width, 45);
}
@end
