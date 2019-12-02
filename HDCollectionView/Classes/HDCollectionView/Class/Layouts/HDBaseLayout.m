//
//  HDBaseLayout.m
//  HDCollectionView
//
//  Created by HaoDong chen on 2019/4/4.
//  Copyright © 2019 CHD. All rights reserved.
//

#import "HDBaseLayout.h"
#import "NSObject+HDCopy.h"
#import "HDModelProtocol.h"

@interface HDBaseLayoutChainMaker ()
@property (nonatomic, strong) NSMutableDictionary *allValues;
@end

@implementation HDBaseLayoutChainMaker
- (NSMutableDictionary *)allValues
{
    if (!_allValues) {
        _allValues = @{}.mutableCopy;
    }
    return _allValues;
}
- (Class)hd_generateLayoutClass
{
    return [HDBaseLayout class];
}
- (__kindof HDBaseLayout*)hd_generateObj
{
    HDBaseLayout* layout = [[self hd_generateLayoutClass] new];
    [self.allValues enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        [layout setValue:obj forKey:key];
    }];
    return layout;
}
- (HDBaseLayoutChainMaker * _Nonnull (^)(CGSize))hd_headerSize
{
    return ^(CGSize headerSize){
        self.allValues[@"headerSize"] = [NSValue valueWithCGSize:headerSize];
        return self;
    };
}
- (HDBaseLayoutChainMaker * _Nonnull (^)(CGSize))hd_footerSize
{
    return ^(CGSize footerSize){
        self.allValues[@"footerSize"] = [NSValue valueWithCGSize:footerSize];
        return self;
    };
}
- (HDBaseLayoutChainMaker * _Nonnull (^)(CGSize))hd_cellSize
{
    return ^(CGSize cellSize){
        self.allValues[@"cellSize"] = [NSValue valueWithCGSize:cellSize];
        return self;
    };
}
- (HDBaseLayoutChainMaker * _Nonnull (^)(UIEdgeInsets))hd_secInset
{
    return ^(UIEdgeInsets secInset){
        self.allValues[@"secInset"] = [NSValue valueWithUIEdgeInsets:secInset];
        return self;
    };
}
- (HDBaseLayoutChainMaker * _Nonnull (^)(CGFloat))hd_verticalGap
{
    return ^(CGFloat verticalGap){
        self.allValues[@"verticalGap"] = @(verticalGap);
        return self;
    };
}
- (HDBaseLayoutChainMaker * _Nonnull (^)(CGFloat))hd_horizontalGap
{
    return ^(CGFloat horizontalGap){
        self.allValues[@"horizontalGap"] = @(horizontalGap);
        return self;
    };
}

@end

@interface HDBaseLayout()
@end

@implementation HDBaseLayout
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.secInset = UIEdgeInsetsZero;
        self.verticalGap = 0;
        self.horizontalGap = 0;
        self.headerSize = CGSizeZero;
        self.footerSize = CGSizeZero;
        self.cellSize = CGSizeZero;
    }
    return self;
}
- (CGSize)headerSize
{
    if (self.headerSizeCb) {
        _headerSize = self.headerSizeCb();
    }
    return _headerSize;
}
- (CGSize)footerSize
{
    if (self.footerSizeCb) {
        _footerSize = self.footerSizeCb();
    }
    return _footerSize;
}
- (id)copyWithZone:(NSZone *)zone
{
    return  [self hd_copyWithZone:zone];
}
- (NSMutableArray *)layoutWithLayout:(UICollectionViewLayout *)layout sectionModel:(id<HDSectionModelProtocol>)secModel currentStart:(CGPoint *)cStart
{
    return @[].mutableCopy;
}
@end
