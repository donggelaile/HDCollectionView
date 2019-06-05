//
//  HDSectionView.m
//  
//
//  Created by CHD on 2018/8/9.
//  Copyright © 2018年 chd. All rights reserved.
//

#import "HDSectionView.h"
#import "HDCollectionView.h"
@interface HDSectionView()
@property (nonatomic, copy) void(^superCallback)(id par, HDCallBackType type);
@end

@implementation HDSectionView
@synthesize superCollectionV = _superCollectionV;
- (HDCollectionView *)superCollectionV
{
    if (!_superCollectionV) {
        UIView *view = self;
        while (view!=nil && ![view isKindOfClass:NSClassFromString(@"HDCollectionView")]) {
            view = view.superview;
        }
        _superCollectionV = (HDCollectionView*)view;
    }
    return _superCollectionV;
}
- (void)superUpdateSecVUI:(HDSectionModel *)model callback:(void (^)(id, HDCallBackType))callback
{
    self.superCallback = callback;
    __weak typeof(self) weakS = self;
    void(^selfCallback)(id) = ^(id par) {
        if (weakS && weakS.superCallback) {
            [weakS secViewCallback:par];
        }
    };
    [self setValue:selfCallback forKey:@"callback"];
    [self setValue:model forKey:@"hdSecModel"];
    
}
- (void)secViewCallback:(id)par
{
    HDCallBackType type = HDOtherCallBack;
    if ([self.currentElementKind isEqualToString:UICollectionElementKindSectionHeader]) {
        type = HDSectionHeaderCallBack;
    }else if ([self.currentElementKind isEqualToString:UICollectionElementKindSectionFooter]){
        type = HDSectionFooterCallBack;
    }else if ([self.currentElementKind isEqualToString:HDDecorationViewKind]){
        type = HDDecorationCallBack;
    }
    self.superCallback(par, type);
}
- (void)applyLayoutAttributes:(UICollectionViewLayoutAttributes *)layoutAttributes
{
    [super applyLayoutAttributes:layoutAttributes];
    if ([self.superCollectionV.collectionV.collectionViewLayout isKindOfClass:NSClassFromString(@"HDCollectionViewLayout")]) {
        //对于系统的UICollectionViewFlowLayout 设置后反而会引起视图层级混乱，原因未知
        self.layer.zPosition = layoutAttributes.zIndex;
    }
}
+(BOOL)accessInstanceVariablesDirectly{
    return YES;
}
@end
