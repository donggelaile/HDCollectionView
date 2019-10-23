//
//  DemoVC2Cell2.m
//  HDCollectionView
//
//  Created by HaoDong chen on 2018/12/18.
//  Copyright © 2018 CHD. All rights reserved.
//

#import "DemoVC2Cell2.h"
#import "UIView+gesture.h"
#import "HDCollectionView.h"

@interface DemoVC2Cell2()
@property (nonatomic, strong) UILabel *titleL;
@end
@implementation DemoVC2Cell2
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
    self.backgroundColor = [UIColor colorWithRed:(arc4random()%255)/255.0 green:(arc4random()%255)/255.0 blue:(arc4random()%255)/255.0 alpha:1];
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
-(void)updateCellUI:(__kindof id<HDCellModelProtocol>)model
{
}
- (void)clickSelf
{
    //比如点击这个cell,想做的操作是 删除这个cell
    
    //方式1
//    self.callback(self.hdModel);//直接调用主view设置的回调,让主view去处理
    
    //方式2
    void(^selfDeal)(void) = ^{
        __hd_WeakSelf
        [self.superCollectionV hd_changeSectionModelWithKey:self.hdModel.secModel.sectionKey animated:YES changingIn:^(HDSectionModel *secModel) {
            [secModel.sectionDataArr removeObjectAtIndex:weakSelf.hdModel.indexP.item];
        }];
    };
    HDDefaultCellEventDeal(selfDeal);
    
}
@end
