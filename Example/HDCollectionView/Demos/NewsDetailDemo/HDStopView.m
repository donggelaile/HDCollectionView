//
//  HDStopView.m
//  HDCollectionView_Example
//
//  Created by HaoDong chen on 2019/5/30.
//  Copyright © 2019 donggelaile. All rights reserved.
//

#import "HDStopView.h"

@implementation HDStopView
{
    HDScrollJoinViewStopType type;
    UILabel *titleL;
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        titleL = [UILabel new];
        titleL.textColor = [UIColor whiteColor];
        titleL.textAlignment = NSTextAlignmentCenter;
        [self addSubview:titleL];
    }
    self.layer.borderColor = [UIColor whiteColor].CGColor;
    self.layer.borderWidth = 0.5;
    return self;
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    titleL.frame = self.bounds;
}
- (void)setStopType:(HDScrollJoinViewStopType)stopType title:(NSString *)title
{
    type = stopType;
    titleL.text = title;
}
- (HDScrollJoinViewStopType)hd_subViewStopType
{
    return type;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
