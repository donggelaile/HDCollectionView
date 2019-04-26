//
//  DemoVC3Cell.m
//  HDCollectionView
//
//  Created by HaoDong chen on 2018/12/18.
//  Copyright © 2018 CHD. All rights reserved.
//

#import "DemoVC3Cell.h"
#import "DemoVC3CellModel.h"
//#import "UIView+gesture.h"
#import "Masonry.h"
#import <SDWebImage/UIImageView+WebCache.h>

BOOL isDemo3OpenSubviewFrameCache = YES;

@interface DemoVC3Cell()
@property (nonatomic, strong) UILabel *titleL;
@property (nonatomic, strong) UILabel *detailL;
@property (nonatomic, strong) UILabel *bottomLeft;
@property (nonatomic, strong) UILabel *bottomRight;
@property (nonatomic, strong) UIImageView *rightImageV;
@property (nonatomic, strong) UIView *bottomLine;
@end
@implementation DemoVC3Cell
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.titleL = [[UILabel alloc] initWithFrame:self.bounds];
        self.titleL.numberOfLines = 2;
        [self.contentView addSubview:self.titleL];
        
        self.detailL = [[UILabel alloc] initWithFrame:self.bounds];
        self.detailL.numberOfLines = 0;
        [self.contentView addSubview:self.detailL];
        
        self.rightImageV = [UIImageView new];
        self.rightImageV.hidden = YES;
//        self.rightImageV.contentMode = uicon
        [self.contentView addSubview:self.rightImageV];
        
        self.bottomLeft = [[UILabel alloc] initWithFrame:self.bounds];
        self.bottomLeft.numberOfLines = 1;
        [self.contentView addSubview:self.bottomLeft];
        
        self.bottomRight = [[UILabel alloc] initWithFrame:self.bounds];
        self.bottomRight.numberOfLines = 1;
        [self.contentView addSubview:self.bottomRight];
        
        self.bottomLine = [UIView new];
        self.bottomLine.backgroundColor = [UIColor lightGrayColor];
        [self.contentView addSubview:self.bottomLine];
    }
    __weak typeof(self) weakS = self;
//    self.backgroundColor = [UIColor colorWithRed:(arc4random()%255)/255.0 green:(arc4random()%255)/255.0 blue:(arc4random()%255)/255.0 alpha:1];
//    [self setTapActionWithBlock:^(UITapGestureRecognizer *tap) {
//        [weakS clickSelf];
//    }];

    self.backgroundColor = [UIColor whiteColor];

    return self;
}
- (void)setLayoutWithModel:(HDCellModel*)cellModel
{
    DemoVC3CellModel *cellM = cellModel.orgData;
    [self.titleL mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(10);
        //        make.bottom.mas_equalTo(-10);
    }];
    if (cellM.imageUrl) {
        [self.rightImageV mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self.titleL);
            make.width.mas_equalTo(100);
            make.height.mas_equalTo(self.rightImageV.mas_width).multipliedBy(0.7);
            make.top.mas_equalTo(self.titleL.mas_bottom).offset(5);

        }];
        
        [self.detailL mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.titleL);
            make.centerY.mas_equalTo(self.rightImageV);
            make.right.mas_equalTo(self.rightImageV.mas_left).offset(-5);
            make.height.mas_equalTo(self.rightImageV);
        }];
    }else{
        [self.detailL mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(self.titleL);
            make.top.mas_equalTo(self.titleL.mas_bottom).offset(10);
        }];
    }
    [self.bottomLeft setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    [self.bottomLeft mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.detailL.mas_bottom).offset(15);
        make.left.mas_equalTo(self.titleL);
        make.bottom.mas_equalTo(-10);
    }];
    
    [self.bottomRight mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.titleL);
        make.centerY.mas_equalTo(self.bottomLeft);
        make.left.mas_greaterThanOrEqualTo(self.bottomLeft.mas_right).offset(5);
        make.width.mas_greaterThanOrEqualTo(70);
        make.height.mas_equalTo(self.bottomLeft);
    }];
    
    [self.bottomLine mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(-1);
        make.height.mas_equalTo(0.5);
    }];
}
- (void)cacheSubviewsFrameBySetLayoutWithCellModel:(HDCellModel *)cellModel
{
    [self setLayoutWithModel:cellModel];
}
-(void)updateCellUI:(HDCellModel *)model callback:(void (^)(id, HDCallBackType))callback
{
    if (!isDemo3OpenSubviewFrameCache) {
        [self setLayoutWithModel:model];
    }
    
    DemoVC3CellModel *cellM = model.orgData;
    self.titleL.attributedText = cellM.title;
    self.detailL.attributedText = cellM.detail;
    self.bottomLeft.attributedText = cellM.leftText;
    self.bottomRight.attributedText = cellM.rightText;
    self.rightImageV.hidden = !cellM.imageUrl;
    if (cellM.imageUrl) {
        [self.rightImageV sd_setImageWithURL:[NSURL URLWithString:cellM.imageUrl]];
    }
    
}
- (void)clickSelf
{
    self.callback(self.hdModel, HDCellCallBack);
}
//- (CGSize)sizeThatFits:(CGSize)size
//{
//    CGSize newsize = [self.titleL sizeThatFits:size];
//    newsize = CGSizeMake(size.width, newsize.height+20);
//    return newsize;
//}
- (void)dealloc
{
    
}
@end
