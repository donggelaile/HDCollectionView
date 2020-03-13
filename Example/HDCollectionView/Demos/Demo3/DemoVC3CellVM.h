//
//  DemoVC3CellVM.h
//  HDCollectionView_Example
//
//  Created by chenhaodong on 2020/3/13.
//  Copyright © 2020 donggelaile. All rights reserved.
//

#import <HDCollectionView/HDCollectionView.h>

NS_ASSUME_NONNULL_BEGIN
//所有的label样式都用NSAttributedString来展示
/*这样有两个好处
 1、DemoVC3CellVM存在的意义更大，不仅仅是对原始数据格式的包装，也包装了label样式
 2、label样式更加灵活，比如轻松调整字间距，行间距等
 此外，使用cellViewModel来展示cell 的UI，后期还更容易适配更多原始model。
 */
@interface DemoVC3CellVM : HDCellModel
@property (nonatomic, strong) NSAttributedString *title;
@property (nonatomic, strong) NSAttributedString *detail;
@property (nonatomic, strong) NSAttributedString *leftText;
@property (nonatomic, strong) NSAttributedString *rightText;
@property (nonatomic, strong) NSURL *imageUrl;
@property (nonatomic, strong) NSString *someID;//跳转详情时可能使用
@end

NS_ASSUME_NONNULL_END
