//
//  DemoVC2Cell.m
//  HDCollectionView
//
//  Created by HaoDong chen on 2018/12/18.
//  Copyright © 2018 CHD. All rights reserved.
//

#import "DemoVC4Cell.h"
#import "UIView+gesture.h"
@interface DemoVC4Cell()
@property (nonatomic, strong) UILabel *titleL;
@end
@implementation DemoVC4Cell
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
    self.titleL.text = [NSString stringWithFormat:@"%@_%zd_%zd",model.cellClassStr,model.indexP.section,model.indexP.item];
}
- (void)clickSelf
{
    self.callback(self.hdModel);
}
@end
