//
//  UITableView+Structure.h

//
//  Created by chd on 2017/8/24.
//  Copyright © 2017年 chd. All rights reserved.
//  https://github.com/donggelaile/CHD_ListView_Structure

#import <UIKit/UIKit.h>

//switch
@interface CHD_ListView_Structure : NSObject
/**
 功能开关 
 
 @param isOpenT 是否开启TableV结构展示 (ShowOrNot TableView Strcuture)
 @param isOpenC 是否开启colletionV结构展示 (ShowOrNot CollectionView Strcuture)

 */
+ (void)openStructureShow_TableV:(BOOL)isOpenT collectionV:(BOOL)isOpenC;//只有开启了选项，Toggle才会生效。
@end





