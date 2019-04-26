//
//  HDSCVOffsetBinder.m
//  HDCollectionView
//
//  Created by HaoDong chen on 2019/4/20.
//  Copyright © 2019 CHD. All rights reserved.
//

#import "HDSCVOffsetBinder.h"

static char *HDGroupObserverKey = "HDGroupObserverKey";
static NSString *HDContentOffset = @"contentOffset";

static void HDMethodSwizz(Class originalClass,SEL originalSelector, Class swizzledClass, SEL swizzledSelector){
    
    Method originalMethod = class_getInstanceMethod(originalClass, originalSelector);
    Method swizzledMethod = class_getInstanceMethod(swizzledClass, swizzledSelector);
    
    if (!originalMethod || !swizzledMethod) {
        return ;
    }
    
    IMP originalIMP = method_getImplementation(originalMethod);
    IMP swizzledIMP = method_getImplementation(swizzledMethod);
    const char *originalType = method_getTypeEncoding(originalMethod);
    const char *swizzledType = method_getTypeEncoding(swizzledMethod);
    //给原对象增加swizzledSelector方法,实现为originalIMP
    class_replaceMethod(originalClass,swizzledSelector,originalIMP,originalType);
    //替换originalSelector的实现为swizzledIMP
    class_replaceMethod(originalClass,originalSelector,swizzledIMP,swizzledType);
    
}

@implementation UIScrollView (HDSCVOffsetObserver)
- (void)setContentOffset:(CGPoint)contentOffset needKVONotify:(BOOL)isNotify
{
    if (isNotify) {
        objc_setAssociatedObject(self, HDContentOffsetIsNotNeedKVONotify, nil, OBJC_ASSOCIATION_RETAIN);
    }else{
        objc_setAssociatedObject(self, HDContentOffsetIsNotNeedKVONotify, @(YES), OBJC_ASSOCIATION_RETAIN);
    }
    self.contentOffset = contentOffset;
    //设置完后置nil
    objc_setAssociatedObject(self, HDContentOffsetIsNotNeedKVONotify, nil, OBJC_ASSOCIATION_RETAIN);
}
@end

@interface HDSCVOffsetObserver : NSObject
@property (nonatomic, assign) CGPoint currentOffset;
@property (nonatomic, strong) NSString *groupID;
@property (nonatomic, weak) UIScrollView *sc;
@end


@interface HDSCVOffsetBinder()
- (void)updateScOffset:(NSString*)groupID offset:(CGPoint)offset;
@end

@implementation HDSCVOffsetBinder
{
    NSMutableDictionary *allData;
}
- (NSMutableDictionary*)allData
{
    return allData;
}
+ (instancetype)shareInstance
{
    static dispatch_once_t onceToken;
    static HDSCVOffsetBinder *ins;
    dispatch_once(&onceToken, ^{
        ins = [super new];
        HDMethodSwizz([UIScrollView class], NSSelectorFromString(@"dealloc"), self, @selector(hd_dealloc));
    });
    return ins;
}
- (instancetype)init
{
    self = [super init];
    if (self) {
        allData = @{}.mutableCopy;
    }
    return self;
}
- (void)updateScOffset:(NSString*)groupID offset:(CGPoint)offset
{
    NSMapTable *groupMap = allData[groupID];
    allData[[groupID stringByAppendingString:HDContentOffset]] = [NSValue valueWithCGPoint:offset];
    
    [[[groupMap keyEnumerator] allObjects] enumerateObjectsUsingBlock:^(UIScrollView* obj, NSUInteger idx, BOOL * _Nonnull stop) {
        //调用obj.contentOffset = offset;会触发 scrollViewDidScroll，此处设置某个值然后在scrollViewDidScroll中判断是由用户滑动触发还是此处触发的。只有用户滑动触发的才需要发送KVO
        [obj setContentOffset:offset needKVONotify:NO];
        
        HDSCVOffsetObserver *obser = objc_getAssociatedObject(obj, HDGroupObserverKey);
        obser.currentOffset = offset;
        
    }];

}

- (void)bindScrollView:(UIScrollView *)scrollView groupID:(NSString *)groupID
{
    if (![scrollView isKindOfClass:[UIScrollView class]] || ![groupID isKindOfClass:[NSString class]]) {
        return;
    }
    Method methodAN = class_getInstanceMethod(object_getClass([scrollView class]), @selector(automaticallyNotifiesObserversForKey:));
    Method orgMehodAN = class_getInstanceMethod(object_getClass([UIScrollView class]), @selector(automaticallyNotifiesObserversForKey:));
    
    if (methodAN == orgMehodAN) {
        NSLog(@"继承自UIScrollView的类必须重载 +automaticallyNotifiesObserversForKey: 类方法,见HDSCVOffsetBinder.h");
        return;
    }
    if (![scrollView.delegate respondsToSelector:@selector(scrollViewDidScroll:)]) {
        NSLog(@"代理必须实现scrollViewDidScroll,见HDSCVOffsetBinder.h");
    }
    
    static dispatch_once_t onceToken;
    static dispatch_semaphore_t dis_lock;
    dispatch_once(&onceToken, ^{
        dis_lock = dispatch_semaphore_create(1);
    });
    
    dispatch_semaphore_wait(dis_lock, DISPATCH_TIME_FOREVER);
    
    void (^addScToGroupMap)(UIScrollView*,NSMapTable*) = ^(UIScrollView*sc,NSMapTable* groupMap){
        if (![groupMap objectForKey:sc]) {
            [groupMap setObject:groupID forKey:sc];
            
            HDSCVOffsetObserver *observer = objc_getAssociatedObject(sc, HDGroupObserverKey);
            if (!observer) {
                observer = [HDSCVOffsetObserver new];
                observer.sc = sc;
                observer.groupID = groupID;                
            }
            objc_setAssociatedObject(sc, HDGroupObserverKey, observer, OBJC_ASSOCIATION_RETAIN);
            [sc addObserver:observer forKeyPath:HDContentOffset options:NSKeyValueObservingOptionOld|NSKeyValueObservingOptionNew context:nil];
        }
    };
    
    NSMapTable *groupMap = allData[groupID];
    if (!groupMap) {
        groupMap = [NSMapTable mapTableWithKeyOptions:NSPointerFunctionsWeakMemory valueOptions:NSPointerFunctionsStrongMemory];
        addScToGroupMap(scrollView,groupMap);
        allData[groupID] = groupMap;
    }else{
        addScToGroupMap(scrollView,groupMap);
    }
    
    dispatch_semaphore_signal(dis_lock);
}
- (NSValue *)getCurrentOffsetByGroupID:(NSString *)groupID
{
    return allData[[groupID stringByAppendingString:HDContentOffset]];
}
- (BOOL)isAddScrollview:(UIScrollView*)sc
{
    __block BOOL isAdd = NO;
    [allData enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, NSMapTable* obj, BOOL * _Nonnull stop) {
        if ([obj objectForKey:sc]) {
            isAdd = YES;
            *stop = YES;
        }
    }];
    return isAdd;
}
- (HDSCVOffsetObserver*)observerForSc:(UIScrollView*)sc
{
    return objc_getAssociatedObject(sc, HDGroupObserverKey);
}
- (void)hd_dealloc
{
    HDSCVOffsetObserver *observer = [[HDSCVOffsetBinder shareInstance] observerForSc:(UIScrollView*)self];
    if (observer) {
        //这里的self是ScrollView
        //移除监听者
        [self removeObserver:observer forKeyPath:HDContentOffset];
        
        NSMapTable*groupMap = [[HDSCVOffsetBinder shareInstance] allData][observer.groupID];
        //当组中的所有sc都已经释放时
        if ([groupMap.keyEnumerator allObjects].count == 0) {
            
            //移除偏移量
            NSString *offsetKey = [observer.groupID stringByAppendingString:HDContentOffset];
            if (offsetKey) {
                [[[HDSCVOffsetBinder shareInstance] allData] removeObjectForKey:offsetKey];
            }
            //移除groupMap
            NSString *groupMapKey = observer.groupID;
            if (groupMapKey) {
                [[[HDSCVOffsetBinder shareInstance] allData] removeObjectForKey:groupMapKey];
            }
        }

    }

    [self hd_dealloc];
    
}

@end


@implementation HDSCVOffsetObserver
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    CGPoint newP = [change[NSKeyValueChangeNewKey] CGPointValue];
    [[HDSCVOffsetBinder shareInstance] updateScOffset:self.groupID offset:newP];
}
- (void)dealloc
{
    
}
@end
