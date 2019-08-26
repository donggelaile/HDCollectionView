//
//  QQDemoFriendCell.m
//  HDCollectionView_Example
//
//  Created by HaoDong chen on 2019/5/15.
//  Copyright © 2019 donggelaile. All rights reserved.
//

#import "QQDemoFriendCell.h"
#import "Masonry.h"
#import "QQDemoFriendCellVM.h"

@interface QQDemoFriendCell()
@property (nonatomic, strong) UIImageView *headerImgV;
@property (nonatomic, strong) UILabel *titleL;
@property (nonatomic, strong) UILabel *onlineState;
@end

@implementation QQDemoFriendCell
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.headerImgV = [UIImageView new];
        self.headerImgV.layer.cornerRadius = 20;
        self.headerImgV.backgroundColor = [UIColor colorWithRed:(arc4random()%255)/255.0 green:(arc4random()%255)/255.0 blue:(arc4random()%255)/255.0 alpha:1];
        [self.contentView addSubview:self.headerImgV];
        
        self.titleL = [UILabel new];
        [self.contentView addSubview:self.titleL];
        
        self.onlineState = [UILabel new];
        [self.contentView addSubview:self.onlineState];
        
        [self.headerImgV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(15);
            make.centerY.mas_equalTo(self.contentView);
            make.width.height.mas_equalTo(40);
        }];
        
        [self.titleL mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.edges.mas_equalTo(self.contentView).mas_offset(UIEdgeInsetsZero);
            make.left.mas_equalTo(self.headerImgV.mas_right).offset(10);
            make.centerY.mas_equalTo(self.contentView);
        }];
    }
    return self;
}
- (QQDemoFriendCellVM*)viewModel
{
    if ([self.hdModel isKindOfClass:[QQDemoFriendCellVM class]]) {
        return self.hdModel;
    }
    return nil;
}
- (void)updateCellUI:(__kindof id<HDCellModelProtocol>)model
{
    QQDemoFriendCellVM *vm = [self viewModel];
    self.titleL.attributedText = vm.vmTitle;

}
@end
