//
//  UIView+gesture.h
//
//  Created by CHD on 2018/5/8.
//  Copyright © 2018年 chd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (gesture)
- (void)setTapActionWithBlock:(void (^)(UITapGestureRecognizer*tap))block;
- (void)setLongPressActionWithBlock:(void (^)(UILongPressGestureRecognizer*longP))block;
@end
