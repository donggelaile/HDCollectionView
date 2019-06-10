//
//  UITableView+Structure.m
//
//
//  Created by chd on 2017/8/24.
//  Copyright © 2017年 chd. All rights reserved.
//  https://github.com/donggelaile/CHD_ListView_Structure

#import "CHD_ListView_Structure.h"
#import <objc/runtime.h>



//Switch
@interface CHD_SwitchView : UIButton

@end

//HookHelper
@interface CHD_HookHelper : NSObject
@property (nonatomic, assign) BOOL is_open_chdTable;
@property (nonatomic, assign) BOOL is_open_chdCollection;
@property (nonatomic, retain) NSMapTable *weakListViewDic;
+ (instancetype)shareInstance;
- (void)hookSelectors:(NSArray *)selArr orginalObj:(id)oriObj swizzedObj:(id)newObj;
- (void)resetCHD_HoverView;
@end


//MustrHelper
@interface CHD_MustrHelper : NSObject
@end


//Hover
@interface CHD_HoverLabel : UILabel
@property (nonatomic, retain)UIColor *borderColor;
@end

@interface UIView (CHD_HoverView)
@end



//UITableView
@interface UITableView (CHD_Structure)
@end

@interface CHD_TableHelper : NSObject
@end



//UICollectionView
@interface UICollectionView (CHD_Structure)
@end

@interface CHD_CollectionHelper : NSObject
@end





#define chd_table_head_view_color [UIColor magentaColor]
#define chd_table_cell_color [UIColor redColor]
#define chd_table_header_color [UIColor blueColor]
#define chd_table_footer_color [UIColor greenColor]
#define chd_text_bg_alpha 0.7
#define chd_table_text_color [UIColor whiteColor]
#define chd_table_footer_view_color [UIColor blackColor]


#define chd_collection_cell_color [UIColor orangeColor]
#define chd_collection_header_color [UIColor purpleColor]
#define chd_collection_footer_color [UIColor cyanColor]
#define chd_collection_decoration_color [UIColor blackColor]
#define chd_collection_bg_alpha 1
#define chd_collection_text_color [UIColor whiteColor]


static NSString *const CHD_MapTable_Obj = @"CHD_MapTable_Obj";


BOOL __CHD_Instance_Transition_Swizzle(Class originalClass,SEL originalSelector, Class swizzledClass, SEL swizzledSelector){
#ifdef DEBUG

    Method originalMethod = class_getInstanceMethod(originalClass, originalSelector);
    Method swizzledMethod = class_getInstanceMethod(swizzledClass, swizzledSelector);
    
    if (!originalMethod) {
        //如果原对象原方法未实现，查看交换类是否帮其实现了原类方法
        Method tempM = class_getInstanceMethod(swizzledClass, originalSelector);
        if (tempM) {
            //给原对象增加原方法
            class_addMethod(originalClass, originalSelector, method_getImplementation(tempM), method_getTypeEncoding(tempM));
            //更新原对象实现
            originalMethod = class_getInstanceMethod(originalClass, originalSelector);
        }
    }
    
    if (!originalMethod || !swizzledMethod) {
        return NO;
    }
    
    IMP originalIMP = method_getImplementation(originalMethod);
    IMP swizzledIMP = method_getImplementation(swizzledMethod);
    const char *originalType = method_getTypeEncoding(originalMethod);
    const char *swizzledType = method_getTypeEncoding(swizzledMethod);
    //给原对象增加swizzledSelector方法,实现为originalIMP
    class_replaceMethod(originalClass,swizzledSelector,originalIMP,originalType);
    //替换originalSelector的实现为swizzledIMP
    class_replaceMethod(originalClass,originalSelector,swizzledIMP,swizzledType);
    return YES;
#else
    return NO;
#endif

}

@implementation CHD_SwitchView
- (instancetype)initWithFrame:(CGRect)frame
{
    if ([super initWithFrame:frame]) {
        UIPanGestureRecognizer* pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(handelPan:)];
        [self addGestureRecognizer:pan];
        
        self.alpha = 1;
    }
    return self;
}
- (void)handelPan:(UIPanGestureRecognizer*)gestureRecognizer
{
    if (gestureRecognizer.state == UIGestureRecognizerStateBegan) {
        [UIView animateWithDuration:0.3 animations:^{
            gestureRecognizer.view.alpha = 1;
        }];
    }
    if (gestureRecognizer.state == UIGestureRecognizerStateEnded) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [UIView animateWithDuration:1 animations:^{
                gestureRecognizer.view.alpha = 0.5;
            }];
        });
    }
    CGPoint center = [gestureRecognizer locationInView:self.superview];
    
    CGFloat minX = CGRectGetWidth(self.frame)/2.0;
    CGFloat maxX = [UIScreen mainScreen].bounds.size.width - minX;
    CGFloat minY = CGRectGetHeight(self.frame)/2.0;
    CGFloat maxY = [UIScreen mainScreen].bounds.size.height - minY;
    
    if (center.x<minX) {
        center = CGPointMake(minX, center.y);
    }
    if (center.y<minY) {
        center = CGPointMake(center.x, minY);
    }
    if (center.x>maxX) {
        center = CGPointMake(maxX, center.y);
    }
    if (center.y>maxY) {
        center = CGPointMake(center.x, maxY);
    }
    
    self.center = center;
}


@end



#pragma mark - CHD_ListView_Structure

@implementation CHD_ListView_Structure

+(void)openStructureShow_TableV:(BOOL)isOpenT collectionV:(BOOL)isOpenC
{
#ifdef DEBUG
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [CHD_HookHelper shareInstance].is_open_chdTable = isOpenT;
        [CHD_HookHelper shareInstance].is_open_chdCollection = isOpenC;
        
        [CHD_ListView_Structure hookTable];
        [CHD_ListView_Structure hookCollection];
        
        [CHD_ListView_Structure addToggleView];
    });
#endif
}
+ (void)addToggleView
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        UIWindow *window = [[[UIApplication sharedApplication] delegate] window];
        CGFloat btnW = 50.0f;
        CHD_SwitchView *btn = [[CHD_SwitchView alloc] initWithFrame:CGRectMake(0, 50, btnW, btnW)];
        [btn setTitle:@"Toggle" forState:UIControlStateNormal];
        btn.layer.cornerRadius = btnW/2.0f;
        btn.backgroundColor = [UIColor orangeColor];
        btn.titleLabel.font = [UIFont systemFontOfSize:14.0f];
        
        UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapGesture)];
        [btn addGestureRecognizer:tap];
        [window addSubview:btn];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [window bringSubviewToFront:btn];
        });
    });
}
+ (void)hookTable
{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
    __CHD_Instance_Transition_Swizzle([UITableView class], @selector(setDelegate:), [UITableView class],@selector(CHD_setDelegate:));
    __CHD_Instance_Transition_Swizzle([UITableView class], @selector(setDataSource:), [UITableView class],@selector(CHD_setDataSource:));
    NSArray *selArr = @[@"setTableFooterView:",@"setTableHeaderView:"];
    [[CHD_HookHelper shareInstance] hookSelectors:selArr orginalObj:[UITableView new] swizzedObj:[CHD_TableHelper class]];
#pragma clang diagnostic pop
    
}
+ (void)hookCollection
{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
    __CHD_Instance_Transition_Swizzle([UICollectionView class], @selector(setDelegate:), [UICollectionView class], @selector(CHD_setDelegate:));
    __CHD_Instance_Transition_Swizzle([UICollectionView class], @selector(setDataSource:), [UICollectionView class], @selector(CHD_setDataSource:));
#pragma clang diagnostic pop
}

+ (void)tapGesture
{
    [CHD_HookHelper shareInstance].is_open_chdTable = ![CHD_HookHelper shareInstance].is_open_chdTable;
    [CHD_HookHelper shareInstance].is_open_chdCollection = ![CHD_HookHelper shareInstance].is_open_chdCollection;
    [[CHD_HookHelper shareInstance] resetCHD_HoverView];
}

@end


#pragma mark - CHD_HookHelper
@implementation CHD_HookHelper
{
    NSMutableDictionary *swizzedData;
}
+ (instancetype)shareInstance
{
    static CHD_HookHelper *helper;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        helper = [[self alloc] init];
    });
    return helper;
}


- (instancetype)init
{
    if (self = [super init]) {
        swizzedData = @{}.mutableCopy;
        self.weakListViewDic = [NSMapTable mapTableWithKeyOptions:NSPointerFunctionsWeakMemory valueOptions:NSPointerFunctionsCopyIn];
        self.is_open_chdTable = NO;
        self.is_open_chdCollection = NO;
    }
    return self;
}


- (BOOL)chenckIsSwizzedOrgObj:(id)oriObj sel:(NSString*)sel
{
    if (!oriObj ||!sel) {
        return YES;
    }
    BOOL isFatherChanged = NO;//查找是否有父类或同类已经交换过
    for (NSString *keys in [swizzedData allKeys]) {
        NSString *saveClass = [[keys componentsSeparatedByString:@"_chd_hook_"] firstObject];
        if ([oriObj isKindOfClass:NSClassFromString(saveClass)] && [swizzedData[[self getUniqueStr:saveClass sel:sel]] boolValue]) {
            isFatherChanged = YES;
            break;
        }
    }
    if (isFatherChanged) {
        /*
         1、父类已经交换过
         2、这里未对子类再进行交换，原因是如果子类重载了方法并且调用了[super someMethod]将会递归循环
         3、目前可以判断子类是否重载了某个函数，但无法判断子类内部是否调用了[super someMethod]，所以目前先不对子类做处理
         4、未对子类进行处理的情况下，如果子类调用了[super someMethod]或未重载父类方法将会正常显示，否则子类的页面将无法显示结构
         */
        
        //综上有两种建议：1、不使用继承实现delegate和dataSource的方法 2、使用了继承在子类重载的话要调用[super someMethod]
        return isFatherChanged;
    }
    
    return [swizzedData[[self getUniqueStr:NSStringFromClass([oriObj class]) sel:sel]] boolValue];
}
- (void)hookSelectors:(NSArray *)selArr orginalObj:(id)oriObj swizzedObj:(id)newObj
{
    
    for (NSString *selStr in selArr) {
        SEL sel  = NSSelectorFromString(selStr);
        SEL newSel = NSSelectorFromString([@"CHD_" stringByAppendingString:selStr]);
        if (![self chenckIsSwizzedOrgObj:oriObj sel:selStr]) {
            BOOL isSuccess = __CHD_Instance_Transition_Swizzle([oriObj class], sel, [newObj class], newSel);
            if (isSuccess) {
                swizzedData[[self getUniqueStr:NSStringFromClass([oriObj class])  sel:selStr]] = @(YES);
            }
        }
    }
    
    
}

- (nullable NSString *)getUniqueStr:(NSString*)oriObjClass sel:(NSString*)sel
{
    if (!oriObjClass||!sel) {
        return nil;
    }
    return [NSString stringWithFormat:@"%@_chd_hook_%@",oriObjClass,sel];
}


- (void)resetCHD_HoverView
{
    NSArray *WeakListViewArr = [[[CHD_HookHelper shareInstance].weakListViewDic keyEnumerator] allObjects];
    NSLog(@"当前listView个数：%@",@(WeakListViewArr.count));
    for (UIView *listView in WeakListViewArr) {
        if ([listView isKindOfClass:[UITableView class]] || [listView isKindOfClass:[UICollectionView class]]) {
            
            //刷新当前listView
            [listView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
            
            //刷新tableHederView、tableFooterView
            if ([listView isKindOfClass:[UITableView class]]) {
                UIView *tabelHeader = [(UITableView *)listView tableHeaderView];
                if (tabelHeader) {
                    [(UITableView *)listView setTableHeaderView:tabelHeader];
                }
                UIView *tableFooter = [(UITableView *)listView tableFooterView];
                if (tableFooter) {
                    [(UITableView *)listView setTableFooterView:tableFooter];
                }
            }
        }
    }
    
}


@end


#pragma mark - CHD_MustrHelper
@implementation CHD_MustrHelper

+ (NSMutableAttributedString *)getMustr:(NSString*)str textColor:(UIColor *)textColor backGroundColor:(UIColor *)backColor
{
    NSMutableAttributedString *Mstr = [[NSMutableAttributedString alloc] initWithString:str];
    [Mstr addAttribute:NSBackgroundColorAttributeName value:backColor range:NSMakeRange(0, str.length)];
    [Mstr addAttribute:NSForegroundColorAttributeName value:textColor range:NSMakeRange(0, str.length)];
    return Mstr;
}

@end




#pragma mark - UIView(CHD_HoverView)
static const void * CHDHOVERLABELKEY = "CHDHOVERLABELKEY";
@implementation UIView(CHD_HoverView)

- (UILabel *)hoverView:(UIColor*)borderColor
{
    
    CHD_HoverLabel *hover = objc_getAssociatedObject(self, CHDHOVERLABELKEY);
    
    if (!hover) {
        hover = [[CHD_HoverLabel alloc] initWithFrame:self.bounds];
        hover.backgroundColor = [UIColor clearColor];
        hover.textAlignment = NSTextAlignmentCenter;
        hover.adjustsFontSizeToFitWidth = YES;
        [self addSubview:hover];
        
        hover.translatesAutoresizingMaskIntoConstraints = YES;
        hover.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        hover.borderColor = borderColor;
        objc_setAssociatedObject(self, CHDHOVERLABELKEY, hover, OBJC_ASSOCIATION_RETAIN);
        return hover;
    }else{
        [self bringSubviewToFront:hover];
        hover.borderColor = borderColor;
        return hover;
    }
    
}
@end

@implementation CHD_HoverLabel
+(Class)layerClass
{
    return [CAShapeLayer class];
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    CAShapeLayer *layer = (CAShapeLayer *)self.layer;
    layer.frame = self.bounds;
    layer.path = [UIBezierPath bezierPathWithRect:CGRectInset(self.bounds, 1, 1)].CGPath;//增加一个小的间隙，这样多个cell的边缘不会重合
    layer.fillColor = [UIColor clearColor].CGColor;
    layer.strokeColor = self.borderColor.CGColor;
    layer.lineWidth = 1;
    
}
@end


#pragma mark - UITableView (CHD_Structure)
@implementation UITableView (CHD_Structure)
- (void)CHD_setDelegate:(id)delegate
{
    if (delegate) {
        NSMutableArray *selArr = @[@"tableView:willDisplayFooterView:forSection:",@"tableView:willDisplayHeaderView:forSection:"].mutableCopy;

        [[CHD_HookHelper shareInstance] hookSelectors:selArr orginalObj:delegate swizzedObj:[CHD_TableHelper class]];
        [[CHD_HookHelper shareInstance].weakListViewDic setObject:CHD_MapTable_Obj forKey:self];
    }
    [self CHD_setDelegate:delegate];
    
}
- (void)CHD_setDataSource:(id)dataSource
{
    if (dataSource) {
        NSArray *selArr = @[@"tableView:cellForRowAtIndexPath:"];
        
        [[CHD_HookHelper shareInstance] hookSelectors:selArr orginalObj:dataSource swizzedObj:[CHD_TableHelper class]];
        [[CHD_HookHelper shareInstance].weakListViewDic setObject:CHD_MapTable_Obj forKey:self];
    }
    [self CHD_setDataSource:dataSource];
    
}

@end

@implementation CHD_TableHelper

- (void)CHD_setTableHeaderView:(UIView *)tableHeaderView
{
    UILabel *headerHover = [tableHeaderView hoverView:chd_table_head_view_color];
    headerHover.attributedText = [CHD_MustrHelper getMustr:[NSString stringWithFormat:@"HeaderView--%@",NSStringFromClass([tableHeaderView class])] textColor:chd_table_text_color backGroundColor:chd_table_head_view_color];
    [self CHD_setTableHeaderView:tableHeaderView];
    headerHover.hidden = ![CHD_HookHelper shareInstance].is_open_chdTable;
}
- (void)CHD_setTableFooterView:(UIView *)tableFooterView
{
    UILabel *footerHover = [tableFooterView hoverView:chd_table_footer_view_color];
    footerHover.attributedText = [CHD_MustrHelper getMustr:[NSString stringWithFormat:@"FooterView--%@",NSStringFromClass([tableFooterView class])] textColor:chd_table_text_color backGroundColor:chd_table_footer_view_color];
    [self CHD_setTableFooterView:tableFooterView];
    footerHover.hidden = ![CHD_HookHelper shareInstance].is_open_chdTable;
}


-(UITableViewCell *)CHD_tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self CHD_tableView:tableView cellForRowAtIndexPath:indexPath];
    UILabel *hover = [cell hoverView:chd_table_cell_color];
    hover.attributedText = [CHD_MustrHelper getMustr:[NSString stringWithFormat:@"%@--%@--%@",NSStringFromClass([cell class]),@(indexPath.section),@(indexPath.row)] textColor:chd_table_text_color backGroundColor:[chd_table_cell_color colorWithAlphaComponent:chd_text_bg_alpha]];
    hover.hidden = ![CHD_HookHelper shareInstance].is_open_chdTable;
    return cell;
}


//原代理未实现的话，主动添加一个空实现用来交换。实现了则直接交换
- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(nonnull UIView *)view forSection:(NSInteger)section
{
}
- (void)tableView:(UITableView *)tableView willDisplayFooterView:(nonnull UIView *)view forSection:(NSInteger)section
{
}
- (void)CHD_tableView:(UITableView *)tableView willDisplayHeaderView:(nonnull UIView *)view forSection:(NSInteger)section
{
    [self CHD_tableView:tableView willDisplayHeaderView:view forSection:section];
    
    if ([view isKindOfClass:[UILabel class]]) {
        [view layoutIfNeeded];
    }
    UILabel *hover = [view hoverView:chd_table_header_color];
    hover.attributedText = [CHD_MustrHelper getMustr:[NSString stringWithFormat:@"Header--%@--%@",NSStringFromClass([view class]),@(section)] textColor:chd_table_text_color backGroundColor:[chd_table_header_color colorWithAlphaComponent:chd_text_bg_alpha]];
    hover.hidden = ![CHD_HookHelper shareInstance].is_open_chdTable;
    
}
- (void)CHD_tableView:(UITableView *)tableView willDisplayFooterView:(nonnull UIView *)view forSection:(NSInteger)section
{
    [self CHD_tableView:tableView willDisplayFooterView:view forSection:section];
    
    if ([view isKindOfClass:[UILabel class]]) {
        [view layoutIfNeeded];
    }
    UILabel *hover = [view hoverView:chd_table_footer_color];
    hover.attributedText = [CHD_MustrHelper getMustr:[NSString stringWithFormat:@"Footer--%@--%@",NSStringFromClass([view class]),@(section)] textColor:chd_table_text_color backGroundColor:[chd_table_footer_color colorWithAlphaComponent:chd_text_bg_alpha]];
    hover.hidden = ![CHD_HookHelper shareInstance].is_open_chdTable;
}

@end










//CollectionView
#pragma mark - UICollectionView (CHD_Structure)

@implementation UICollectionView (CHD_Structure)

- (void)CHD_setDelegate:(id)delegate
{
    if (delegate) {
        NSArray *selArr;
        if ([UIDevice currentDevice].systemVersion.floatValue>=8.0) {
            selArr = @[@"collectionView:willDisplaySupplementaryView:forElementKind:atIndexPath:"];
        }else{
            selArr = @[@"collectionView:didEndDisplayingSupplementaryView:forElementOfKind:atIndexPath:"];
        }
        
        
        [[CHD_HookHelper shareInstance] hookSelectors:selArr orginalObj:delegate swizzedObj:[CHD_CollectionHelper class]];
        [[CHD_HookHelper shareInstance].weakListViewDic setObject:CHD_MapTable_Obj forKey:self];

    }
    [self CHD_setDelegate:delegate];
}
- (void)CHD_setDataSource:(id)dataSource
{
    if (dataSource) {
        NSArray *selArr = @[@"collectionView:cellForItemAtIndexPath:"];
        
        [[CHD_HookHelper shareInstance] hookSelectors:selArr orginalObj:dataSource swizzedObj:[CHD_CollectionHelper class]];
        [[CHD_HookHelper shareInstance].weakListViewDic setObject:CHD_MapTable_Obj forKey:self];

    }
    [self CHD_setDataSource:dataSource];
}

@end

@implementation CHD_CollectionHelper

+ (NSAttributedString*)hoverAtt:(NSIndexPath*)indexPath cell:(UICollectionViewCell*)cell cacheToObj:(NSObject*)target
{
    static char *HDListViewHoverTextCacheKey;
    NSMutableDictionary *hoverCache = objc_getAssociatedObject(target, &HDListViewHoverTextCacheKey);
    if (!hoverCache) {
        hoverCache = @{}.mutableCopy;
        objc_setAssociatedObject(target, &HDListViewHoverTextCacheKey, hoverCache, OBJC_ASSOCIATION_RETAIN);
    }
    NSString *key = [NSString stringWithFormat:@"%zd-%zd",indexPath.section,indexPath.item];
    NSAttributedString *result = hoverCache[key];
    if (!result) {
        result = [CHD_MustrHelper getMustr:[NSString stringWithFormat:@"%@++%@++%@",NSStringFromClass([cell class]),@(indexPath.section),@(indexPath.item)] textColor:chd_collection_text_color backGroundColor:[chd_collection_cell_color colorWithAlphaComponent:chd_collection_bg_alpha]];
        hoverCache[key] = result;
    }
    return result;
}
- (void)someMthond
{
    
}
- (__kindof UICollectionViewCell *)CHD_collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    //方法交换后需要注意一个问题，此处的代码中的self代表的是 UICollectionView的delegate
    //此处的self不是CHD_CollectionHelper。因此 此处调用[self someMthond]; 编译不报错，运行时会报找不到方法
    __block UICollectionViewCell *cell = nil;
    uint64_t dispatch_benchmark(size_t count, void (^block)(void));
    uint64_t ns =  dispatch_benchmark(1, ^{
        cell = [self CHD_collectionView:collectionView cellForItemAtIndexPath:indexPath];
    });
    
    double currentTime = ns/(pow(10, 6));
#ifdef DEBUG
    printf("cellForItemAtIndexPath----本次时间%lf \n",currentTime);
#endif
    
    static char *HDListViewCountKey;
    static char *HDListViewScrollTotalTimeKey;
    
    NSNumber *numCount = objc_getAssociatedObject(self, &HDListViewCountKey);
    NSInteger count = 1;
    if (numCount) {
        count = numCount.integerValue;
    }
    double totalTime = 0;
    NSNumber *numTotal = objc_getAssociatedObject(self, &HDListViewScrollTotalTimeKey);
    if (numCount) {
        totalTime = numTotal.doubleValue;
    }
    totalTime += currentTime;
    double eveTime = (totalTime)/count;
#ifdef DEBUG
    printf("cellForItemAtIndexPath----平均时间%lf \n",eveTime);
#endif
    count++;
    
    objc_setAssociatedObject(self, &HDListViewCountKey, @(count), OBJC_ASSOCIATION_RETAIN);
    objc_setAssociatedObject(self, &HDListViewScrollTotalTimeKey, @(totalTime), OBJC_ASSOCIATION_RETAIN);
    

    UILabel *hover = [cell hoverView:chd_collection_cell_color];
    hover.attributedText = [CHD_CollectionHelper hoverAtt:indexPath cell:cell cacheToObj:self];
    hover.hidden = ![CHD_HookHelper shareInstance].is_open_chdCollection;
    
    return cell;
}

//如果原代理未实现如下方法会主动添加一个空实现
//iOS8以上
- (void)collectionView:(UICollectionView *)collectionView willDisplaySupplementaryView:(UICollectionReusableView *)view forElementKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)indexPath
{
    
}
//iOS8以下
- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingSupplementaryView:(UICollectionReusableView *)view forElementOfKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)indexPath
{
}

- (void)CHD_collectionView:(UICollectionView *)collectionView willDisplaySupplementaryView:(UICollectionReusableView *)view forElementKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)indexPath
{
    [self CHD_collectionView:collectionView willDisplaySupplementaryView:view forElementKind:elementKind atIndexPath:indexPath];
    UIColor *sectionViewColor = chd_collection_header_color;
    NSString *Kind = @"Header";
    if ([elementKind isEqualToString:UICollectionElementKindSectionFooter]) {
        sectionViewColor = chd_collection_footer_color;
        Kind = @"Footer";
    }else if ([elementKind isEqualToString:@"HDDecorationViewKind"]){
        Kind = @"Decoration(装饰)";
        sectionViewColor = chd_collection_decoration_color;
    }
    UILabel *hover = [view hoverView:sectionViewColor];
    
    hover.attributedText = [CHD_MustrHelper getMustr:[NSString stringWithFormat:@"%@++%@++%@",Kind,NSStringFromClass([view class]),@(indexPath.section)] textColor:chd_collection_text_color backGroundColor:[sectionViewColor colorWithAlphaComponent:chd_collection_bg_alpha]];
    hover.hidden = ![CHD_HookHelper shareInstance].is_open_chdCollection;
}

- (void)CHD_collectionView:(UICollectionView *)collectionView didEndDisplayingSupplementaryView:(UICollectionReusableView *)view forElementOfKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)indexPath
{
    [self CHD_collectionView:collectionView didEndDisplayingSupplementaryView:view forElementOfKind:elementKind atIndexPath:indexPath];
    UIColor *sectionViewColor = chd_collection_header_color;
    NSString *Kind = @"Header";
    if ([elementKind isEqualToString:UICollectionElementKindSectionFooter]) {
        sectionViewColor = chd_collection_footer_color;
        Kind = @"Footer";
    }else if ([elementKind isEqualToString:@"HDDecorationViewKind"]){
        Kind = @"Decoration(装饰)";
        sectionViewColor = chd_collection_decoration_color;
    }
    UILabel *hover = [view hoverView:sectionViewColor];
    
    hover.attributedText = [CHD_MustrHelper getMustr:[NSString stringWithFormat:@"%@++%@++%@",Kind,NSStringFromClass([view class]),@(indexPath.section)] textColor:chd_collection_text_color backGroundColor:[sectionViewColor colorWithAlphaComponent:chd_collection_bg_alpha]];
    hover.hidden = ![CHD_HookHelper shareInstance].is_open_chdCollection;
}



@end







