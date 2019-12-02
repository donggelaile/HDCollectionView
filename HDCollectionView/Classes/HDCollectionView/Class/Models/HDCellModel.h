//
//  HDCellModel.h
//  
//
//  Created by CHD on 2018/8/9.
//  Copyright © 2018年 chd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "HDModelProtocol.h"
#import "HDDefines.h"
#import "HDListViewDiffer.h"

NS_ASSUME_NONNULL_BEGIN

@interface HDCellModelChainMaker : NSObject

/**
 原始数据Model
*/
@property (nonatomic, strong, readonly)  HDCellModelChainMaker* (^hd_orgData)(id _Nullable orgData);

/**
 默认CGSizeZero,优先级高于secM的cellSize。设置后优先使用该属性
*/
@property (nonatomic, strong, readonly)  HDCellModelChainMaker* (^hd_cellSize)(CGSize cellSize);

/**
 默认nil,优先级高于secM的sectionCellClassStr，设置后优先使用
*/
@property (nonatomic, strong, readonly)  HDCellModelChainMaker* (^hd_cellClassStr)(NSString* _Nullable cellClassStr);

/**
 仅在layout为HDYogaFlowLayout生效，cell外边距。用于单独控制某个cell与其他cell间的间距
 假设纵向滑动下，设置HDYogaFlowLayout的verticalGap为10，并设置第一个cellModel的margin = UIEdgeInsetsMake(0, 0, 20, 0);
 那么第一个cell与第二个cell的纵向间距将为20+10，其他cell纵向间距仍为10
*/
@property (nonatomic, strong, readonly)  HDCellModelChainMaker* (^hd_margain)(UIEdgeInsets margain);

/**
 默认为cellClassStr
*/
@property (nonatomic, strong, readonly)  HDCellModelChainMaker* (^hd_reuseIdentifier)(NSString* _Nullable reuseIdentifier);


/**
 一般不需要传，默认生成 HDCellModel 对象
 传的话，对应类必须遵循 HDCellModelProtocol协议
 */
@property (nonatomic, strong, readonly)  HDCellModelChainMaker* (^hd_diyCellModelClassStr)(NSString * _Nullable diyCellModelClassStr);

- (__kindof id<HDCellModelProtocol>)hd_generateObj;

@end

@interface HDCellModel : NSObject<HDCellModelProtocol,HDListViewDifferProtocol>
- (void)superDefaultConvertOrgModelToViewModel;
- (NSString *)hdDiffIdentifier;//这里暴露这个方法，子类自定义时可先调父类或完全自定义
@end
NS_ASSUME_NONNULL_END


