//
//  DemoVC2Cell.m
//  HDCollectionView
//
//  Created by HaoDong chen on 2018/12/18.
//  Copyright © 2018 CHD. All rights reserved.
//

#import "AHCNormalCell.h"
#import "AHCModel.h"
#import "HDSCVOffsetBinder.h"
#import "AHCBaseCollectionView.h"
#import "UIView+AroundLine.h"

//#import "UIView+gesture.h"

@interface AHCNormalCellHeader:HDSectionView
@property (nonatomic, strong) UILabel *titleL;
@end

@implementation AHCNormalCellHeader
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.titleL = [[UILabel alloc] initWithFrame:self.bounds];
        self.titleL.numberOfLines = 0;
        self.titleL.font = [UIFont systemFontOfSize:12.0f];
        self.titleL.textAlignment = NSTextAlignmentCenter;
        [self addSubview:self.titleL];
        [self addAroundLine:UIEdgeInsetsMake(0, 1, 1, 1) color:[UIColor lightGrayColor]];
        self.backgroundColor = [UIColor colorWithRed:0.941 green:0.941 blue:0.941 alpha:1.000];
    }
    
    return self;
}
- (void)updateSecVUI:(__kindof HDSectionModel *)model
{
    self.titleL.text = model.headerObj;
}
@end

@interface AHCNormalCellInnerCell: HDCollectionCell
@property (nonatomic, strong) UILabel *titleL;
@end

@implementation AHCNormalCellInnerCell
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.titleL = [[UILabel alloc]initWithFrame:self.bounds];
        self.titleL.font = [UIFont systemFontOfSize:12];
        self.titleL.numberOfLines = 0;
        self.titleL.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:self.titleL];
        
        [self addAroundLine:UIEdgeInsetsMake(0, 0, 1, 1) color:[UIColor lightGrayColor]];
    }
    return self;
}
- (void)updateCellUI:(HDCellModel *)model
{
    AHCModelexcessids *item = model.orgData;
    self.titleL.text = item.value;
    if (item.isConfigSame) {
        self.contentView.backgroundColor = [UIColor clearColor];
    }else{
        self.contentView.backgroundColor = [UIColor colorWithRed:0.890 green:0.929 blue:0.976 alpha:1.000];
    }
}
@end


@interface AHCNormalCell()
@property (nonatomic, strong) HDCollectionView *collectionV;
@end

@implementation AHCNormalCell
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.collectionV = [AHCBaseCollectionView hd_makeHDCollectionView:^(HDCollectionViewMaker *maker) {
            maker
            .hd_frame(self.bounds)
            .hd_scrollDirection(UICollectionViewScrollDirectionHorizontal)
            .hd_isNeedTopStop(YES)
            .hd_isCalculateCellHOnCommonModes(YES)
            ;
        }];
        self.collectionV.collectionV.bounces = NO;
        self.collectionV.collectionV.showsHorizontalScrollIndicator = NO;
        [[HDSCVOffsetBinder shareInstance]bindScrollView:self.collectionV.collectionV groupID:AHC_Hor_Colletionview];
        [self.contentView addSubview:self.collectionV];
    }

    return self;
}

-(void)updateCellUI:(__kindof HDCellModel *)model
{
    [self.collectionV hd_setAllDataArr:model.orgData];
    CGPoint point =  [[[HDSCVOffsetBinder shareInstance] getCurrentOffsetByGroupID:AHC_Hor_Colletionview] CGPointValue];
    [self.collectionV.collectionV setContentOffset:point needKVONotify:NO];
}
- (void)clickSelf
{
    self.callback(self.hdModel);
}
@end
