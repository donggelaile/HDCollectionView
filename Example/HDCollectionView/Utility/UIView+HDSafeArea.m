//
//  UIView+HDSafeArea.m
//  HDCollectionView
//
//  Created by HaoDong chen on 2019/1/22.
//  Copyright © 2019 CHD. All rights reserved.
//

#import "UIView+HDSafeArea.h"

@implementation UIView (HDSafeArea)
- (MASViewAttribute *)hd_mas_left {
    if (@available(iOS 11.0, *)) {
        return [[MASViewAttribute alloc] initWithView:self item:self.safeAreaLayoutGuide layoutAttribute:NSLayoutAttributeLeft];
    } else {
        return [[MASViewAttribute alloc] initWithView:self layoutAttribute:NSLayoutAttributeLeft];
    }
}
- (MASViewAttribute *)hd_mas_right {
    if (@available(iOS 11.0, *)) {
        return [[MASViewAttribute alloc] initWithView:self item:self.safeAreaLayoutGuide layoutAttribute:NSLayoutAttributeRight];
    } else {
        return [[MASViewAttribute alloc] initWithView:self layoutAttribute:NSLayoutAttributeRight];
    }
}
- (MASViewAttribute *)hd_mas_top {
    if (@available(iOS 11.0, *)) {
        //当VC的系统导航未隐藏时，safeAreaLayoutGuideTop会包含导航
        return [[MASViewAttribute alloc] initWithView:self item:self.safeAreaLayoutGuide layoutAttribute:NSLayoutAttributeTop];
    } else {
        return [[MASViewAttribute alloc] initWithView:self layoutAttribute:NSLayoutAttributeTop];
    }
}
- (MASViewAttribute *)hd_mas_bottom {
    if (@available(iOS 11.0, *)) {
        return [[MASViewAttribute alloc] initWithView:self item:self.safeAreaLayoutGuide layoutAttribute:NSLayoutAttributeBottom];
    } else {
        return [[MASViewAttribute alloc] initWithView:self layoutAttribute:NSLayoutAttributeBottom];
    }
}
@end
