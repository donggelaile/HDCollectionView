//
//  DemoVC2Cell.m
//  HDCollectionView
//
//  Created by HaoDong chen on 2018/12/18.
//  Copyright © 2018 CHD. All rights reserved.
//

#import "AHCTopHeader.h"
#import "HDSectionView.h"
#import "AHCModel.h"
#import "UIView+MJExtension.h"
#import "AHCBaseCollectionView.h"
#import "HDSCVOffsetBinder.h"
//顶部header
@interface AHCTopLeftHeader: HDSectionView
@property (nonatomic, strong) UIButton *showOrHideSame;
@end

@implementation AHCTopLeftHeader
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.showOrHideSame = [[UIButton alloc] initWithFrame:self.bounds];
        self.showOrHideSame.titleLabel.font = [UIFont systemFontOfSize:13];
        [self.showOrHideSame setTitleColor:[UIColor colorWithRed:0.255 green:0.514 blue:1.000 alpha:1.000] forState:UIControlStateNormal];

        [self addSubview:self.showOrHideSame];
        
        self.backgroundColor = [UIColor whiteColor];
        self.layer.borderWidth = 1/[UIScreen mainScreen].scale;
        self.layer.borderColor = [UIColor lightGrayColor].CGColor;
        
        
        [self.showOrHideSame addTarget:self action:@selector(showOrHideSameLine) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}
- (void)showOrHideSameLine
{
    self.hdSecModel.context = NSStringFromSelector(_cmd);
    self.callback(self.hdSecModel);
    self.hdSecModel.context = nil;
}
- (void)updateSecVUI:(__kindof id<HDSectionModelProtocol>)model
{
    if (![model.headerObj boolValue]) {
        [self.showOrHideSame setTitle:@"显示相同项" forState:UIControlStateNormal];
    }else{
        [self.showOrHideSame setTitle:@"隐藏相同项" forState:UIControlStateNormal];
    }
}
@end

//顶部的内部cell
@interface AHCTopInnerCell: HDCollectionCell
@property (nonatomic, strong) UILabel *titleL;
@property (nonatomic, strong) UILabel *priceL;
@property (nonatomic, strong) UIButton *delteBtn;
@end

@implementation AHCTopInnerCell
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.titleL = [[UILabel alloc] initWithFrame:self.bounds];
        self.titleL.mj_x = 5;
        self.titleL.numberOfLines = 0;
        self.titleL.font = [UIFont systemFontOfSize:13];
        [self.contentView addSubview:self.titleL];
        
        self.priceL = [UILabel new];
        self.priceL.mj_x = self.titleL.mj_x;
        self.priceL.font = [UIFont systemFontOfSize:12];
        self.priceL.textColor = [UIColor redColor];
        [self.contentView addSubview:self.priceL];
        
        self.delteBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.mj_w-20, 0, 20, 20)];
        [self.delteBtn setImage:[UIImage imageNamed:@"AHCTopHederDelete"] forState:UIControlStateNormal];
        [self.delteBtn addTarget:self action:@selector(delteBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:self.delteBtn];
    }
    return self;
}
- (void)updateCellUI:(__kindof id<HDCellModelProtocol>)model
{
    AHCSpecitems *item = model.orgData;
    self.titleL.text = [NSString stringWithFormat:@"%@ %@",item.seriesname,item.specname];
    self.titleL.mj_w = self.mj_w - 5;
    [self.titleL sizeToFit];
    self.titleL.mj_y = (self.mj_h - self.titleL.mj_h)/2;
    
    self.priceL.text = item.minprice;
    [self.priceL sizeToFit];
    self.priceL.mj_y = self.mj_h - self.priceL.mj_h - 5;
}
- (void)delteBtnClick
{
    self.hdModel.context = NSStringFromSelector(_cmd);
    self.callback(self.hdModel);
    self.hdModel.context = nil;
}
@end

@interface AHCTopDecorationView : HDSectionView
@property (nonatomic, strong) UIView *lineBg;
@end

@implementation AHCTopDecorationView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}
- (void)updateSecVUI:(__kindof id<HDSectionModelProtocol>)model
{
    [self.lineBg removeFromSuperview];
    CGFloat offsetX = 5;
    self.lineBg = [[UIView alloc] initWithFrame:self.bounds];
    self.lineBg.mj_x -= offsetX;
    self.lineBg.mj_w += offsetX;
    self.lineBg.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.lineBg.layer.borderWidth = 1/[UIScreen mainScreen].scale;
    __block CGFloat cx = 0;
    [model.sectionDataArr enumerateObjectsUsingBlock:^(HDCellModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        cx += obj.cellSize.width;
        if (idx<model.sectionDataArr.count-1) {
            UIView *line = [[UIView alloc] initWithFrame:CGRectMake(cx+offsetX, 0, 1/[UIScreen mainScreen].scale, obj.cellSize.height)];
            line.backgroundColor = [UIColor lightGrayColor];
            [self.lineBg addSubview:line];
        }
    }];
    [self addSubview:self.lineBg];
}
@end

//顶部的HDCollecitonView
@interface AHCTopHeader()
@property (nonatomic, strong) HDCollectionView *collectionV;
@end

@implementation AHCTopHeader
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.collectionV = [AHCBaseCollectionView hd_makeHDCollectionView:^(HDCollectionViewMaker *maker) {
            maker
            .hd_frame(self.bounds)
            .hd_scrollDirection(UICollectionViewScrollDirectionHorizontal)
            .hd_isNeedTopStop(YES);
        }];
        self.collectionV.collectionV.bounces = NO;
        self.collectionV.collectionV.showsHorizontalScrollIndicator = NO;
        [[HDSCVOffsetBinder shareInstance]bindScrollView:self.collectionV.collectionV groupID:AHC_Hor_Colletionview];
        [self addSubview:self.collectionV];
        
        __weak typeof(self) weakS = self;
        [self.collectionV hd_setAllEventCallBack:^(id backModel, HDCallBackType type) {
            [weakS headerCallBack:backModel type:type];
        }];
    }
    return self;
}
- (void)headerCallBack:(HDSectionModel*)cellModel type:(HDCallBackType)type
{
    self.callback(cellModel);
}
- (void)updateSecVUI:(__kindof id<HDSectionModelProtocol>)model
{
    [self.collectionV hd_setAllDataArr:model.headerObj];
    CGPoint point =  [[[HDSCVOffsetBinder shareInstance] getCurrentOffsetByGroupID:AHC_Hor_Colletionview] CGPointValue];
    [self.collectionV.collectionV setContentOffset:point needKVONotify:NO];
}
@end
