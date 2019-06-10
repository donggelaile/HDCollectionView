//
//  HDScrollJoinView.m
//  HDCollectionView_Example
//
//  Created by HaoDong chen on 2019/5/29.
//  Copyright © 2019 donggelaile. All rights reserved.
//

#import "HDScrollJoinView.h"
#import <objc/runtime.h>
static NSString *HDScrollJoinViewContentSize = @"contentSize";
static char *HDRelativeOriginalFrameKey;
static char *HDPrivateContentSizeKey;
static char *HDOriginalFrameKey;
static char *HDStopViewMaxXYKey;
@interface HDScrollJoinView()<UIScrollViewDelegate>
{
    CGPoint currentContentOffset;
    NSArray *currentStopViews;
}
@property (nonatomic, strong) NSMutableArray <id<HDScrollJoinViewRealScroll>> *innerListArr;
@property (nonatomic, assign) UICollectionViewScrollDirection scrollDirection;
@end
@implementation HDScrollJoinView

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.delegate = self;
    }
    return self;
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.delegate = self;
    }
    return self;
}
- (NSMutableArray<id<HDScrollJoinViewRealScroll>> *)innerListArr
{
    if (!_innerListArr) {
        _innerListArr = @[].mutableCopy;
    }
    return _innerListArr;
}

- (void)hd_setListViews:(NSArray<id<HDScrollJoinViewRealScroll>> *)listViews scrollDirection:(UICollectionViewScrollDirection)scrollDirection
{
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    [listViews enumerateObjectsUsingBlock:^(id<HDScrollJoinViewRealScroll>  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        BOOL isAdd = NO;
        if ([obj isKindOfClass:[UIView class]] &&
            [obj respondsToSelector:@selector(hd_ScrollJoinViewRealScroll)]&&
            [[obj hd_ScrollJoinViewRealScroll] isKindOfClass:[UIScrollView class]]) {
            
            UIScrollView *sc = [obj hd_ScrollJoinViewRealScroll];
            sc.showsVerticalScrollIndicator = NO;
            sc.showsHorizontalScrollIndicator = NO;
            sc.scrollEnabled = NO;
            [sc addObserver:self forKeyPath:HDScrollJoinViewContentSize options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:(__bridge void * _Nullable)(obj)];
            
            isAdd = YES;
        }else if ([obj isKindOfClass:[UIView class]] && [obj respondsToSelector:@selector(hd_subViewStopType)]){
            isAdd = YES;
        }

        if (isAdd) {
            [self .innerListArr addObject:obj];
            [self addSubview:(UIView*)obj];
            [self sendSubviewToBack:(UIView*)obj];
        }
    }];
    self.scrollDirection = scrollDirection;
    [self.superview layoutIfNeeded];
    [self hd_refreshAll];
}
- (void)hd_refreshAll
{
    CGFloat contentWidth = self.frame.size.width;
    CGFloat contentHeight = self.frame.size.height;
    
    __block CGFloat listContentWidthSum = 0;
    __block CGFloat listContentHeightSum = 0;
    
    __block CGFloat currentX = 0;
    __block CGFloat currentY = 0;
    //计算每个子view合适的大小及最终contentSize
    [self.innerListArr enumerateObjectsUsingBlock:^(id<HDScrollJoinViewRealScroll>  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIView *view = (UIView *)obj;
        CGSize hdSize = [objc_getAssociatedObject(obj, &HDPrivateContentSizeKey) CGSizeValue];
        if (CGSizeEqualToSize(CGSizeZero, hdSize)) {
            if ([obj respondsToSelector:@selector(hd_ScrollJoinViewRealScroll)]) {
                UIScrollView *sc = [obj hd_ScrollJoinViewRealScroll];
                hdSize = sc.contentSize;
            }else{
                hdSize = view.frame.size;
            }
        }
        if (self.scrollDirection == UICollectionViewScrollDirectionVertical) {
            
            CGFloat scFitH = hdSize.height>contentHeight?contentHeight:hdSize.height;
            view.frame = CGRectMake(currentX, currentY, contentWidth, scFitH);
            currentY = CGRectGetMaxY(view.frame);
            objc_setAssociatedObject(obj, &HDOriginalFrameKey, [NSValue valueWithCGRect:view.frame], OBJC_ASSOCIATION_RETAIN);
            
            //保存相对frame原始值
            CGRect orgFrame = view.frame;
            orgFrame.origin.y = listContentHeightSum;
            orgFrame.size.height = hdSize.height;
            objc_setAssociatedObject(obj, &HDRelativeOriginalFrameKey, [NSValue valueWithCGRect:orgFrame], OBJC_ASSOCIATION_RETAIN);

            listContentHeightSum += hdSize.height;
            
        }else{
            
            CGFloat scFitW = hdSize.width>contentWidth?contentWidth:hdSize.width;
            view.frame = CGRectMake(currentX, currentY, scFitW,contentHeight);
            currentX = CGRectGetMaxX(view.frame);
            objc_setAssociatedObject(obj, &HDOriginalFrameKey, [NSValue valueWithCGRect:view.frame], OBJC_ASSOCIATION_RETAIN);
            
            CGRect orgFrame = view.frame;
            orgFrame.origin.x = listContentWidthSum;
            orgFrame.size.width = hdSize.width;
            objc_setAssociatedObject(obj, &HDRelativeOriginalFrameKey, [NSValue valueWithCGRect:orgFrame], OBJC_ASSOCIATION_RETAIN);
            
            listContentWidthSum += hdSize.width;
        }
    }];
    [self.innerListArr enumerateObjectsUsingBlock:^(id<HDScrollJoinViewRealScroll>  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIView *view = (UIView *)obj;
        if ([obj respondsToSelector:@selector(hd_subViewStopType)]) {
            if ([obj hd_subViewStopType] == HDScrollJoinViewStopTypeWhenNextDismiss) {
                //如果当前view悬停类型为HDScrollJoinViewStopTypeWhenNextDismiss时需要保存 其MAXY
                NSInteger nextIndex = idx + 1;
                CGFloat maxXY = 0;
                if (nextIndex>0 && nextIndex < self.innerListArr.count) {
                    UIView *nextView = (UIView*)self.innerListArr[nextIndex];
                    CGRect nextOrgFrame = [objc_getAssociatedObject(nextView, &HDRelativeOriginalFrameKey) CGRectValue];
                    if (self.scrollDirection == UICollectionViewScrollDirectionVertical) {
                        maxXY = CGRectGetMaxY(nextOrgFrame) - view.frame.size.height;
                        objc_setAssociatedObject(view, &HDStopViewMaxXYKey, @(maxXY), OBJC_ASSOCIATION_RETAIN);
                    }else{
                        maxXY = CGRectGetMaxX(nextOrgFrame) - view.frame.size.width;
                        objc_setAssociatedObject(view, &HDStopViewMaxXYKey, @(maxXY), OBJC_ASSOCIATION_RETAIN);
                    }
                }
            }
        }
    }];
    
    if (self.scrollDirection == UICollectionViewScrollDirectionVertical) {
        contentHeight = MAX(contentHeight, listContentHeightSum);
    }else{
        contentWidth = MAX(contentWidth, listContentWidthSum);
    }
    self.contentSize = CGSizeMake(contentWidth, contentHeight);
    [self scrollViewDidScroll:self];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    currentContentOffset = self.contentOffset;
    id<HDScrollJoinViewRealScroll> subMainview = [self findCurrentScrollingSubView];
    if (subMainview) {
        [self updateCurrentSc:subMainview];
    }
}
- (id<HDScrollJoinViewRealScroll>)findCurrentScrollingSubView
{
    //查找当前正在滑动展示哪个view
    CGFloat offsetXY = 0;
    if (self.scrollDirection == UICollectionViewScrollDirectionVertical) {
        offsetXY = currentContentOffset.y;
    }else{
        offsetXY = currentContentOffset.x;
    }
    __block id<HDScrollJoinViewRealScroll> currentView;
    //从前往后依次查找
    __block CGFloat offsetSum = 0;
    [self.innerListArr enumerateObjectsUsingBlock:^(id<HDScrollJoinViewRealScroll>  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        CGSize fitSize = CGSizeZero;
        if ([obj respondsToSelector:@selector(hd_ScrollJoinViewRealScroll)]) {
            UIScrollView *sc = [obj hd_ScrollJoinViewRealScroll];
            fitSize = sc.contentSize;
        }else{
            fitSize = [(UIView*)obj frame].size;
        }
        
        if (self.scrollDirection == UICollectionViewScrollDirectionVertical) {
            offsetSum += fitSize.height;
            if (offsetXY < offsetSum ) {
                currentView = obj;
                *stop = YES;
            }
            
        }else{
            offsetSum += fitSize.width;
            if (offsetXY < offsetSum) {
                currentView = obj;
                *stop = YES;
            }
        }
    }];
    return currentView;
}
- (void)updateCurrentSc:(id<HDScrollJoinViewRealScroll>)subMainView
{
    if (!subMainView) {
        return;
    }
    [self updateStopViewsFrame:subMainView];
    
    UIView *view = (UIView *)subMainView;
    if ([subMainView respondsToSelector:@selector(hd_ScrollJoinViewRealScroll)]) {
        UIScrollView *currentSc = [subMainView hd_ScrollJoinViewRealScroll];
        CGFloat frameX = 0;
        CGFloat frameY = 0;
        CGFloat contentX = 0;
        CGFloat contentY = 0;
        
        CGRect frame = [objc_getAssociatedObject(view, &HDOriginalFrameKey) CGRectValue];
        
        if (self.scrollDirection == UICollectionViewScrollDirectionVertical) {
            CGRect relativeFrame = [objc_getAssociatedObject(view, &HDRelativeOriginalFrameKey) CGRectValue];
            contentY = currentContentOffset.y - relativeFrame.origin.y;
            //判断当前滑动view是否已经滑到底部
            CGFloat maxContentY = currentSc.contentSize.height - frame.size.height;
            if (contentY >= maxContentY) {
                frameY = CGRectGetMaxY(relativeFrame) - frame.size.height;
                contentY = maxContentY;
            }else{
                frameY = currentContentOffset.y;
            }
        }else{
            CGRect relativeFrame = [objc_getAssociatedObject(view, &HDRelativeOriginalFrameKey) CGRectValue];
            contentX = currentContentOffset.x - relativeFrame.origin.x;
            CGFloat maxContentX = currentSc.contentSize.width - frame.size.width;
            if (contentX >= maxContentX) {
                frameX = CGRectGetMaxX(relativeFrame) - frame.size.width;
                contentX = maxContentX;
            }else{
                frameX = currentContentOffset.x;
            }
        }
        view.frame = CGRectMake(frameX, frameY, view.frame.size.width, view.frame.size.height);
        currentSc.contentOffset = CGPointMake(contentX, contentY);
    }
    
    NSInteger curIndex = [self.innerListArr indexOfObject:subMainView];
    
    //其后的view保持在上个view的最 下/右 面
    UIView *frontView = (UIView *)subMainView;
    if (curIndex != NSNotFound) {
        for (NSInteger i = curIndex+1; i < self.innerListArr.count; i++) {
            UIView *behindView = (UIView*)self.innerListArr[i];
            CGRect frame = [objc_getAssociatedObject(behindView, &HDOriginalFrameKey) CGRectValue];
            if (![behindView respondsToSelector:@selector(hd_subViewStopType)]) {
                if (self.scrollDirection == UICollectionViewScrollDirectionVertical) {
                    frame.origin.y = CGRectGetMaxY([objc_getAssociatedObject(frontView, &HDRelativeOriginalFrameKey) CGRectValue]);
                }else{
                    frame.origin.x = CGRectGetMaxX([objc_getAssociatedObject(frontView, &HDRelativeOriginalFrameKey) CGRectValue]);
                }
                behindView.frame = frame;
            }
            if ([behindView respondsToSelector:@selector(hd_ScrollJoinViewRealScroll)]) {
                UIScrollView *sc = [(id<HDScrollJoinViewRealScroll>)behindView hd_ScrollJoinViewRealScroll];
                sc.contentOffset = CGPointZero;
            }
            frontView = behindView;
        }
    }
    
}
- (void)updateStopViewsFrame:(id<HDScrollJoinViewRealScroll>)currentScView
{
    //找到所有需要悬停的view
    NSMutableArray *needStopViewArr = @[].mutableCopy;
    NSInteger currentScIndex = [self.innerListArr indexOfObject:currentScView];
    __block NSInteger maxCurrentVisualVIndex = 0;
    if (currentScIndex != NSNotFound) {
        maxCurrentVisualVIndex = currentScIndex;
    }
    
    CGRect currentVisualRect = self.bounds;
    
    [self.innerListArr enumerateObjectsUsingBlock:^(id<HDScrollJoinViewRealScroll>  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        CGRect reOrgFrame = [objc_getAssociatedObject(obj, &HDRelativeOriginalFrameKey) CGRectValue];
        if (CGRectIntersectsRect(currentVisualRect,reOrgFrame)) {
            if (idx>maxCurrentVisualVIndex) {
                maxCurrentVisualVIndex = idx;
            }
        }
    }];

    [self.innerListArr enumerateObjectsUsingBlock:^(id<HDScrollJoinViewRealScroll>  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj respondsToSelector:@selector(hd_subViewStopType)]) {
            [needStopViewArr addObject:obj];
        }
        if (idx == maxCurrentVisualVIndex) {
            *stop = YES;
        }
    }];
    
    __block CGFloat currentOffset = 0;
    [needStopViewArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIView *stopView = (UIView*)obj;
        HDScrollJoinViewStopType stopType = [obj hd_subViewStopType];
        CGRect frame = [objc_getAssociatedObject(stopView, &HDOriginalFrameKey) CGRectValue];
        
        if (self.scrollDirection == UICollectionViewScrollDirectionVertical) {
            CGFloat orgMinXY = CGRectGetMinY([objc_getAssociatedObject(stopView, &HDRelativeOriginalFrameKey) CGRectValue]);
            if (stopType == HDScrollJoinViewStopTypeAlways) {
                frame.origin.y = MAX(self->currentContentOffset.y + currentOffset, orgMinXY);
                stopView.frame = frame;
                currentOffset += frame.size.height;
            }else if (stopType == HDScrollJoinViewStopTypeWhenNextDismiss){
                CGFloat orgMaxXY = [objc_getAssociatedObject(stopView, &HDStopViewMaxXYKey) floatValue];
                CGFloat maxY = MAX(self->currentContentOffset.y + currentOffset, orgMinXY);
                frame.origin.y = MIN(orgMaxXY, maxY);
                stopView.frame = frame;
            }
        }else{
            CGFloat orgMinXY = CGRectGetMinX([objc_getAssociatedObject(stopView, &HDRelativeOriginalFrameKey) CGRectValue]);
            if (stopType == HDScrollJoinViewStopTypeAlways) {
                frame.origin.x = MAX(self->currentContentOffset.x + currentOffset, orgMinXY);
                stopView.frame = frame;
                currentOffset += frame.size.width;
            }else if (stopType == HDScrollJoinViewStopTypeWhenNextDismiss){
                CGFloat orgMaxXY = [objc_getAssociatedObject(stopView, &HDStopViewMaxXYKey) floatValue];
                CGFloat maxX = MAX(self->currentContentOffset.x + currentOffset, orgMinXY);
                frame.origin.x = MIN(orgMaxXY, maxX);
                stopView.frame = frame;
            }
        }
        

    }];
    currentStopViews = needStopViewArr;

}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:HDScrollJoinViewContentSize]) {
        id<HDScrollJoinViewRealScroll> mainSubView = (__bridge id<HDScrollJoinViewRealScroll>)(context);
        CGSize oldSize = [objc_getAssociatedObject((__bridge id _Nonnull)(context), &HDPrivateContentSizeKey) CGSizeValue];
        __block CGSize newSize = [change[NSKeyValueChangeNewKey] CGSizeValue];
        
        if ([mainSubView respondsToSelector:@selector(hd_properContentSize:)]) {
            [mainSubView hd_properContentSize:^(CGSize properSize) {
                newSize = properSize;
                if (!CGSizeEqualToSize(oldSize, newSize)) {
                    objc_setAssociatedObject((__bridge id _Nonnull)(context), &HDPrivateContentSizeKey, [NSValue valueWithCGSize:newSize], OBJC_ASSOCIATION_RETAIN);
                    [self hd_refreshAll];
                }
            }];
        }else{
            if (!CGSizeEqualToSize(oldSize, newSize)) {
                objc_setAssociatedObject((__bridge id _Nonnull)(context), &HDPrivateContentSizeKey, [NSValue valueWithCGSize:newSize], OBJC_ASSOCIATION_RETAIN);
                [self hd_refreshAll];
            }
        }
        
    } else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}
- (void)dealloc
{
    [self.innerListArr enumerateObjectsUsingBlock:^(id<HDScrollJoinViewRealScroll>  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj respondsToSelector:@selector(hd_ScrollJoinViewRealScroll)]) {
            UIScrollView *sc = [obj hd_ScrollJoinViewRealScroll];
            [sc removeObserver:self forKeyPath:HDScrollJoinViewContentSize];
        }
    }];
}
@end
