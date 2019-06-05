//
//  QQDemoGapCell.m
//  HDCollectionView_Example
//
//  Created by HaoDong chen on 2019/5/15.
//  Copyright © 2019 donggelaile. All rights reserved.
//

#import "QQDemoGapCell.h"
#import "Masonry.h"
@implementation QQDemoGapCell
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithRed:0.969 green:0.969 blue:0.976 alpha:1.000];
        
        UIView *line = [UIView new];
        line.backgroundColor = [UIColor colorWithRed:0.871 green:0.875 blue:0.878 alpha:1.000];
        [self.contentView addSubview:line];
        
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.mas_equalTo(0);
            make.height.mas_equalTo(0.5);
        }];
    }
    return self;
}
- (CGSize)hdSizeThatFits:(CGSize)size
{
    return CGSizeMake(size.width, 10);
}
@end
