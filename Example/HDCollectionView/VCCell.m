//
//  VCCell.m
//  HDCollectionView
//
//  Created by HaoDong chen on 2018/11/7.
//  Copyright © 2018 CHD. All rights reserved.
//

#import "VCCell.h"
@interface VCCell()
@property (nonatomic, strong) UILabel *titleL;
@end
@implementation VCCell
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.titleL = [[UILabel alloc] initWithFrame:self.bounds];
        self.titleL.textAlignment = NSTextAlignmentJustified;
        self.titleL.numberOfLines = 1;
        [self.contentView addSubview:self.titleL];
    }
    self.backgroundColor = [UIColor colorWithRed:(arc4random()%255)/255.0 green:(arc4random()%255)/255.0 blue:(arc4random()%255)/255.0 alpha:1];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickSelf)];
    [self.contentView addGestureRecognizer:tap];
    return self;
}
- (void)updateCellUI:(__kindof HDCellModel *)model
{
    self.titleL.text = model.orgData;
    self.titleL.frame = self.bounds;
}
- (void)clickSelf
{
    self.callback(self.hdModel);
}

- (CGSize)hdSizeThatFits:(CGSize)size
{
    CGSize newsize = [self.titleL sizeThatFits:CGSizeMake(CGFLOAT_MAX, 100)];
    if (newsize.width > 350) {
        newsize = CGSizeMake(350, newsize.height);
    }
    newsize = CGSizeMake((newsize.width), (newsize.height+20));
    return newsize;
}

@end
