//
//  HDLayoutProtocol.h
//  HDCollectionView
//
//  Created by HaoDong chen on 2019/3/14.
//  Copyright © 2019 CHD. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "HDCollectionViewLayout.h"
#import "HDModelProtocol.h"
#ifndef HDLayoutProtocol_h
#define HDLayoutProtocol_h
@protocol HDLayoutProtocol <NSObject>

@optional
- (UICollectionViewLayoutAttributes*)decorationAtt;
@required
- (NSArray *)layoutWithLayout:(HDCollectionViewLayout *)layout sectionModel:(id<HDSectionModelProtocol>)secModel currentStart:(CGPoint *)cStart;
- (NSMutableArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect scrollDirection:(UICollectionViewScrollDirection)scrollDirection;
@end
#endif /* HDLayoutProtocol_h */
