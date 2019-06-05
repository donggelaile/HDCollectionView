//
//  DemoVC5DecorationView.m
//  HDCollectionView_Example
//
//  Created by HaoDong chen on 2019/6/2.
//  Copyright © 2019 donggelaile. All rights reserved.
//

#import "DemoVC5DecorationView.h"

@implementation DemoVC5DecorationView
- (void)updateSecVUI:(__kindof HDSectionModel *)model
{
    self.layer.cornerRadius = 5;
    self.layer.borderWidth = 1;
    if ([model.decorationObj isKindOfClass:[UIColor class]]) {
        self.layer.borderColor = [model.decorationObj CGColor];
    }
}
@end
