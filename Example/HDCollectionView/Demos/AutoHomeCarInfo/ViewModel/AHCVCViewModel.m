//
//  DemoVC2Footer.m
//  HDCollectionView
//
//  Created by HaoDong chen on 2018/12/18.
//  Copyright © 2018 CHD. All rights reserved.
//

#import "AHCVCViewModel.h"
#import "YYModel.h"
#import "AHCModel.h"
#import "HDYogaFlowLayout.h"
#import "HDDefines.h"
#define SafeRealStr(str) (([str isKindOfClass:[NSString class]])?str:@"")
static NSInteger AHCLeftHeaderW = 80;
static NSInteger AHCTopHeaderHW = 120;
static NSInteger AHCNormalCellH = 45;
static NSInteger AHCNormalHeaderH = 30;
@implementation AHCVCViewModel
{
    AHCModel *_ahcModel;
    BOOL isShowSameLine;
}
-(void)loadData:(void (^)(NSMutableArray * , NSError * ))callBack
{
    if (!callBack) {
        return;
    }
    isShowSameLine = YES;
    NSString *path = [[NSBundle mainBundle] pathForResource:@"carInfo" ofType:@"geojson"];
    AHCModel *model = [AHCModel yy_modelWithJSON:[NSData dataWithContentsOfFile:path]];
    _ahcModel = model;
    if (model) {
        if (model.returncode == 0) {
            callBack([self makeSecArr:model],nil);
        }else{
            callBack(nil,[NSError errorWithDomain:@"AHCVC" code:model.returncode userInfo:@{@"AHCLoadDataError":SafeRealStr(model.message)}]);
        }
    }else{
        callBack(nil,[NSError errorWithDomain:@"AHCVC" code:1001 userInfo:@{@"AHCLoadDataError":@"加载失败"}]);
    }
}
- (NSInteger)currentColumn
{
    return _ahcModel.result.specinfo.specitems.count;
}
- (NSMutableArray*)changeShowSameOrAllState
{
    isShowSameLine = !isShowSameLine;
    return [self makeSecArr:_ahcModel];
}
- (NSMutableArray*)deleteColumnWithID:(NSInteger)columnID
{
    __block NSInteger deleteIndex = -1;
    [_ahcModel.result.specinfo.specitems enumerateObjectsUsingBlock:^(AHCSpecitems * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.specid == columnID) {
            deleteIndex = idx;
            *stop = YES;
        }
    }];
    if (deleteIndex != -1) {
        NSMutableArray *temp = _ahcModel.result.specinfo.specitems.mutableCopy;
        [temp removeObjectAtIndex:deleteIndex];
        _ahcModel.result.specinfo.specitems = temp;
        return [self makeSecArr:_ahcModel];
    }else{
        return nil;
    }
    
}

- (NSMutableArray*)makeSecArr:(AHCModel*)model 
{
    NSMutableArray *secArr = @[].mutableCopy;
    [secArr addObject:[self AHCTopHeaderSec:model]];
    [model.result.paramitems enumerateObjectsUsingBlock:^(AHCParamConfigitems * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        HDSectionModel *configSec = [self AHCNormalCellSec:obj];
        if (configSec.sectionDataArr.count>0) {
            [secArr addObject:configSec];
        }
    }];
    [model.result.configitems enumerateObjectsUsingBlock:^(AHCParamConfigitems * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        HDSectionModel *configSec = [self AHCNormalCellSec:obj];
        if (configSec.sectionDataArr.count>0) {
            [secArr addObject:configSec];
        }
    }];
    
    return secArr;
}
//最顶部，车型行
- (HDSectionModel*)AHCTopHeaderSec:(AHCModel*)model
{
    //该段cell数据源
    NSMutableArray *cellModelArr = @[].mutableCopy;
    
    //该段layout
    HDYogaFlowLayout *layout = [HDYogaFlowLayout new];//isUseSystemFlowLayout为YES时只支持HDBaseLayout
    layout.secInset      = UIEdgeInsetsMake(0, 0, 0, 0);
    layout.justify       = YGJustifyFlexStart;
    layout.verticalGap   = 0;
    layout.horizontalGap = 0;
    layout.headerSize    = CGSizeMake(hd_deviceWidth, AHCTopHeaderHW);
    layout.footerSize    = CGSizeMake(0, 0);
    
    //该段的所有数据封装
    HDSectionModel *secModel = [HDSectionModel new];
    secModel.sectionHeaderClassStr = @"AHCTopHeader";
    secModel.sectionFooterClassStr = nil;
    secModel.headerObj             = @[[self AHCTopHeaderInnerSec:model]];
    secModel.footerObj             = nil;
    secModel.headerTopStopType     = HDHeaderStopOnTopTypeAlways;
    secModel.sectionDataArr        = cellModelArr;
    secModel.layout                = layout;
    
    return secModel;
}
//最顶部，车型行 内部数据
- (HDSectionModel*)AHCTopHeaderInnerSec:(AHCModel*)model
{
    //该段cell数据源
    NSMutableArray *cellModelArr = @[].mutableCopy;
    [model.result.specinfo.specitems enumerateObjectsUsingBlock:^(AHCSpecitems * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        HDCellModel *model = [HDCellModel new];
        model.orgData      = obj;
        model.cellSize     = CGSizeMake(AHCTopHeaderHW, AHCTopHeaderHW);
        model.cellClassStr = @"AHCTopInnerCell";
        [cellModelArr addObject:model];
    }];

    //该段layout
    HDYogaFlowLayout *layout = [HDYogaFlowLayout new];//isUseSystemFlowLayout为YES时只支持HDBaseLayout
    layout.secInset      = UIEdgeInsetsMake(0, 0, 0, 0);
    layout.justify       = YGJustifyFlexStart;
    layout.verticalGap   = 0;
    layout.horizontalGap = 0;
    layout.headerSize    = CGSizeMake(AHCLeftHeaderW, AHCTopHeaderHW);
    layout.footerSize    = CGSizeMake(0, 0);
    layout.decorationMargin = UIEdgeInsetsZero;
    
    //该段的所有数据封装
    HDSectionModel *secModel = [HDSectionModel new];
    secModel.sectionHeaderClassStr = @"AHCTopLeftHeader";
    secModel.sectionFooterClassStr = nil;
    secModel.headerObj             = @(isShowSameLine);
    secModel.footerObj             = nil;
    secModel.headerTopStopType     = HDHeaderStopOnTopTypeNormal;
    secModel.sectionDataArr        = cellModelArr;
    secModel.layout                = layout;
    secModel.decorationClassStr    = @"AHCTopDecorationView";
    
    return secModel;
}


//普通的cell的sec
- (HDSectionModel*)AHCNormalCellSec:(AHCParamConfigitems*)model
{
    //该段cell数据源
    NSMutableArray *cellModelArr = @[].mutableCopy;
    for (NSInteger idx=0; idx<model.items.count; idx++) {
        AHCItems *obj = model.items[idx];
        if (!(self->isShowSameLine)) {
            BOOL isThisLineSame = [self getOneLineIsSame:obj];
            if (isThisLineSame) {
                continue;
            }
        }
        HDCellModel *model = [HDCellModel new];
        model.orgData      = @[[self AHCNormalCellInnerSec:obj]];
        model.cellSize     = CGSizeMake(hd_deviceWidth, AHCNormalCellH);
        model.cellClassStr = @"AHCNormalCell";
//        model.reuseIdentifier = [NSString stringWithFormat:@"AHCNormalCell_%@_%@",@(start),@(idx)];
        [cellModelArr addObject:model];
    }

    //该段layout
    HDYogaFlowLayout *layout = [HDYogaFlowLayout new];//isUseSystemFlowLayout为YES时只支持HDBaseLayout
    layout.secInset      = UIEdgeInsetsMake(0, 0, 0, 0);
    layout.justify       = YGJustifyFlexStart;
    layout.verticalGap   = 0;
    layout.horizontalGap = 0;
    layout.headerSize    = CGSizeMake(hd_deviceWidth, AHCNormalHeaderH);
    layout.footerSize    = CGSizeMake(0, 0);
    
    //该段的所有数据封装
    HDSectionModel *secModel = [HDSectionModel new];
    secModel.sectionHeaderClassStr = @"AHCHeader";
    secModel.sectionFooterClassStr = nil;
    secModel.headerObj             = model.itemtype;
    secModel.footerObj             = nil;
    secModel.headerTopStopType     = HDHeaderStopOnTopTypeNormal;
    secModel.sectionDataArr        = cellModelArr;
    secModel.layout                = layout;
    
    return secModel;
}
//普通cell内部的sec
- (HDSectionModel*)AHCNormalCellInnerSec:(AHCItems*)model
{
    NSMutableDictionary *AHCModelexcessidsDic = @{}.mutableCopy;
    [model.modelexcessids enumerateObjectsUsingBlock:^(AHCModelexcessids * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        AHCModelexcessidsDic[@(obj.ID).stringValue] = obj;
    }];
    BOOL isConfigSame = [self getOneLineIsSame:model];
    
    //该段cell数据源
    NSMutableArray *cellModelArr = @[].mutableCopy;
    [_ahcModel.result.specinfo.specitems enumerateObjectsUsingBlock:^(AHCSpecitems * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        HDCellModel *model = [HDCellModel new];
        AHCModelexcessids *cellModel = AHCModelexcessidsDic[@(obj.specid).stringValue];
        cellModel.isConfigSame = isConfigSame;
        model.orgData      = cellModel;
        model.cellSize     = CGSizeMake(AHCTopHeaderHW, AHCNormalCellH);
        model.cellClassStr = @"AHCNormalCellInnerCell";
        [cellModelArr addObject:model];
    }];
    

    //该段layout
    HDYogaFlowLayout *layout = [HDYogaFlowLayout new];//isUseSystemFlowLayout为YES时只支持HDBaseLayout
    layout.secInset      = UIEdgeInsetsMake(0, 0, 0, 0);
    layout.justify       = YGJustifyFlexStart;
    layout.verticalGap   = 0;
    layout.horizontalGap = 0;
    layout.headerSize    = CGSizeMake(AHCLeftHeaderW, AHCNormalCellH);
    layout.footerSize    = CGSizeMake(0, 0);
    
    //该段的所有数据封装
    HDSectionModel *secModel = [HDSectionModel new];
    secModel.sectionHeaderClassStr = @"AHCNormalCellHeader";
    secModel.sectionFooterClassStr = nil;
    secModel.headerObj             = model.name;
    secModel.footerObj             = nil;
    secModel.headerTopStopType     = HDHeaderStopOnTopTypeNormal;
    secModel.sectionDataArr        = cellModelArr;
    secModel.layout                = layout;
    
    return secModel;
}
- (BOOL)getOneLineIsSame:(AHCItems*)model
{
    NSMutableDictionary *AHCModelexcessidsDic = @{}.mutableCopy;
    [model.modelexcessids enumerateObjectsUsingBlock:^(AHCModelexcessids * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        AHCModelexcessidsDic[@(obj.ID).stringValue] = obj;
    }];
    //取出需要计算的数据
    NSMutableArray<AHCModelexcessids*> *needCountArr = @[].mutableCopy;
    [_ahcModel.result.specinfo.specitems enumerateObjectsUsingBlock:^(AHCSpecitems * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [needCountArr addObject:AHCModelexcessidsDic[@(obj.specid).stringValue]];
    }];
    
    __block BOOL isSame = YES;
    NSInteger firstHash = [(AHCModelexcessids*)[needCountArr firstObject] value].hash;
    [needCountArr enumerateObjectsUsingBlock:^(AHCModelexcessids * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.value.hash != firstHash) {
            isSame = NO;
            *stop = YES;
        }
    }];
    
    return isSame;
}
@end
