//
//  DemoVC6DecorationView.m
//  HDCollectionView
//
//  Created by HaoDong chen on 2019/4/18.
//  Copyright © 2019 CHD. All rights reserved.
//

#import "DemoVC6DecorationView.h"

@implementation DemoVC6DecorationView
- (void)updateSecVUI:(__kindof id<HDSectionModelProtocol>)model
{
    self.layer.cornerRadius = 5;
    self.layer.borderWidth = 1;
    if ([model.decorationObj isKindOfClass:[UIColor class]]) {
        self.layer.borderColor = [model.decorationObj CGColor];
    }
}
@end
