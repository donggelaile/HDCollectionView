//
//  DemoVC2Header.m
//  HDCollectionView
//
//  Created by HaoDong chen on 2018/12/18.
//  Copyright © 2018 CHD. All rights reserved.
//

#import "AHCHeader.h"
#import "UIView+MJExtension.h"
#import "UIView+AroundLine.h"
@implementation AHCHeader
{
    UILabel *titleL;
    UILabel *tipsL;
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        titleL = [[UILabel alloc] initWithFrame:self.bounds];
        titleL.numberOfLines = 0;
        titleL.mj_x = 5;
        titleL.font = [UIFont systemFontOfSize:13.0f];
        [self addSubview:titleL];
        
        tipsL = [UILabel new];
        tipsL.text = @"◉ 标配 ◎ 选配 - 无";
        tipsL.font = [UIFont systemFontOfSize:13];
        [tipsL sizeToFit];
        tipsL.mj_x = self.mj_w - tipsL.mj_w - 10;
        tipsL.mj_y = (self.mj_h - tipsL.mj_h)/2;
        [self addSubview:tipsL];
        [self addAroundLine:UIEdgeInsetsMake(0, 0, 1, 0) color:[UIColor lightGrayColor]];
        self.backgroundColor = [UIColor colorWithRed:0.941 green:0.941 blue:0.941 alpha:1.000];
    }
    return self;
}
- (void)updateSecVUI:(__kindof id<HDSectionModelProtocol>)model
{
    titleL.text = model.headerObj;
}
@end
