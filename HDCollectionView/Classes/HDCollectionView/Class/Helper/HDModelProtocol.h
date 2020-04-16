//
//  HDModelProtocol.h
//  HDCollectionView
//
//  Created by HaoDong chen on 2019/7/8.
//  

#ifndef HDModelProtocol_h
#define HDModelProtocol_h
#import <yoga/YGEnums.h>

NS_ASSUME_NONNULL_BEGIN

@class HDSectionModel;
@class HDBaseLayout;
@class HDCellModel;
//HDCellModelProtocol------------------------------------------------------------------begin
@protocol HDCellModelProtocol <NSObject>

@required

/**
 原始数据Model
 */
@property (nonatomic, strong) id _Nullable orgData;

/**
 默认CGSizeZero,优先级高于secM的cellSize。设置后优先使用该属性
 */
@property (nonatomic, assign) CGSize cellSize;

/**
 回调方式获取cellSize,优先级最高（一般需要适配横竖屏时使用该属性返回cell大小,内部必须弱引用self）
 */
@property (nonatomic, copy) CGSize(^ _Nullable cellSizeCb)(void);

/**
 默认nil,优先级高于secM的sectionCellClassStr，设置后优先使用
 */
@property (nonatomic, strong) NSString * _Nullable cellClassStr;

/**
 仅在layout为HDYogaFlowLayout生效，cell外边距。用于单独控制某个cell与其他cell间的间距
 假设纵向滑动下，设置HDYogaFlowLayout的verticalGap为10，并设置第一个cellModel的margin = UIEdgeInsetsMake(0, 0, 20, 0);
 那么第一个cell与第二个cell的纵向间距将为20+10，其他cell纵向间距仍为10
 */
@property (nonatomic, assign) UIEdgeInsets margain;

/**
 默认为cellClassStr
 */
@property (nonatomic, strong) NSString * _Nonnull reuseIdentifier;

/**
 内部自动赋值
 */
@property (nonatomic, strong, readonly) NSIndexPath * _Nullable indexP;

/**
 开启缓存cell子view frame时内部使用
 */
@property (nonatomic, strong, readonly) NSMutableArray * _Nullable subviewsFrame;

/**
 当cell中有多个点击事件时，使用context区分
 */
@property (nonatomic, strong) id _Nullable context;

/**
 点击cell时需要传递的其他参数可放到此处
 */
@property (nonatomic, strong) id _Nullable otherParameter;

/**
 对sectionModel的一个弱引用(赋值在UI更新之后)
 */
@property (nonatomic, weak, readonly) HDSectionModel * _Nullable secModel;

/**
 是否转换了原始model（内部使用，外部无需干预）
 一般可以将子类化的HDCellModel作为cell的viewModel，子类化的HDCellModel实现HDConvertOrgModelToViewModel代理来转换原始model
 每个子类化的HDCellmodel对象只会调用一次 - (void)convertOrgModelToViewModel 转换函数
 */
@property (nonatomic, assign) BOOL isConvertedToVM;

/**
 最终cell在collectionView上的xy坐标(赋值在UI更新之后)
 */
@property (nonatomic,strong, readonly) NSValue* _Nullable cellFrameXY;//CGPoint
/**
 根据当前配置的参数计算当前cell的大小
 */
- (CGSize)calculateCellProperSize:(BOOL)isNeedCacheSubviewsFrame forceUseAutoLayout:(BOOL)isForceUseAutoLayout;

@optional
- (void)convertOrgModelToViewModel;
@end
//HDCellModelProtocol------------------------------------------------------------------end



//HDSectionModelProtocol------------------------------------------------------------------begin
typedef NS_ENUM(NSInteger,HDHeaderStopOnTopType) {
    HDHeaderStopOnTopTypeNone, //不悬停，默认
    HDHeaderStopOnTopTypeNormal,//当本段内的cell及footer滑出后会跟着滑出
    HDHeaderStopOnTopTypeAlways//始终悬停在顶部(纵向滑动)或左部(横向滑动)，多个悬停的相遇后，后面的会在其后悬停
};

@protocol HDSectionModelProtocol <NSObject,NSCopying>

@required

/**
 默认nil,header类型，如果设置 必须是UICollectionReusableView或其子类
 */
@property (nonatomic, copy, nullable) NSString * sectionHeaderClassStr;

/**
 默认nil,footer类型，如果设置 必须是UICollectionReusableView或其子类
 */
@property (nonatomic, copy, nullable) NSString * sectionFooterClassStr;

/**
 默认nil,section内默认cell的类型, HDCellModel中的cellClassStr不为空时忽略该属性
 */
@property (nonatomic, copy, nullable) NSString * sectionCellClassStr;

/**
 默认nil,段头模型对象
 */
@property (nonatomic, strong, nullable) id headerObj;

/**
 默认nil,段尾模型对象
 */
@property (nonatomic, strong, nullable) id footerObj;

/**
 默认NO,是否需要自动算该段cell高度/宽度（为YES时默认首先判断cell是否实现hdSizeThatFits了函数，未实现时则使用AutoLayout计算，需要自动算高则HDCellModel的cellSize的height设为0，自动算宽反之）
 对于需要适配屏幕旋转的页面,设置HDCellModel的cellSizeCb属性即可
 */
@property (nonatomic, assign) BOOL isNeedAutoCountCellHW;


/**
 默认NO,当isNeedAutoCountCellHW 为YES才会考虑该属性， 该段内cell是否需要缓存所有子view的frame(如果设置为YES,则该section内的cell需要实现cacheSubviewsFrameBySetLayoutWithCellModel函数)
 */
@property (nonatomic, assign) BOOL isNeedCacheSubviewsFrame;

/**
 默认HDHeaderStopOnTopTypeNone, 该段 段头悬停类型(HDCollectionView的isNeedTopStop为YES才会生效)
 */
@property (nonatomic, assign) HDHeaderStopOnTopType headerTopStopType;

/**
 默认0，header悬浮偏移量 (第0段不建议自定义该值)
 */
@property (nonatomic, assign) NSInteger headerTopStopOffset;

/**
 默认会初始化一个可变空数组,用于存放所有子model(初始化完毕后，不要直接增删元素。需要增删请使用HDCollectionView提供的接口)
 */
@property (nonatomic, strong, nonnull) NSMutableArray<id<HDCellModelProtocol>> *sectionDataArr;

/**
 默认nil,存放该段布局
 */
@property (nonatomic, strong, nullable) __kindof HDBaseLayout *layout;

/**
 默认为section。如果对其赋值了，则可以通过该key来获取对应的sectionModel
 */
@property (nonatomic, strong, nullable) NSString *sectionKey;

/**
 装饰view的类（仅支持 HDYogaFlowLayout及HDWaterFlowLayout）
 一个段对应一个 decorationView
 */
@property (nonatomic, strong, nullable) NSString *decorationClassStr;

/**
 装饰view的数据
 */
@property (nonatomic, strong, nullable) id decorationObj;

@property (nonatomic, assign, readonly) BOOL isFinalSection;
@property (nonatomic, assign, readonly) NSInteger section;

/**
 header/footer多个点击事件时，可自行赋值区分
 使用完毕后建议赋值为nil，防止由于保留上个值而出现问题
 */
@property (nonatomic, strong, nullable) id context;

/**
 点击headerh时需要传递的其他参数
 */
@property (nonatomic, strong, nullable) id otherParameter;

/**
 该段section整体合适的frame
 */
@property (nonatomic, strong, readonly, nullable) NSValue* secProperRect;

@end
//HDSectionModelProtocol------------------------------------------------------------------end

#endif /* HDModelProtocol_h */

NS_ASSUME_NONNULL_END
