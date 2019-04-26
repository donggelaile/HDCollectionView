//
//  UIView+AroundLine.m
//  HDCollectionView
//
//  Created by HaoDong chen on 2019/4/21.
//  Copyright © 2019 CHD. All rights reserved.
//

#import "UIView+AroundLine.h"
#import <objc/runtime.h>
static char *HDAroundLineAdded = "HDAroundLineAdded";
@implementation UIView (AroundLine)
- (void)addAroundLine:(UIEdgeInsets)pixLines color:(UIColor*)color
{
    if (objc_getAssociatedObject(self, HDAroundLineAdded)) {
        return;
    }else{
        if (pixLines.left>0) {
            [self addLine:CGRectMake(0, 0, pixLines.left/[UIScreen mainScreen].scale, CGRectGetHeight(self.frame)) color:color];
        }
        if (pixLines.top>0) {
            [self addLine:CGRectMake(0, 0, CGRectGetWidth(self.frame), pixLines.top/[UIScreen mainScreen].scale) color:color];
        }
        if (pixLines.right>0) {
            [self addLine:CGRectMake(CGRectGetWidth(self.frame)-pixLines.right/[UIScreen mainScreen].scale, 0, pixLines.right/[UIScreen mainScreen].scale, CGRectGetHeight(self.frame)) color:color];
        }
        if (pixLines.bottom>0) {
            [self addLine:CGRectMake(0, CGRectGetHeight(self.frame)-pixLines.bottom/[UIScreen mainScreen].scale, CGRectGetWidth(self.frame), pixLines.bottom/[UIScreen mainScreen].scale) color:color];
        }
        objc_setAssociatedObject(self, HDAroundLineAdded, @(1), OBJC_ASSOCIATION_RETAIN);
    }
}
- (void)addLine:(CGRect)frame color:(UIColor*)color
{
    UIView *line = [[UIView alloc] initWithFrame:frame];
    line.backgroundColor = color;
    [self addSubview:line];
}
@end
