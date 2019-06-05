//
//  QQDemoFriendGroupHeader.m
//  HDCollectionView_Example
//
//  Created by HaoDong chen on 2019/5/15.
//  Copyright © 2019 donggelaile. All rights reserved.
//

#import "QQDemoFriendGroupHeader.h"
#import "QQDemoOpenCloseSec.h"
#import "Masonry.h"

@interface QQDemoFriendGroupHeader()
@property (nonatomic, strong) UILabel *titleL;
@property (nonatomic, strong) UILabel *onlineState;
@end

@implementation QQDemoFriendGroupHeader
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.titleL = [UILabel new];
        [self addSubview:self.titleL];
        
        self.onlineState = [UILabel new];
        [self addSubview:self.onlineState];
        
        [self.titleL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(20);
            make.centerY.mas_equalTo(self);
        }];
        
        [self.onlineState mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-10);
            make.centerY.mas_equalTo(self);
        }];
        
        
    }

    
    UIView *line = [UIView new];
    line.backgroundColor = [UIColor colorWithRed:0.871 green:0.875 blue:0.878 alpha:1.000];
    [self addSubview:line];
    
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0);
        make.height.mas_equalTo(0.5);
    }];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selfClick)];
    [self addGestureRecognizer:tap];
    self.backgroundColor = [UIColor whiteColor];
    return self;
}
- (QQDemoOpenCloseSec*)secModel
{
    if ([self.hdSecModel isKindOfClass:[QQDemoOpenCloseSec class]]) {
        return self.hdSecModel;
    }
    return nil;
}
- (void)selfClick
{
    QQDemoOpenCloseSec*secm = [self secModel];
    if (secm.isOpen) {
        [self.superCollectionV hd_changeSectionModelWithKey:secm.sectionKey changingIn:^(HDSectionModel *secModel) {
            secModel.sectionDataArr = @[].mutableCopy;
        }];
    }else{
        [self.superCollectionV hd_changeSectionModelWithKey:secm.sectionKey changingIn:^(HDSectionModel *secModel) {
            secModel.sectionDataArr = secm.sectionDataCopy.mutableCopy;
        }];
    }
    secm.isOpen = !secm.isOpen;
}
- (void)updateSecVUI:(__kindof HDSectionModel *)model
{
    self.titleL.text = model.headerObj;
    self.onlineState.text = @"5/65";
}
@end
