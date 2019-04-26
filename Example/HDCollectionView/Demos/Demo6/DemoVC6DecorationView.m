//
//  DemoVC6DecorationView.m
//  HDCollectionView
//
//  Created by HaoDong chen on 2019/4/18.
//  Copyright © 2019 CHD. All rights reserved.
//

#import "DemoVC6DecorationView.h"

@implementation DemoVC6DecorationView
- (void)updateSecVUI:(HDSectionModel *)model callback:(void (^)(id, HDCallBackType))callback
{
    self.layer.cornerRadius = 5;
    self.layer.borderColor = [model.decorationObj CGColor];
    self.layer.borderWidth = 1;
}
@end
