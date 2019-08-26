//
//  NewsDetailDemoVC.m
//  HDCollectionView_Example
//
//  Created by HaoDong chen on 2019/5/29.
//  Copyright © 2019 donggelaile. All rights reserved.
//

#import "NewsDetailDemoVC.h"
#import "HDNewsCollectionView.h"
#import "HDWebView.h"
#import "Masonry.h"
#import "UIView+HDSafeArea.h"
#import "HDStopView.h"


@interface NewsDetailDemoVC ()
@property (nonatomic, strong) HDScrollJoinView *mainView;
@end

@implementation NewsDetailDemoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUI];
    // Do any additional setup after loading the view.
}
- (void)setUI
{
    self.view.backgroundColor = [UIColor whiteColor];
    self.mainView = [[HDScrollJoinView alloc] initWithFrame:CGRectZero];
    [self.view addSubview:self.mainView];
    [self.mainView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0);
        make.top.mas_equalTo(self.view.hd_mas_top);
    }];
    //这里只是demo，实际中建议testArr.count 控制在3个左右
    NSMutableArray *testArr = @[].mutableCopy;
    for (int i=0; i<5; i++) {
        [testArr addObjectsFromArray:[self subListviewArr]];
    }
    [self.mainView hd_setListViews:testArr scrollDirection:UICollectionViewScrollDirectionVertical];
}
- (NSMutableArray *)subListviewArr
{
    NSMutableArray *result = @[].mutableCopy;
    
    //网页
//    HDWebView *web = [HDWebView new];
//    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"https://github.com"]];
//    //https://c.m.163.com/news/a/EGBAJ7FS002398HK.html?spss=newsapp
//    [web loadRequest:request];
//    [result addObject:web];
    
//    //悬停
//    HDStopView *stopView = [[HDStopView alloc] initWithFrame:CGRectMake(0, 0, hd_deviceWidth, 70)];
//    stopView.backgroundColor = [UIColor blueColor];
//    [stopView setStopType:HDScrollJoinViewStopTypeAlways title:@"一直悬浮在顶部"];
//    [result addObject:stopView];
    
    //原生(这里内嵌了HDNewsCollectionView，建议关闭其悬浮功能。使用HDScrollJoinView内置的功能来做悬浮)
    HDNewsCollectionView *cv = [HDNewsCollectionView hd_makeHDCollectionView:^(HDCollectionViewMaker *maker) {
        maker.hd_frame(CGRectZero);
    }];
    [cv hd_setAllDataArr:[self secArr:6]];
    [result addObject:cv];
//
//    //网页
//    HDWebView *web2 = [HDWebView new];
//    NSURLRequest *request2 = [NSURLRequest requestWithURL:[NSURL URLWithString:@"https://c.m.163.com/news/a/EGBAJ7FS002398HK.html?spss=newsapp"]];
//    [web2 loadRequest:request2];
//    [result addObject:web2];
//    
//    //悬停
//    HDStopView *stopView2 = [[HDStopView alloc] initWithFrame:CGRectMake(0, 0, hd_deviceWidth, 60)];
//    stopView2.backgroundColor = [UIColor orangeColor];
//    [stopView2 setStopType:HDScrollJoinViewStopTypeWhenNextDismiss title:@"跟随下一个view的滑出而滑出"];
//    [result addObject:stopView2];
//    
//    //原生
//    HDNewsCollectionView *cv2 = [HDNewsCollectionView hd_makeHDCollectionView:^(HDCollectionViewMaker *maker) {
//        maker.hd_frame(CGRectZero)
//        .hd_isNeedTopStop(YES);
//    }];
//    [cv2 hd_setAllDataArr:[self secArr:60]];
//    [result addObject:cv2];
    return result;
}
- (NSMutableArray *)secArr:(NSInteger)cellCount
{
    //该段cell数据源
    NSMutableArray *cellModelArr = @[].mutableCopy;
    for (int i =0; i<cellCount; i++) {
        HDCellModel *model = [HDCellModel new];
        model.orgData      = nil;
        model.cellSize     = CGSizeMake(self.view.frame.size.width, 40);
        model.cellClassStr = @"HDNewsCollectionViewCell";
        [cellModelArr addObject:model];
    }
    
    //该段layout
    HDYogaFlowLayout *layout = [HDYogaFlowLayout new];//isUseSystemFlowLayout为YES时只支持HDBaseLayout
    layout.headerSize = CGSizeMake(hd_deviceWidth, 50);
    
    //该段的所有数据封装
    HDSectionModel *secModel = [HDSectionModel new];
    secModel.sectionHeaderClassStr    = @"DemoVC6Header";
    secModel.sectionDataArr           = cellModelArr;
    secModel.layout                   = layout;
    
    return @[secModel].mutableCopy;
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
