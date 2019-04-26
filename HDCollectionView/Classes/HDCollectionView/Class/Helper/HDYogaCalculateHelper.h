//
//  HDYogaCaculateHelper.h
//  yogaKitTableViewDemo
//
//  Created by HaoDong chen on 2019/4/3.
//  Copyright © 2019 chd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YGEnums.h"
#import <UIKit/UIKit.h>

static NSString *const HDYogaItemTypeKey = @"HDYogaItemTypeKey";
static NSString *const HDYogaItemPointKey = @"HDYogaItemPointKey";
static NSString *const HDYogaOrgSizeKey = @"HDYogaOrgSizeKey";

static NSString *const HDFinalDecorationFrmaeKey = @"HDFinalDecorationFrmaeKey";
static NSString *const HDFinalOtherInfoArrKey = @"HDFinalOtherInfoArrKey";

typedef NS_ENUM(NSInteger) {
    HDFlexDirectionRow,
    HDFlexDirectionColumn
}HDFlexDirection;

//******************************************item****************************************** begin
@protocol HDYogaItemProtocol <NSObject>
/**
 item 大小 默认 CGSizeZero  该参数必须配置
 */
@property (nonatomic, assign) CGSize size;
/**
 item 外边距 默认 UIEdgeInsetZero
 */
@property (nonatomic, assign) UIEdgeInsets margin;

/**
 item 对齐方式 默认 YGAlignFlexStart
 */
@property (nonatomic, assign) YGAlign alignSelf;

@property (nonatomic, copy) NSString *itemType;
@end
//******************************************item****************************************** end


//******************************************section****************************************** begin
@protocol HDYogaSecProtocol <NSObject>


/**
 父view大小 默认CGSizeZero 该参数必须配置
 */
@property (nonatomic, assign) CGSize superViewSize;

/**
 纵向间距
 */
@property (nonatomic, assign) CGFloat verticalGap;

/**
 横向间距
 */
@property (nonatomic, assign) CGFloat horizontalGap;
/**
 滑动方向 默认 UICollectionViewScrollDirectionVertical
 */
@property (nonatomic, assign) UICollectionViewScrollDirection scrollDirection;

/**
 整段的内边距,不包含header,footer 默认 UIEdgeInsetZero
 */
@property (nonatomic, assign) UIEdgeInsets secInset;

/**
 装饰view的外边距
 */
@property (nonatomic, assign) UIEdgeInsets decorationInset;

/**
 主轴方向 默认 YGFlexDirectionColumn
 */
@property (nonatomic, assign) YGFlexDirection flexDirection;

/**
 主轴对齐方式 默认 YGJustifyFlexStart
 */
@property (nonatomic, assign) YGJustify justify;

/**
 设置侧轴的对齐方式 默认 YGAlignFlexStart
 */
@property (nonatomic, assign) YGAlign align;

/**
 每段内部cell/header/footer的配置
 */
@property (nonatomic, strong) NSMutableArray<id<HDYogaItemProtocol>> *itemLayoutConfigArr;
@end
//******************************************section****************************************** end

NS_ASSUME_NONNULL_BEGIN

@interface HDYogaCalculateHelper : NSObject
+ (NSMutableDictionary*)getSubViewsFrameWithHDYogaSec:(id<HDYogaSecProtocol>)sec;
@end

NS_ASSUME_NONNULL_END
