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

@interface HDCellModel : NSObject<HDCellModelProtocol>
- (void)superDefaultConvertOrgModelToViewModel;
@end


