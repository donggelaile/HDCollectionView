//
//  DemoVC2.m
//  HDCollectionView
//
//  Created by HaoDong chen on 2018/11/6.
//  Copyright © 2018 CHD. All rights reserved.
//

#import "DemoVC6.h"
#import "HDCollectionView.h"
#import "Masonry.h"

@interface DemoVC6 ()
{
    HDCollectionView *listV;
}
@end

@implementation DemoVC6

- (void)viewDidLoad {
    [super viewDidLoad];
    [self demo];

    // Do any additional setup after loading the view.
}

- (void)demo
{
    self.view.backgroundColor = [UIColor whiteColor];

    listV = [HDCollectionView hd_makeHDCollectionView:^(HDCollectionViewMaker *maker) {
        maker
        .hd_isNeedTopStop(YES)
        .hd_scrollDirection(UICollectionViewScrollDirectionVertical);
    }];
    [self.view addSubview:listV];
    
    if (@available(iOS 11.0, *)) {
        [listV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.view.mas_safeAreaLayoutGuideLeft);
            make.right.mas_equalTo(self.view.mas_safeAreaLayoutGuideRight);
            make.bottom.mas_equalTo(self.view.mas_safeAreaLayoutGuideBottom);
            make.top.mas_equalTo(self.view.mas_safeAreaLayoutGuideTop);
        }];
        listV.collectionV.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }else{
        [listV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(0);
            make.right.mas_equalTo(0);
            make.bottom.mas_equalTo(0);
            make.top.mas_equalTo(64);
        }];
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    NSMutableArray *randomArr = @[].mutableCopy;
    
    for (int i=0; i<10; i++) {
        BOOL random = arc4random()%2;
        HDSectionModel *sec;
        if (random) {
            sec = [self makeWaterSec:i];
        }else{
            sec = [self makeYogaSec];
        }
        
        //穿插1拖N、N拖1
        [randomArr addObject:[self make1TNOrNT1SecModel]];
        
        [randomArr addObject:sec];
    }    
    
    [listV hd_setAllDataArr:randomArr];
    
    __weak typeof(self) weakS = self;
    [listV hd_setAllEventCallBack:^(id backModel, HDCallBackType type) {
        [weakS allEventCallback:backModel type:type];
    }];
    
    //如果cell回调处使用的是HDDefaultCellEventDeal宏，则此处的key 为cell类名 + # + 方法名。
    listV.allSubViewEventDealPolicy[@"DemoVC6Cell#clickSelf"] = @(HDCollectionViewEventDealPolicyAfterSubView);

}
- (void)allEventCallback:(id)backModel type:(HDCallBackType)type
{
    if (type == HDCellCallBack) {
        [self clickCell:backModel];
    }else if (type == HDSectionHeaderCallBack){
        [self clickHeader:backModel];
    }else if (type == HDSectionFooterCallBack){
        [self clickFooter:backModel];
    }
}
- (HDSectionModel*)makeWaterSec:(NSInteger)i
{
    HDSectionModel *sec = [self makeSecModel];
    
    return sec;
}
- (HDSectionModel*)makeYogaSec
{
    //该段cell数据源
    NSMutableArray *cellModelArr = @[].mutableCopy;
    UIEdgeInsets secInset = UIEdgeInsetsMake(30, 30, 30, 30);
    CGFloat vhGap = 5;
    NSInteger cellCount = 20;
    NSInteger columCount = arc4random()%5+2;
    CGFloat cellW = (hd_deviceWidth-secInset.left-secInset.right - vhGap*(columCount-1))/columCount;
    
    for (int i =0; i<cellCount; i++) {
        HDCellModel *model = [HDCellModel new];
        model.orgData      = @(i).stringValue;
        model.cellSize     = CGSizeMake(cellW, 50);
        model.cellClassStr = @"DemoVC6Cell";
        [cellModelArr addObject:model];
    }
    
    //该段layout
    HDYogaFlowLayout *layout = [HDYogaFlowLayout new];//isUseSystemFlowLayout为YES时只支持HDBaseLayout
    layout.secInset      = secInset;
    layout.justify       = arc4random()%YGJustifyCount;
    layout.verticalGap   = vhGap;
    layout.horizontalGap = vhGap;
    layout.headerSize    = CGSizeMake(self.view.frame.size.width, 50);
    layout.footerSize    = CGSizeMake(self.view.frame.size.width, 50);
    layout.decorationMargin = UIEdgeInsetsMake(20, 20, 20, 20);
    
    //该段的所有数据封装
    HDSectionModel *secModel = [HDSectionModel new];
    secModel.sectionHeaderClassStr = @"DemoVC6Header";
    secModel.sectionFooterClassStr = @"DemoVC6Footer";
    secModel.headerObj             = nil;
    secModel.footerObj             = nil;
    secModel.headerTopStopType     = arc4random()%2;
    secModel.sectionDataArr        = cellModelArr;
    secModel.layout                = layout;
    secModel.decorationClassStr    = @"DemoVC6DecorationView";
    secModel.decorationObj = [UIColor colorWithRed:(arc4random()%255)/255.0 green:(arc4random()%255)/255.0 blue:(arc4random()%255)/255.0 alpha:1];
    
    return secModel;
}
- (HDSectionModel*)makeSecModel
{
    //该段cell数据源
    NSMutableArray *cellModelArr = @[].mutableCopy;
    NSInteger cellCount = 20;
    for (int i =0; i<cellCount; i++) {
        HDCellModel *model = [HDCellModel new];
        model.orgData      = [NSString stringWithFormat:@"%@",@(i+1)];
        model.cellSize     = CGSizeMake(0, arc4random()%200 + 100);
        model.cellClassStr = @"DemoVC6Cell";
//        model.whRatio = ((arc4random() & 1024)+50)/1024.0f+1;
        [cellModelArr addObject:model];
    }
    
    //该段layout
    HDWaterFlowLayout *layout = [HDWaterFlowLayout new];//isUseSystemFlowLayout为YES时只支持HDBaseLayout
    layout.secInset      = UIEdgeInsetsMake(30, 30, 30, 30);
    layout.verticalGap   = 10;
    layout.horizontalGap = 10;
    layout.headerSize    = CGSizeMake(self.view.frame.size.width, 50);
    layout.footerSize    = CGSizeMake(self.view.frame.size.width, 50);
    layout.columnRatioArr = @[@1,@2,@1,@2];
    layout.decorationMargin = UIEdgeInsetsMake(10, 10, 10, 10);
    layout.isFirstAddAtRightOrBottom = YES;
    
    //该段的所有数据封装
    HDSectionModel *secModel = [HDSectionModel new];
    secModel.sectionHeaderClassStr = @"DemoVC6Header";
    secModel.sectionFooterClassStr = @"DemoVC6Footer";
    secModel.headerObj             = @"这个瀑布流是从右边开始摆放的";
    secModel.footerObj             = nil;
    secModel.headerTopStopType     = arc4random()%2;
    secModel.sectionDataArr        = cellModelArr;
    secModel.layout                = layout;
    secModel.decorationClassStr    = @"DemoVC6DecorationView";
    secModel.decorationObj = [UIColor colorWithRed:(arc4random()%255)/255.0 green:(arc4random()%255)/255.0 blue:(arc4random()%255)/255.0 alpha:1];

    return secModel;
}
// 一拖N,N拖一  其实就是个计算好的瀑布流布局...
- (HDSectionModel*)make1TNOrNT1SecModel
{
    //该段cell数据源
    
    NSMutableArray *cellModelArr = @[].mutableCopy;
    
    
    CGFloat oneHeight = 150;
    //一
    void(^add1)(void) = ^(void){
        HDCellModel *model = [HDCellModel new];
        model.orgData      = @"0";
        model.cellSize     = CGSizeMake(0, oneHeight);
        model.cellClassStr = @"DemoVC6Cell";
        [cellModelArr addObject:model];
    };
    
    //N
    void(^addN)(void) = ^(void){
        NSInteger n = (arc4random()%3+2);
        CGFloat nHeight = oneHeight/n;
        for (int i=0; i<n; i++) {
            HDCellModel *model = [HDCellModel new];
            model.orgData      = @(i+1).stringValue;
            model.cellSize     = CGSizeMake(0, nHeight);
            model.cellClassStr = @"DemoVC6Cell";
            [cellModelArr addObject:model];
        }
    };

    BOOL isNeedAddFromRight = NO;
    if (arc4random()%2) {
        //1拖N是从左开始先布局的瀑布流
    }else{
        isNeedAddFromRight = YES;
        //N拖1是从右开始先布局的瀑布流
    }
    
    add1();
    addN();
    
    //该段layout
    HDWaterFlowLayout *layout = [HDWaterFlowLayout new];//isUseSystemFlowLayout为YES时只支持HDBaseLayout
    layout.secInset      = UIEdgeInsetsMake(30, 30, 30, 30);
    layout.headerSize    = CGSizeMake(self.view.frame.size.width, 50);
    layout.footerSize    = CGSizeMake(self.view.frame.size.width, 50);
    layout.columnRatioArr = @[@2,@1];
    layout.decorationMargin = UIEdgeInsetsMake(10, 10, 10, 10);
    layout.isFirstAddAtRightOrBottom = isNeedAddFromRight;
    
    //该段的所有数据封装
    HDSectionModel *secModel = [HDSectionModel new];
    secModel.sectionHeaderClassStr = @"DemoVC6Header";
    secModel.sectionFooterClassStr = @"DemoVC6Footer";
    secModel.headerObj             = nil;
    secModel.footerObj             = nil;
    secModel.headerTopStopType     = arc4random()%2;
    secModel.sectionDataArr        = cellModelArr;
    secModel.layout                = layout;
    secModel.decorationClassStr    = @"DemoVC6DecorationView";
    secModel.decorationObj = [UIColor colorWithRed:(arc4random()%255)/255.0 green:(arc4random()%255)/255.0 blue:(arc4random()%255)/255.0 alpha:1];

    return secModel;
}

- (void)clickCell:(HDCellModel*)cellM
{
//    NSLog(@"点击了%zd--%zd cell",cellM.indexP.section,cellM.indexP.item);
    [listV hd_changeSectionModelWithKey:cellM.secModel.sectionKey animated:YES changingIn:^(HDSectionModel *secModel) {
        [secModel.sectionDataArr removeObjectAtIndex:cellM.indexP.item];
    }];
}
- (void)clickHeader:(HDSectionModel*)secM
{
    NSLog(@"点击了段头_%zd",secM.section);
}
- (void)clickFooter:(HDSectionModel*)secM
{
    NSLog(@"点击了段尾_%zd",secM.section);
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
