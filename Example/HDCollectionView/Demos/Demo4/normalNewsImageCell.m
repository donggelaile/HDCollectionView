//
//  normalNewsImageCell.m
//  HDCollectionView
//
//  Created by HaoDong chen on 2018/12/19.
//  Copyright © 2018 CHD. All rights reserved.
//

#import "normalNewsImageCell.h"
#import "SDAutoLayout.h"
#import "Masonry.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "newsRootModel.h"

@interface normalNewsImageCell()
@property (nonatomic, strong) UILabel *newsTitle;
@property (nonatomic, strong) UILabel *newsBottom;
@property (nonatomic, strong) UIView *line;
@property (nonatomic, strong) UIImageView *newsImageV;
@end
@implementation normalNewsImageCell
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
        
        self.newsImageV = [UIImageView new];
        [self.contentView addSubview:self.newsImageV];
        
        self.line = [UIView new];
        self.line.backgroundColor = [UIColor lightGrayColor];
        [self.contentView addSubview:self.line];
        
    }
    self.contentView.frame = self.bounds;
    
    [self makeMasnoryLayout];
    
    
    return self;
}

- (void)makeMasnoryLayout
{
//    self.newsImageV mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left
//    }
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





- (void)updateCellUI:(HDCellModel *)model callback:(void (^)(id, HDCallBackType))callback
{
    Tid *tidM = model.orgData;
    self.newsTitle.attributedText = tidM.showTitle;
    self.newsBottom.attributedText = tidM.showBottom;
}
@end
