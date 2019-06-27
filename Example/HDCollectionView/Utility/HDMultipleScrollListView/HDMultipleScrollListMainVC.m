//
//  HDMultipleScrollListMainVC.m
//  HDCollectionView_Example
//
//  Created by HaoDong chen on 2019/5/21.
//  Copyright © 2019 donggelaile. All rights reserved.
//

#import "HDMultipleScrollListMainVC.h"
#import "HDMultipleScrollListView.h"
@interface HDMultipleScrollListMainVC ()
@end

@implementation HDMultipleScrollListMainVC
@synthesize multipleSc = _multipleSc;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUp];
    // Do any additional setup after loading the view.
}
- (void)setUp
{
    _multipleSc = [[HDMultipleScrollListView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:self.multipleSc];
    
    __weak typeof(self) weakSelf = self;
    [self.multipleSc configFinishCallback:^(HDMultipleScrollListConfiger * _Nonnull configer) {
        [weakSelf configFinish:configer];
    }];

}
- (void)configFinish:(HDMultipleScrollListConfiger*)configer
{
    [configer.controllers enumerateObjectsUsingBlock:^(UIViewController<HDMultipleScrollListViewScrollViewDidScroll> * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [self addChildViewController:obj];
    }];
}
- (void)dealloc
{
    
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
