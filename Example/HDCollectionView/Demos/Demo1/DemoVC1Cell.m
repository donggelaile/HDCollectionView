//
//  DemoVC1Cell.m
//  HDCollectionView
//
//  Created by HaoDong chen on 2018/12/18.
//  Copyright © 2018 CHD. All rights reserved.
//

#import "DemoVC1Cell.h"
#import "UIView+gesture.h"
#import "HDDemoCellViewModel.h"

@interface DemoVC1Cell()
@property (nonatomic, strong) UILabel *titleL;
@end
@implementation DemoVC1Cell
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.titleL = [[UILabel alloc] initWithFrame:self.bounds];
        self.titleL.textAlignment = NSTextAlignmentCenter;
        self.titleL.numberOfLines = 0;
        [self.contentView addSubview:self.titleL];
    }
    __weak typeof(self) weakS = self;
    [self setTapActionWithBlock:^(UITapGestureRecognizer *tap) {
        [weakS clickSelf];
    }];
    return self;
}

HDCellVMGetter(HDDemoCellViewModel);

- (void)layoutSubviews
{
    _titleL.frame = self.bounds;
    [super layoutSubviews];
}
- (void)updateCellUI:(__kindof id<HDCellModelProtocol>)model
{
    self.titleL.text = model.orgData;
    self.backgroundColor = [self viewModel].bgColor;
}
- (void)clickSelf
{
    self.callback(self.hdModel);
}
@end
