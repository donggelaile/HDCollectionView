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
@interface HDCellModel : NSObject<HDCellModelProtocol,HDListViewDifferProtocol>
- (void)superDefaultConvertOrgModelToViewModel;
- (NSString *)hdDiffIdentifier;//这里暴露这个方法，子类自定义时可先调父类或完全自定义
@end
NS_ASSUME_NONNULL_END


