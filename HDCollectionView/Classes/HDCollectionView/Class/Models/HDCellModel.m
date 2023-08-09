//
//  HDCellModel.m
//  
//
//  Created by CHD on 2018/8/9.
//  Copyright © 2018年 chd. All rights reserved.
//

#import "HDCellModel.h"
#import "HDCollectionCell.h"
#import "HDCellFrameCacheHelper.h"
#import <objc/runtime.h>
#import "NSObject+HDCopy.h"

@interface HDCellModelChainMaker ()
@property (nonatomic, strong) NSMutableDictionary *allValues;
@property (nonatomic, copy) NSString *diyCellModelClassStr;
@end

@implementation HDCellModelChainMaker

- (NSMutableDictionary *)allValues {
    if (!_allValues) {
        _allValues = @{}.mutableCopy;
    }
    return _allValues;
}

- (__kindof id<HDCellModelProtocol>)hd_generateObj {
    id<HDCellModelProtocol> model;
    if (self.diyCellModelClassStr) {
        if (HDClassFromString(self.diyCellModelClassStr)) {
            id tempModelCls = HDClassFromString(self.diyCellModelClassStr);
            if ([tempModelCls conformsToProtocol:@protocol(HDCellModelProtocol)]) {
                model = [tempModelCls new];
            }
        }
    }
    if (!model) {
        model = [HDCellModel new];
    }
    
    [self.allValues enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        [(NSObject*)model setValue:obj forKey:key];
    }];
    return model;
}

- (HDCellModelChainMaker * _Nonnull (^)(id _Nullable))hd_orgData {
    return ^(id orgData){
        if (orgData) {
            self.allValues[@"orgData"] = orgData;
        }
        return self;
    };
}

- (HDCellModelChainMaker * _Nonnull (^)(CGSize))hd_cellSize {
    return ^(CGSize cellSize){
        self.allValues[@"cellSize"] = [NSValue valueWithCGSize:cellSize];
        return self;
    };
}

- (HDCellModelChainMaker * _Nonnull (^)(NSString * _Nullable))hd_cellClassStr {
    return ^(NSString* cellClassStr){
        if (cellClassStr) {
            self.allValues[@"cellClassStr"] = cellClassStr;
        }
        return self;
    };
}

- (HDCellModelChainMaker * _Nonnull (^)(UIEdgeInsets))hd_margain {
    return ^(UIEdgeInsets margain){
        self.allValues[@"margain"] = [NSValue valueWithUIEdgeInsets:margain];
        return self;
    };
}

- (HDCellModelChainMaker * _Nonnull (^)(NSString * _Nullable))hd_reuseIdentifier {
    return ^(NSString* reuseIdentifier){
        if (reuseIdentifier) {
            self.allValues[@"reuseIdentifier"] = reuseIdentifier;
        }
        return self;
    };
}

- (HDCellModelChainMaker * _Nonnull (^)(NSString * _Nullable))hd_diyCellModelClassStr {
    return ^(NSString* diyCellModelClassStr){
        self.diyCellModelClassStr = diyCellModelClassStr;
        return self;
    };
}

@end 


@implementation HDCellModel

@synthesize secModel        = _secModel;
@synthesize subviewsFrame   = _subviewsFrame;
@synthesize cellClassStr    = _cellClassStr;
@synthesize cellFrameXY     = _cellFrameXY;
@synthesize cellSize        = _cellSize;
@synthesize cellSizeCb      = _cellSizeCb;
@synthesize context         = _context;
@synthesize indexP          = _indexP;
@synthesize isConvertedToVM = _isConvertedToVM;
@synthesize margain         = _margain;
@synthesize orgData         = _orgData;
@synthesize reuseIdentifier = _reuseIdentifier;
@synthesize otherParameter  = _otherParameter;
@synthesize isCellHasShow   = _isCellHasShow;

- (instancetype)init {
    self = [super init];
    if (self) {
        self.cellSize = CGSizeZero;
        self.margain = UIEdgeInsetsZero;
    }
    return self;
}

- (NSString *)reuseIdentifier {
    if (!_reuseIdentifier) {
        _reuseIdentifier = self.cellClassStr;
    }
    return _reuseIdentifier;
}

- (BOOL)hdDiffIdentifierIsNeedAddModelHash {
    return YES;
}

- (NSDictionary *)hdDiffIdentifierIgnorePropertys {
    return @{
             @"hash":@(YES),
             @"superclass":@(YES),
             @"description":@(YES),
             @"debugDescription":@(YES),
             @"cellSizeCb":@(YES),
             @"indexP":@(YES),
             @"cellFrameXY":@(YES),
             @"secModel":@(YES)
             };
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    
}

- (id)valueForUndefinedKey:(NSString *)key {
    return nil;
}

- (NSString *)hdDiffIdentifier {
    //默认实现为综合HDCellModel的部分属性值及orgData的属性值
    return [self hdObjectIDByPropertys];
}

- (CGSize)calculateCellProperSize:(BOOL)isForceUseAutoLayout {
    @autoreleasepool {
        HDCollectionCell<HDUpdateUIProtocol>*tempCell = [[HDClassFromString(self.cellClassStr) alloc] initWithFrame:CGRectMake(0, 0, self.cellSize.width, self.cellSize.height)];
        
        BOOL isNeedCacheSubviewsFrame = [tempCell respondsToSelector:@selector(cacheSubviewsFrameBySetLayoutWithCellModel:)];
        
        if (isNeedCacheSubviewsFrame) {
            [tempCell setCacheKeysIfNeed];
        }
        if ([tempCell respondsToSelector:@selector(superUpdateCellUI:callback:)]) {
            [tempCell superUpdateCellUI:self callback:nil];
        }
        if ([tempCell respondsToSelector:@selector(updateCellUI:)]) {
            [tempCell updateCellUI:self];
        }
        
        if (isNeedCacheSubviewsFrame) {
            if ([tempCell respondsToSelector:@selector(cacheSubviewsFrameBySetLayoutWithCellModel:)]) {
                [tempCell cacheSubviewsFrameBySetLayoutWithCellModel:self];
            }
        }
        
        BOOL isUsehdSizeThatFits = [tempCell respondsToSelector:@selector(hdSizeThatFits:)] && !isForceUseAutoLayout;
        if (isUsehdSizeThatFits) {
            CGSize fitSize = self.cellSize;
            if ([tempCell respondsToSelector:@selector(hdSizeThatFits:)]) {
                fitSize = [tempCell hdSizeThatFits:CGSizeMake(self.cellSize.width, self.cellSize.height)];
            }
            if (fitSize.height>0 && fitSize.width>0) {
                self.cellSize = fitSize;
            }
        }else{
            if ([tempCell respondsToSelector:@selector(superAutoLayoutDefaultSet:)]) {
                [tempCell superAutoLayoutDefaultSet:self];
            }
            CGSize fitSize = [tempCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
            if (fitSize.height>0 && fitSize.width>0) {
                self.cellSize = fitSize;
            }
        }
        tempCell.contentView.frame = CGRectMake(0, 0, self.cellSize.width, self.cellSize.height);
        
        if (isNeedCacheSubviewsFrame) {
            NSLayoutConstraint *heightCons = [NSLayoutConstraint constraintWithItem:tempCell.contentView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:self.cellSize.height];
            heightCons.priority = UILayoutPriorityDefaultLow;
            [NSLayoutConstraint activateConstraints:@[heightCons]];
            if ([tempCell respondsToSelector:@selector(cacheSubviewsFrameBySetLayoutWithCellModel:)]) {
                [tempCell.contentView layoutIfNeeded];
                _subviewsFrame = [HDCellFrameCacheHelper copySubViewsFrame:tempCell];
            }
        }
    }
    return self.cellSize;
}

- (CGSize)calculateCellProperSizeWhenNoCache:(BOOL)isForceUseAutoLayout {
    if (self.isConvertedToVM && self.cellSize.width > 0 && self.cellSize.height > 0) {
        return self.cellSize;
    }
    return [self calculateCellProperSize :isForceUseAutoLayout];
}

- (CGSize)calculateCellProperSize:(BOOL)isNeedCacheSubviewsFrame forceUseAutoLayout:(BOOL)isForceUseAutoLayout {
    return [self calculateCellProperSize:isForceUseAutoLayout];
}

//取出当前类的所有property,然后去self.orgData中查找是否实现了对应的get方法，实现了则读取并赋值。
- (void)superDefaultConvertOrgModelToViewModel {
    NSMutableArray *allPropertyGetters = @[].mutableCopy;
    unsigned int propertyCount = 0;
    objc_property_t *properties = class_copyPropertyList([self class], &propertyCount);
    if (properties) {
        for (unsigned int i = 0; i < propertyCount; i++) {
            const char *name = property_getName(properties[i]);
            if (name) {
                [allPropertyGetters addObject:[NSString stringWithUTF8String:name]];
            }
        }
        free(properties);
    }
    
    [allPropertyGetters enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([self.orgData respondsToSelector:NSSelectorFromString(obj)] && [obj isKindOfClass:[NSString class]]) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
            [self setValue:[self.orgData performSelector:NSSelectorFromString(obj)] forKey:obj];
#pragma clang diagnostic pop
        }
    }];
}
@end



