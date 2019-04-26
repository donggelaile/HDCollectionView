//
//  NormalNewsCell.m
//  HDCollectionView
//
//  Created by HaoDong chen on 2018/12/18.
//  Copyright © 2018 CHD. All rights reserved.
//

#import "NormalNewsCell.h"
#import "SDAutoLayout.h"
#import "Masonry.h"
#import "newsRootModel.h"

//测试时只开启一个
#define HDMasnoryLayout
//#define HDSDLayout

@interface NormalNewsCell()
@property (nonatomic, strong) UILabel *newsTitle;
@property (nonatomic, strong) UILabel *newsBottom;
@property (nonatomic, strong) UIView *line;
//@property (nonatomic, strong) UILabel *newsSource;
@end
@implementation NormalNewsCell
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.newsTitle = [UILabel new];
        self.newsTitle.numberOfLines = 2; //masnory 行数
        [self.contentView addSubview:self.newsTitle];
        
        self.newsBottom = [UILabel new];
        self.newsBottom.isAttributedContent = YES;
        [self.contentView addSubview:self.newsBottom];
        
        self.line = [UIView new];
        self.line.backgroundColor = [UIColor lightGrayColor];
        [self.contentView addSubview:self.line];
        
    }

    
#ifdef HDSDLayout
    [self makeSDLayout];
    [self.newsTitle setMaxNumberOfLinesToShow:2];
    self.newsTitle.isAttributedContent = YES;//SD_Layout 需要此设置才能正确计算高度
#endif

#ifdef HDMasnoryLayout
//    [self makeMasnoryLayout];
    
#endif
    
    return self;
}

#ifdef HDSDLayout
- (void)makeSDLayout
{
    self.newsTitle.sd_layout.leftSpaceToView(self.contentView, 10).topSpaceToView(self.contentView, 15).rightSpaceToView(self.contentView, 10).autoHeightRatio(0);
    self.newsBottom.sd_layout.topSpaceToView(self.newsTitle, 10).rightEqualToView(self.newsTitle).leftEqualToView(self.newsTitle).autoHeightRatio(0);
    self.line.sd_layout.leftSpaceToView(self.contentView, 0).rightSpaceToView(self.contentView, 0).heightIs(0.5).bottomSpaceToView(self.contentView, 0);

    
    //如果没有设置底部距离 需要实现 sizeThatFits
    
}
- (CGSize)sizeThatFits:(CGSize)size
{
    [self.contentView layoutSubviews];
    return CGSizeMake(size.width, CGRectGetMaxY(self.newsBottom.frame)+10);
}
#endif
- (void)cacheSubviewsFrameBySetLayoutWithCellModel:(HDCellModel *)cellModel
{
    [self makeMasnoryLayout];
//    [self makeSDLayout];
//    [self updateLayout];
}
#ifdef HDMasnoryLayout
- (void)makeMasnoryLayout
{
    [self.newsTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.mas_equalTo(10);
        make.right.mas_equalTo(-10);
    }];
    [self.newsBottom mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.newsTitle);
        make.bottom.mas_equalTo(-10);
        make.top.mas_equalTo(self.newsTitle.mas_bottom).offset(10);
    }];
    [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0);
        make.height.mas_equalTo(0.5);
    }];
}
#endif




- (void)updateCellUI:(HDCellModel *)model callback:(void (^)(id, HDCallBackType))callback
{
    Tid *tidM = model.orgData;
//    self.newsTitle.attributedText = tidM.showTitle;
//    self.newsBottom.attributedText = tidM.showBottom;
}
@end
