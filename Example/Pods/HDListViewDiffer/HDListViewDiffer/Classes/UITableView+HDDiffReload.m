//
//  UITableView+HDDiffReload.m
//  HDListViewDiffer_Example
//
//  Created by chenhaodong on 2019/10/22.
//  Copyright © 2019 chenhaodong. All rights reserved.
//

#import "UITableView+HDDiffReload.h"
#import <objc/runtime.h>
static char *HDListViewDifferKey;

@interface UITableView ()
@property (nonatomic, strong, readonly) HDListViewDiffer *hdDiffer;
@end

@implementation UITableView (HDDiffReload)
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
                     oldData:(NSArray<id<HDListViewDifferProtocol>> *)oldArr
                     newData:(NSArray<id<HDListViewDifferProtocol>> *)newArr
                rowAnimation:(UITableViewRowAnimation)animation
        sourceDataChangeCode:(void(^)(void))sourceDataChangeBlock
    dataChangeFinishCallback:(void(^)(void))dataChangeFinishCallback;
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
        
        void(^changeAction)(void) = ^(){
                if (!sourceDataChangeBlock) {
#ifdef DEBUG
                    NSLog(@"数据源的变更必须放在此blcok内");
#endif
                }else{
                    sourceDataChangeBlock();
                }
                [self deleteRowsAtIndexPaths:self.hdDiffer.deletItems withRowAnimation:animation];
                [self insertRowsAtIndexPaths:self.hdDiffer.insertItems withRowAnimation:animation];
                [self reloadRowsAtIndexPaths:self.hdDiffer.updateItems withRowAnimation:animation];
                
                [self.hdDiffer.moveItems enumerateObjectsUsingBlock:^(HDCollectionViewUpdateItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    [self moveRowAtIndexPath:obj.indexPathBeforeUpdate toIndexPath:obj.indexPathAfterUpdate];
                }];
        };

        if (@available(iOS 11.0, *)) {
            [self performBatchUpdates:^{
                
                changeAction();
                
            } completion:^(BOOL finished) {
                if (dataChangeFinishCallback) {
                    dataChangeFinishCallback();
                }
            }];
        } else {
            // Fallback on earlier versions
            [self beginUpdates];
            changeAction();
            [self endUpdates];
            
            if (dataChangeFinishCallback) {
                dataChangeFinishCallback();
            }
            
        }
    }

}
@end
