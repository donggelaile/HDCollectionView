//
//  DemoVC4Cell2.m
//  HDCollectionView_Example
//
//  Created by HaoDong chen on 2019/5/10.
//  Copyright © 2019 donggelaile. All rights reserved.
//

#import "DemoVC4Cell2.h"

@interface DemoVC4Cell2InnerCell : HDCollectionCell
@property (nonatomic, strong) UILabel *titleL;
@end

@implementation DemoVC4Cell2InnerCell
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor orangeColor];
        self.titleL = [[UILabel alloc] initWithFrame:self.bounds];
        self.titleL.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:self.titleL];
    }
    return self;
}

-(void)updateCellUI:(__kindof HDCellModel *)model
{
    self.titleL.text = [NSString stringWithFormat:@"%@",@(model.indexP.item)];
}
@end


@interface DemoVC4Cell2()
@property (nonatomic, strong) HDCollectionView *collectionV;
@end
@implementation DemoVC4Cell2
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.collectionV = [HDCollectionView hd_makeHDCollectionView:^(HDCollectionViewMaker *maker) {
            maker
            .hd_frame(self.bounds)
            .hd_scrollDirection(UICollectionViewScrollDirectionHorizontal);
        }];

        [self.contentView addSubview:self.collectionV];
    }
    return self;
}
- (void)updateCellUI:(__kindof id<HDCellModelProtocol>)model
{
    //需要确保DemoVC4Cell2不会与其他cell共同复用，这里就可以只设置一次self.collectionV的数据源
    //如果DemoVC4Cell2与其他cell复用了，则需要去掉 if (self.collectionV.innerAllData.count == 0)判断
    if (self.collectionV.innerAllData.count == 0) {
        [self.collectionV hd_setAllDataArr:model.orgData];
    }
}
@end
