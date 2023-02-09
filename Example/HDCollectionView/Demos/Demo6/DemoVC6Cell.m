//
//  DemoVC2Cell.m
//  HDCollectionView
//
//  Created by HaoDong chen on 2018/12/18.
//  Copyright © 2018 CHD. All rights reserved.
//

#import "DemoVC6Cell.h"
#import "UIView+gesture.h"
#import "HDDemoCellViewModel.h"

@interface DemoVC6Cell()
@property (nonatomic, strong) UILabel *titleL;
@end
@implementation DemoVC6Cell
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
- (void)layoutSubviews
{
    _titleL.frame = self.bounds;
    [super layoutSubviews];
}

HDCellVMGetter(HDDemoCellViewModel);

-(void)updateCellUI:(__kindof id<HDCellModelProtocol>)model
{
    self.titleL.text = [NSString stringWithFormat:@"%@",model.orgData];
    self.backgroundColor = [self viewModel].bgColor;
}

- (void)clickSelf
{
    //方式1，自己管理context
//    self.hdModel.context = NSStringFromSelector(_cmd);//设置标志供HDCollectionView回调中判断是哪个事件
//    //此处无需判断self.callback是否为空，内部已经判断
//    self.callback(self.hdModel);//此处调用会回调到HDCollectionView的hd_setAllEventCallBack中
//    self.hdModel.context = nil;//使用完毕则置nil
    
    //方式2，使用内置的宏来管理回调。配合cell所在HDCollecitonView的allSubViewEventDealPolicy配置来管理回调事件的策略
    void(^selfDealCode)(void) = ^{
        NSLog(@"点击了cell");
    };
    HDDefaultCellEventDeal(selfDealCode);
}
@end
