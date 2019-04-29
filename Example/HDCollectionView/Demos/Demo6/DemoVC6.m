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
    CGFloat collecitonViewH;
}
@end

@implementation DemoVC6

- (void)viewDidLoad {
    [super viewDidLoad];
    [self demo];

    // Do any additional setup after loading the view.
}
- (void)change
{
    
}
- (void)demo
{
//    self.navigationController.navigationBarHidden = YES;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    
    collecitonViewH = self.view.frame.size.height-64;
    HDCollectionView *listV = [HDCollectionView hd_makeHDCollectionView:^(HDCollectionViewMaker *maker) {
        maker
        .hd_frame(CGRectMake(0, 64, self.view.frame.size.width, self->collecitonViewH))
        .hd_isNeedTopStop(NO)
        .hd_scrollDirection(UICollectionViewScrollDirectionVertical);
    }];
    [self.view addSubview:listV];
    
    
    NSMutableArray *randomArr = @[].mutableCopy;

    for (int i=0; i<20; i++) {
        BOOL random = arc4random()%2;
        HDSectionModel *sec;
        if (random) {
            sec = [self makeWaterSec:i];
        }else{
            sec = [self makeYogaSec];
        }
        [randomArr addObject:sec];
    }    
    
    [listV hd_setAllDataArr:randomArr];
    
    __weak typeof(self) weakS = self;
    [listV hd_setAllEventCallBack:^(id backModel, HDCallBackType type) {
        
    }];

}

- (HDSectionModel*)makeWaterSec:(NSInteger)i
{
    HDSectionModel *sec = [self makeSecModel];
    
    NSInteger type = 1;
    sec.headerTopStopType = type;
    return sec;
}
- (HDSectionModel*)makeYogaSec
{
    //该段cell数据源
    NSMutableArray *cellModelArr = @[].mutableCopy;
    NSInteger cellCount = arc4random() & 40 + 5;
    for (int i =0; i<cellCount; i++) {
        HDCellModel *model = [HDCellModel new];
        model.orgData      = @(i).stringValue;
        model.cellSize     = CGSizeMake(140, 50);
        model.cellClassStr = @"DemoVC6Cell";
        [cellModelArr addObject:model];
    }
    
    //该段layout
    HDYogaFlowLayout *layout = [HDYogaFlowLayout new];//isUseSystemFlowLayout为YES时只支持HDBaseLayout
    layout.secInset      = UIEdgeInsetsMake(30, 30, 30, 30);
    layout.justify       = YGJustifyCenter;
    layout.verticalGap   = 10;
    layout.horizontalGap = 10;
    layout.headerSize    = CGSizeMake(self.view.frame.size.width, 50);
    layout.footerSize    = CGSizeMake(self.view.frame.size.width, 50);
    layout.decorationMargin = UIEdgeInsetsMake(20, 20, 20, 20);
    
    //该段的所有数据封装
    HDSectionModel *secModel = [HDSectionModel new];
    secModel.sectionHeaderClassStr = @"DemoVC6Header";
    secModel.sectionFooterClassStr = @"DemoVC6Footer";
    secModel.headerObj             = nil;
    secModel.footerObj             = nil;
    secModel.headerTopStopType     = ABS(arc4random() & 1);
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
    NSInteger cellCount = 30;
    for (int i =0; i<cellCount; i++) {
        HDCellModel *model = [HDCellModel new];
        model.orgData      = [NSString stringWithFormat:@"%@",@(i+1)];
        model.cellSize     = CGSizeMake(100, arc4random()%200 + 100);
        model.cellClassStr = @"DemoVC6Cell";
//        model.whRatio = ((arc4random() & 1024)+50)/1024.0f+1;
        [cellModelArr addObject:model];
    }
    
    //该段layout
    HDWaterFlowLayout *layout = [HDWaterFlowLayout new];//isUseSystemFlowLayout为YES时只支持HDBaseLayout
    layout.secInset      = UIEdgeInsetsMake(20, 20, 20, 20);
    layout.verticalGap   = 10;
    layout.horizontalGap = 10;
    layout.headerSize    = CGSizeMake(self.view.frame.size.width, 50);//CGSizeMake(50, collecitonViewH);//CGSizeMake(self.view.frame.size.width, 50)
    layout.footerSize    = CGSizeMake(self.view.frame.size.width, 50);
    layout.columnRatioArr = @[@1,@2,@1,@2];
    layout.decorationMargin = UIEdgeInsetsMake(10, 10, 10, 10);
    
    //该段的所有数据封装
    HDSectionModel *secModel = [HDSectionModel new];
    secModel.sectionHeaderClassStr = @"DemoVC6Header";
    secModel.sectionFooterClassStr = @"DemoVC6Footer";
    secModel.headerObj             = nil;
    secModel.footerObj             = nil;
    secModel.headerTopStopType     = HDHeaderStopOnTopTypeNone;
    secModel.sectionDataArr        = cellModelArr;
    secModel.layout                = layout;
    secModel.decorationClassStr    = @"DemoVC6DecorationView";
    secModel.decorationObj = [UIColor colorWithRed:(arc4random()%255)/255.0 green:(arc4random()%255)/255.0 blue:(arc4random()%255)/255.0 alpha:1];

    return secModel;
}
- (void)test
{
    
}
- (void)clickCell:(HDCellModel*)cellM
{
    NSLog(@"点击了%zd--%zd cell",cellM.indexP.section,cellM.indexP.item);
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
