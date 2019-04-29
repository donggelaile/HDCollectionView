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
@implementation HDSectionModel
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.headerTopStopType = HDHeaderStopOnTopTypeNone;
        self.sectionDataArr = @[].mutableCopy;
        self.isNeedAutoCountCellHW = NO;
        self.isForceUseHdSizeThatFits = NO;
        self.isNeedCacheSubviewsFrame = NO;
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
