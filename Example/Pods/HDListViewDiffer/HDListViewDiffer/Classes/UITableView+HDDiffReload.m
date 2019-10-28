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
                oldData:(NSArray<id<HDListViewDifferProtocol>>*)oldArr
           rowAnimation:(UITableViewRowAnimation)animation
     newArrGenerateCode:(NSArray<id<HDListViewDifferProtocol>>*(^)(void))newArrGenerateCode
  calculateDiffFinishCb:(nullable void(^)(void))calculateDiffFinishCb
   sourceDataChangeCode:(void(^)(NSArray<id<HDListViewDifferProtocol>>* newArr))sourceDataChangeCode
animationFinishCallback:(nullable void(^)(void))animationFinishCallback
{
//        [self.hdDiffer setSection:section oldData:oldArr newData:newArr modelsIdChangeCode:idChangeCode finishCalback:dataChangeFinishCallback];
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
            
            void(^changeAction)(void) = ^(){
                    if (!sourceDataChangeCode) {
    #ifdef DEBUG
                        NSLog(@"数据源的变更必须放在此blcok内");
    #endif
                    }else{
                        sourceDataChangeCode(self.hdDiffer.afterArr);
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
                    if (animationFinishCallback) {
                        animationFinishCallback();
                    }
                }];
            } else {
                // Fallback on earlier versions
                [self beginUpdates];
                changeAction();
                [self endUpdates];
                
                if (animationFinishCallback) {
                    animationFinishCallback();//这块时间上可能不太准确
                }
                
            }
        }

}
- (void)hd_reloadWithSection:(NSInteger)section
                 oldData:(NSArray<id<HDListViewDifferProtocol>>*)oldArr
                 newData:(NSArray<id<HDListViewDifferProtocol>>*)newArr
            rowAnimation:(UITableViewRowAnimation)animation
    sourceDataChangeCode:(void(^)(NSArray<id<HDListViewDifferProtocol>>* newArr))sourceDataChangeCode
animationFinishCallback:(nullable void(^)(void))animationFinishCallback
{
    NSArray<id<HDListViewDifferProtocol>> * (^newArrGenerate)(void) = ^(void){
        return newArr;
    };
    [self hd_reloadWithSection:section oldData:oldArr rowAnimation:animation newArrGenerateCode:newArrGenerate calculateDiffFinishCb:nil sourceDataChangeCode:sourceDataChangeCode animationFinishCallback:animationFinishCallback];
}
@end
