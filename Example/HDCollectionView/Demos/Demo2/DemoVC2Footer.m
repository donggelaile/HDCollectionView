//
//  DemoVC2Footer.m
//  HDCollectionView
//
//  Created by HaoDong chen on 2018/12/18.
//  Copyright © 2018 CHD. All rights reserved.
//

#import "DemoVC2Footer.h"
#import "UIView+gesture.h"
@interface DemoVC2Footer()
@property (nonatomic, strong) UILabel *title;
@end
@implementation DemoVC2Footer
-(UILabel *)title {
    if (!_title) {
        _title = [UILabel new];
        _title.font = [UIFont systemFontOfSize:20];
        _title.textColor = [UIColor orangeColor];
        _title.textAlignment = NSTextAlignmentCenter;
        
    }
    return _title;
}

-(void)layoutSubviews {
    _title.frame = self.bounds;
    [super layoutSubviews];
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.title];
    }
    __weak typeof (self) weakS = self;
    [self setTapActionWithBlock:^(UITapGestureRecognizer *tap) {
        [weakS clickSelf];
    }];
    self.backgroundColor = [UIColor colorWithRed:(arc4random()%255)/255.0 green:(arc4random()%255)/255.0 blue:(arc4random()%255)/255.0 alpha:1];
    return self;
}

- (void)updateSecVUI:(__kindof id<HDSectionModelProtocol>)model {
    _title.text = [NSString stringWithFormat:@"这是段尾---%@",model.footerObj];
}

- (void)clickSelf {
    self.callback(self.hdSecModel);
}

- (void)sectionViewFirstTimeShow {
    NSLog(@"首次展示footer__%zd", [self hdSecModel].section);
}

- (void)sectionViewWillShow {
    NSLog(@"即将展示footer__%zd", [self hdSecModel].section);
}

- (void)sectionViewDidEndShow {
    NSLog(@"footer__%zd展示结束", [self hdSecModel].section);
}

@end
