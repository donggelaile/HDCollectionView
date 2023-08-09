//
//  DemoVC2Cell.m
//  HDCollectionView
//
//  Created by HaoDong chen on 2018/12/18.
//  Copyright © 2018 CHD. All rights reserved.
//

#import "DemoVC2Cell.h"
#import "UIView+gesture.h"
#import "HDCollectionView.h"
#import "HDDemoCellViewModel.h"

@interface DemoVC2Cell()
@end
@implementation DemoVC2Cell
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
    }
    __weak typeof(self) weakS = self;
    [self setTapActionWithBlock:^(UITapGestureRecognizer *tap) {
        [weakS clickSelf];
    }];

    return self;
}

HDCellVMGetter(HDDemoCellViewModel);

-(void)updateCellUI:(__kindof id<HDCellModelProtocol>)model {
    self.backgroundColor = [self viewModel].bgColor;
}

- (void)clickSelf {
    //比如点击这个cell,想做的操作是 删除这个cell
    
    //方式1
    //    self.callback(self.hdModel);//直接调用主view设置的回调,让主view去处理
    
    //方式2
    //配合主view的allSubViewEventDealPolicy使用
    //HDCollectionView的allSubViewEventDealPolicy未设置时默认为cell自己处理该事件,使用方式见Demo6
    NSLog(@"%@",self.hdModel.cellFrameXY);
    void(^selfDeal)(void) = ^{
        __hd_WeakSelf
        [self.superCollectionV hd_changeSectionModelWithKey:self.hdModel.secModel.sectionKey animated:YES changingIn:^(HDSectionModel *secModel) {
            [secModel.sectionDataArr removeObjectAtIndex:weakSelf.hdModel.indexP.item];
        }];
    };
    HDDefaultCellEventDeal(selfDeal);
}

//- (void)cellFirstTimeShow {
//    NSLog(@"首次展示了cell--%@", [self viewModel].indexP);
//}
//
//- (void)cellWillShow {
//    NSLog(@"即将展示cell--%@", [self viewModel].indexP);
//}
//
//- (void)cellDidEndShow {
//    NSLog(@"cell--%@--展示结束", [self viewModel].indexP);
//}

- (void)dealloc {
    
}
@end
