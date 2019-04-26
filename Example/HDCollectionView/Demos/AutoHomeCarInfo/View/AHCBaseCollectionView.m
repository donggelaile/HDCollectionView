//
//  AHCBaseCollectionView.m
//  HDCollectionView
//
//  Created by HaoDong chen on 2019/4/20.
//  Copyright © 2019 CHD. All rights reserved.
//

#import "AHCBaseCollectionView.h"
#import "HDSCVOffsetBinder.h"

@interface AHCBaseCollectionInnerView: UICollectionView

@end

@implementation AHCBaseCollectionInnerView
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
//    NSLog(@"%@",otherGestureRecognizer.view);
    return NO;
}
+ (BOOL)automaticallyNotifiesObserversForKey:(NSString *)key
{
    if ([key isEqualToString:@"contentOffset"]) {
        return NO;
    }else{
        return [super automaticallyNotifiesObserversForKey:key];
    }
}
- (void)dealloc
{
    
}
@end


@implementation AHCBaseCollectionView

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (!objc_getAssociatedObject(scrollView, HDContentOffsetIsNotNeedKVONotify)) {
        [scrollView willChangeValueForKey:@"contentOffset"];
    }
    if ([super respondsToSelector:@selector(scrollViewDidScroll:)]) {
        [super scrollViewDidScroll:scrollView];
    }
    if (!objc_getAssociatedObject(scrollView, HDContentOffsetIsNotNeedKVONotify)) {
        [scrollView didChangeValueForKey:@"contentOffset"];
    }
}

- (Class)HDInnerCollectionViewClass
{
    return [AHCBaseCollectionInnerView class];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
