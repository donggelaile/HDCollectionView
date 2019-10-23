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

- (void)hd_reloadWithSection:(NSInteger)section oldData:(NSArray<id<HDListViewDifferProtocol>> *)oldArr newData:(NSArray<id<HDListViewDifferProtocol>> *)newArr sourceDataChangeCode:(void(^)(void))sourceDataChangeBlock dataChangeFinishCallback:(void(^)(void))dataChangeFinishCallback;
{
    [self.hdDiffer setSection:section oldData:oldArr newData:newArr finishCalback:dataChangeFinishCallback];
    
    if (self.hdDiffer.isExistEqualItemInOldOrNewArr) {
        
        if (sourceDataChangeBlock) {
            sourceDataChangeBlock();
        }
        [self reloadData];
        
        if (dataChangeFinishCallback) {
            dataChangeFinishCallback();
        }
    }else{

        [self performBatchUpdates:^{
            
            if (!sourceDataChangeBlock) {
#ifdef DEBUG
                NSLog(@"数据源的变更必须放在此blcok内");
#endif
            }else{
                sourceDataChangeBlock();
            }
            
            [self deleteItemsAtIndexPaths:self.hdDiffer.deletItems];
            [self insertItemsAtIndexPaths:self.hdDiffer.insertItems];
            [self reloadItemsAtIndexPaths:self.hdDiffer.updateItems];
            
            [self.hdDiffer.moveItems enumerateObjectsUsingBlock:^(HDCollectionViewUpdateItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                [self moveItemAtIndexPath:obj.indexPathBeforeUpdate toIndexPath:obj.indexPathAfterUpdate];
            }];
            
        } completion:^(BOOL finished) {
            if (dataChangeFinishCallback) {
                dataChangeFinishCallback();
            }
        }];
    }

}

@end
