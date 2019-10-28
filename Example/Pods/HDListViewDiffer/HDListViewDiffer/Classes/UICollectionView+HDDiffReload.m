//
//  UICollectionView+HDDiffReload.m
//  HDListViewDiffer_Example
//
//  Created by chenhaodong on 2019/10/18.
//  Copyright © 2019 chenhaodong. All rights reserved.
//

#import "UICollectionView+HDDiffReload.h"
#import <objc/runtime.h>
static char *HDListViewDifferKey;

@interface UICollectionView ()
@property (nonatomic, strong, readonly) HDListViewDiffer *hdDiffer;
@end

@implementation UICollectionView (HDDiffReload)
- (HDListViewDiffer *)hdDiffer
{
    HDListViewDiffer*  differ = objc_getAssociatedObject(self, &HDListViewDifferKey);
    if (!differ) {
        differ = [HDListViewDiffer new];
        objc_setAssociatedObject(self, &HDListViewDifferKey, differ, OBJC_ASSOCIATION_RETAIN);
    }
    return differ;
}

- (void)hd_reloadWithSection:(NSInteger)section
                oldData:(NSArray<id<HDListViewDifferProtocol>>*)oldArr
     newArrGenerateCode:(NSArray<id<HDListViewDifferProtocol>>*(^)(void))newArrGenerateCode
  calculateDiffFinishCb:(void(^)(void))calculateDiffFinishCb
   sourceDataChangeCode:(void(^)(NSArray<id<HDListViewDifferProtocol>>* newArr))sourceDataChangeCode
animationFinishCallback:(nullable void(^)(void))animationFinishCallback
{
    [self.hdDiffer setSection:section oldData:oldArr newArrGenerateCode:newArrGenerateCode finishCalback:calculateDiffFinishCb];
        
        if (self.hdDiffer.isExistEqualItemInOldOrNewArr) {
            
            if (sourceDataChangeCode) {
                sourceDataChangeCode(self.hdDiffer.afterArr);
            }
            [self reloadData];
            
            if (animationFinishCallback) {
                animationFinishCallback();
            }
        }else{

            [self performBatchUpdates:^{
                
                if (!sourceDataChangeCode) {
    #ifdef DEBUG
                    NSLog(@"数据源的变更必须放在此blcok内");
    #endif
                }else{
                    sourceDataChangeCode(self.hdDiffer.afterArr);
                }
                
                [self deleteItemsAtIndexPaths:self.hdDiffer.deletItems];
                [self insertItemsAtIndexPaths:self.hdDiffer.insertItems];
                [self reloadItemsAtIndexPaths:self.hdDiffer.updateItems];
                
                [self.hdDiffer.moveItems enumerateObjectsUsingBlock:^(HDCollectionViewUpdateItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    [self moveItemAtIndexPath:obj.indexPathBeforeUpdate toIndexPath:obj.indexPathAfterUpdate];
                }];
                
            } completion:^(BOOL finished) {
                if (animationFinishCallback) {
                    animationFinishCallback();
                }
            }];
        }

}


- (void)hd_reloadWithSection:(NSInteger)section
                oldData:(NSArray<id<HDListViewDifferProtocol>>*)oldArr
                newData:(NSArray<id<HDListViewDifferProtocol>>*)newArr
   sourceDataChangeCode:(void(^)(NSArray<id<HDListViewDifferProtocol>>* newArr))sourceDataChangeCode
animationFinishCallback:(nullable void(^)(void))animationFinishCallback
{
    NSArray<id<HDListViewDifferProtocol>> * (^newArrGenerate)(void) = ^(void){
        return newArr;
    };
    [self hd_reloadWithSection:section oldData:oldArr newArrGenerateCode:newArrGenerate calculateDiffFinishCb:nil sourceDataChangeCode:sourceDataChangeCode  animationFinishCallback:animationFinishCallback];
}

@end
