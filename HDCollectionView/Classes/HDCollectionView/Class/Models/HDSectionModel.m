//
//  HDSectionModel.m
//  HDCollectionView
//
//  Created by HaoDong chen on 2018/11/5.
//  Copyright © 2018年 CHD. All rights reserved.
//

#import "HDSectionModel.h"
#import "HDDefines.h"
#import "NSObject+HDCopy.h"

@interface HDSectionModelChainMaker ()
@property (nonatomic, strong) NSMutableDictionary *allValues;
@property (nonatomic, copy) NSString *diySectionModelClassStr;
@end

@implementation HDSectionModelChainMaker

- (NSMutableDictionary *)allValues
{
    if (!_allValues) {
        _allValues = @{}.mutableCopy;
    }
    return _allValues;
}
- (__kindof id<HDSectionModelProtocol>)hd_generateObj
{
    id<HDSectionModelProtocol> model;
    if (self.diySectionModelClassStr) {
        if (HDClassFromString(self.diySectionModelClassStr)) {
            id tempModelCls = HDClassFromString(self.diySectionModelClassStr);
            if ([tempModelCls conformsToProtocol:@protocol(HDSectionModelProtocol)]) {
                model = [tempModelCls new];
            }
        }
    }
    if (!model) {
        model = [HDSectionModel new];
    }
    
    [self.allValues enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        [(NSObject*)model setValue:obj forKey:key];
    }];
    return model;
}
- (HDSectionModelChainMaker * _Nonnull (^)(NSString * _Nullable))hd_sectionHeaderClassStr
{
    return ^(NSString *sectionHeaderClassStr){
        if (sectionHeaderClassStr) {
            self.allValues[@"sectionHeaderClassStr"] = sectionHeaderClassStr;
        }
        return self;
    };
}
- (HDSectionModelChainMaker * _Nonnull (^)(NSString * _Nullable))hd_sectionFooterClassStr
{
    return ^(NSString *sectionFooterClassStr){
        if (sectionFooterClassStr) {
            self.allValues[@"sectionFooterClassStr"] = sectionFooterClassStr;
        }
        return self;
    };
}
- (HDSectionModelChainMaker * _Nonnull (^)(NSString * _Nullable))hd_sectionCellClassStr
{
    return ^(NSString *sectionCellClassStr){
        if (sectionCellClassStr) {
            self.allValues[@"sectionCellClassStr"] = sectionCellClassStr;
        }
        return self;
    };
}
- (HDSectionModelChainMaker * _Nonnull (^)(id  _Nullable))hd_headerObj
{
    return ^(id headerObj){
        if (headerObj) {
            self.allValues[@"headerObj"] = headerObj;
        }
        return self;
    };
}
- (HDSectionModelChainMaker * _Nonnull (^)(id  _Nullable))hd_footerObj
{
    return ^(id footerObj){
        if (footerObj) {
            self.allValues[@"footerObj"] = footerObj;
        }
        return self;
    };
}
- (HDSectionModelChainMaker * _Nonnull (^)(BOOL ))hd_isNeedAutoCountCellHW
{
    return ^(BOOL isNeedAutoCountCellHW){
        self.allValues[@"isNeedAutoCountCellHW"] = @(isNeedAutoCountCellHW);
        return self;
    };
}
- (HDSectionModelChainMaker * _Nonnull (^)(BOOL ))hd_isNeedCacheSubviewsFrame
{
    return ^(BOOL isNeedCacheSubviewsFrame){
        self.allValues[@"isNeedCacheSubviewsFrame"] = @(isNeedCacheSubviewsFrame);
        return self;
    };
}
- (HDSectionModelChainMaker * _Nonnull (^)(HDHeaderStopOnTopType headerTopStopType))hd_headerTopStopType
{
    return ^(HDHeaderStopOnTopType headerTopStopType){
        self.allValues[@"headerTopStopType"] = @(headerTopStopType);
        return self;
    };
}
- (HDSectionModelChainMaker * _Nonnull (^)(NSInteger))hd_headerTopStopOffset
{
    return ^(NSInteger headerTopStopOffset){
        self.allValues[@"headerTopStopOffset"] = @(headerTopStopOffset);
        return self;
    };
}

- (HDSectionModelChainMaker * _Nonnull (^)(NSMutableArray<id<HDCellModelProtocol>> * _Nonnull))hd_sectionDataArr
{
    return ^(NSMutableArray<id<HDCellModelProtocol>> *sectionDataArr){
        if (sectionDataArr) {
            self.allValues[@"sectionDataArr"] = sectionDataArr;
        }
        return self;
    };
}
- (HDSectionModelChainMaker * _Nonnull (^)(__kindof HDBaseLayout * _Nonnull))hd_layout
{
    return ^(HDBaseLayout *layout){
        if (layout) {
            self.allValues[@"layout"] = layout;
        }
        return self;
    };
}
- (HDSectionModelChainMaker * _Nonnull (^)(NSString * _Nullable))hd_sectionKey
{
    return ^(NSString *sectionKey){
        if (sectionKey) {
            self.allValues[@"sectionKey"] = sectionKey;
        }
        return self;
    };
}

- (HDSectionModelChainMaker * _Nonnull (^)(NSString * _Nullable))hd_decorationClassStr
{
    return ^(NSString *decorationClassStr){
        if (decorationClassStr) {
            self.allValues[@"decorationClassStr"] = decorationClassStr;
        }
        return self;
    };
}
- (HDSectionModelChainMaker * _Nonnull (^)(id _Nullable))hd_decorationObj
{
    return ^(id decorationObj){
        if (decorationObj) {
            self.allValues[@"decorationObj"] = decorationObj;
        }
        return self;
    };
}

- (HDSectionModelChainMaker * _Nonnull (^)(NSString * _Nullable))hd_diySectionModelClassStr
{
    return ^(NSString *diySectionModelClassStr){
        self.diySectionModelClassStr = diySectionModelClassStr;
        return self;
    };
}
@end

@implementation HDSectionModel

@synthesize sectionHeaderClassStr    = _sectionHeaderClassStr;
@synthesize sectionFooterClassStr    = _sectionFooterClassStr;
@synthesize sectionCellClassStr      = _sectionCellClassStr;
@synthesize decorationClassStr       = _decorationClassStr;
@synthesize headerObj                = _headerObj;
@synthesize footerObj                = _footerObj;
@synthesize isNeedAutoCountCellHW    = _isNeedAutoCountCellHW;
@synthesize isNeedCacheSubviewsFrame = _isNeedCacheSubviewsFrame;
@synthesize headerTopStopType        = _headerTopStopType;
@synthesize headerTopStopOffset      = _headerTopStopOffset;
@synthesize sectionDataArr           = _sectionDataArr;
@synthesize layout                   = _layout;
@synthesize sectionKey               = _sectionKey;
@synthesize decorationObj            = _decorationObj;
@synthesize isFinalSection           = _isFinalSection;
@synthesize section                  = _section;
@synthesize context                  = _context;
@synthesize secProperRect            = _secProperRect;
@synthesize otherParameter           = _otherParameter;

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.headerTopStopType = HDHeaderStopOnTopTypeNone;
        self.headerTopStopOffset = 0;
        self.sectionDataArr = @[].mutableCopy;
        self.isNeedAutoCountCellHW = NO;
    }
    return self;
}
- (NSString *)sectionKey
{
    if (!_sectionKey) {
        _sectionKey = @(self.section).stringValue;
    }
    return _sectionKey;
}
- (id)copyWithZone:(NSZone *)zone{
    return [self hd_copyWithZone:zone];
}
+(BOOL)accessInstanceVariablesDirectly{
    return YES;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    
}
- (id)valueForUndefinedKey:(NSString *)key
{
    return nil;
}

@end
