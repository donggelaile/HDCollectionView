//
//  UIView+HDSafeArea.h
//  HDCollectionView
//
//  Created by HaoDong chen on 2019/1/22.
//  Copyright © 2019 CHD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Masonry.h"
@interface UIView (HDSafeArea)
@property (nonatomic, strong, readonly) MASViewAttribute *hd_mas_left;
@property (nonatomic, strong, readonly) MASViewAttribute *hd_mas_top;
@property (nonatomic, strong, readonly) MASViewAttribute *hd_mas_right;
@property (nonatomic, strong, readonly) MASViewAttribute *hd_mas_bottom;
@end
