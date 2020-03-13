//
//  DemoVC3CellVM.m
//  HDCollectionView_Example
//
//  Created by chenhaodong on 2020/3/13.
//  Copyright © 2020 donggelaile. All rights reserved.
//

#import "DemoVC3CellVM.h"
#import "DemoVC3CellModel.h"
#import "NSAttributedString+SJMake.h"

@implementation DemoVC3CellVM

// 在更新UI前，内部会自动调用该函数，并且只调用一次
- (void)convertOrgModelToViewModel
{
    if ([self.orgData isKindOfClass:DemoVC3CellModel.class]) {
        [self convertModel1];
    }
//    else if ([self.orgData isKindOfClass:SomeNewServerModel.class]){
//       //当服务器返回另一种数据格式时在此处适配
//       [self convertModel2];
//    }
}
- (void)convertModel1
{
    DemoVC3CellModel *orgModel = self.orgData;
    self.title = [NSAttributedString sj_UIKitText:^(id<SJUIKitTextMakerProtocol>  _Nonnull make) {
         make.append(orgModel.title).textColor([UIColor blackColor]).font([UIFont systemFontOfSize:18]).lineSpacing(3);
    }];
    
    self.detail = [NSAttributedString sj_UIKitText:^(id<SJUIKitTextMakerProtocol>  _Nonnull make) {
        make.append(orgModel.detail).textColor([UIColor grayColor]).font([UIFont systemFontOfSize:16]).lineSpacing(3).alignment(NSTextAlignmentJustified);
    }];
    self.leftText = [NSAttributedString sj_UIKitText:^(id<SJUIKitTextMakerProtocol>  _Nonnull make) {
        make.append(orgModel.leftText).textColor([UIColor lightGrayColor]).font([UIFont systemFontOfSize:14]);
    }];
    self.rightText = [NSAttributedString sj_UIKitText:^(id<SJUIKitTextMakerProtocol>  _Nonnull make) {
        make.append(orgModel.rightText).textColor([UIColor cyanColor]).font([UIFont systemFontOfSize:14]).lineBreakMode(NSLineBreakByTruncatingTail);
    }];
    if (orgModel.imageUrl) {
        self.imageUrl = [NSURL URLWithString:orgModel.imageUrl];
    }
}
//- (void)convertModel2
//{
//
//}
@end
