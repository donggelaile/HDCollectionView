//
//  DemoVC2.m
//  HDCollectionView
//
//  Created by HaoDong chen on 2018/11/6.
//  Copyright © 2018 CHD. All rights reserved.
//

#import "DemoVC5.h"
#import "HDCollectionView.h"
@interface DemoVC5 ()
{
    CGFloat collecitonViewH;
}
@end

@implementation DemoVC5

- (void)viewDidLoad {
    [super viewDidLoad];
    [self demo];

    // Do any additional setup after loading the view.
}
- (void)demo
{
//    self.navigationController.navigationBarHidden = YES;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor whiteColor];

    collecitonViewH = 350;
    HDCollectionView *listV = [HDCollectionView hd_makeHDCollectionView:^(HDCollectionViewMaker *maker) {
        maker
        .hd_frame(CGRectMake(0, 64, self.view.frame.size.width, self->collecitonViewH))
        .hd_isNeedTopStop(YES)
        .hd_isUseSystemFlowLayout(YES)
        .hd_scrollDirection(UICollectionViewScrollDirectionHorizontal);
    }];
    [self.view addSubview:listV];
    
    
    NSMutableArray *randomArr = @[].mutableCopy;
    for (int i=0; i<10; i++) {
        HDSectionModel *sec = [self makeSecModel];
        
        NSInteger type = 0;
        switch (i) {
            case 0:
                type = 1;
                break;
            case 1:
                type = 1;
                break;
            case 2:
                type = 1;
                break;
            case 3:
                type = 1;
                break;
            case 4:
                type = 2;
                break;
            case 5:
                type = 1;
                break;
            case 6:
                type = 1;
                break;
            case 7:
                type = 0;
                break;
            case 8:
                type = 2;
                break;
            case 9:
                type = 0;
                break;
           
            default:
                break;
        }
        sec.headerTopStopType = type;
//        NSLog(@"%d",sec.headerTopStopType);
        [randomArr addObject:sec];
    }    
    
    [listV hd_setAllDataArr:randomArr];
    
    __weak typeof(self) weakS = self;
    [listV hd_setAllEventCallBack:^(id backModel, HDCallBackType type) {

    }];

}
- (HDSectionModel*)makeSecModel
{
    //该段cell数据源
    NSMutableArray *cellModelArr = @[].mutableCopy;
    NSInteger cellCount = 30;
    for (int i =0; i<cellCount; i++) {
        HDCellModel *model = [HDCellModel new];
        model.orgData      = [NSString stringWithFormat:@"%@",@(i+1)];
        model.cellSize     = CGSizeMake(100, 150);
        model.cellClassStr = @"DemoVC5Cell";
        [cellModelArr addObject:model];
    }
    
    //该段layout
    HDYogaFlowLayout *layout = [HDYogaFlowLayout new];//isUseSystemFlowLayout为YES时只支持HDBaseLayout
    layout.secInset      = UIEdgeInsetsMake(0, 10, 0, 10);
    layout.justify       = YGJustifyCenter;
    layout.verticalGap   = 10;
    layout.horizontalGap = 20;
    layout.headerSize    = CGSizeMake(50, collecitonViewH);
    layout.footerSize    = CGSizeMake(50, collecitonViewH);
    
    //该段的所有数据封装
    HDSectionModel *secModel = [HDSectionModel new];
    secModel.sectionHeaderClassStr = @"DemoVC5Header";
    secModel.sectionFooterClassStr = @"DemoVC5Footer";
    secModel.headerObj             = nil;
    secModel.footerObj             = nil;
    secModel.headerTopStopType     = HDHeaderStopOnTopTypeNone;
    secModel.sectionDataArr        = cellModelArr;
    secModel.layout                = layout;
    
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
