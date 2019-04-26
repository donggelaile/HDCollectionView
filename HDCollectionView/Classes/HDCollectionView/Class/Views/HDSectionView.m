//
//  HDSectionView.m
//  
//
//  Created by CHD on 2018/8/9.
//  Copyright © 2018年 chd. All rights reserved.
//

#import "HDSectionView.h"

@implementation HDSectionView
- (void)applyLayoutAttributes:(UICollectionViewLayoutAttributes *)layoutAttributes
{
    [super applyLayoutAttributes:layoutAttributes];
    self.layer.zPosition = layoutAttributes.zIndex;
    self.frame = layoutAttributes.frame;
}
@end
