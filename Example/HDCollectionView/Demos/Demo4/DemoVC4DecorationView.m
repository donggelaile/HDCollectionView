//
//  DemoVC4DecorationView.m
//  HDCollectionView_Example
//
//  Created by chenhaodong on 2019/10/23.
//  Copyright © 2019 donggelaile. All rights reserved.
//

#import "DemoVC4DecorationView.h"

@implementation DemoVC4DecorationView
- (void)updateSecVUI:(__kindof id<HDSectionModelProtocol>)model
{
    self.layer.cornerRadius = 5;
    self.layer.borderWidth = 1;
    if ([model.decorationObj isKindOfClass:[UIColor class]]) {
        self.layer.borderColor = [model.decorationObj CGColor];
    }
}
@end
