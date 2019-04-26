#ifdef __OBJC__
#import <UIKit/UIKit.h>
#else
#ifndef FOUNDATION_EXPORT
#if defined(__cplusplus)
#define FOUNDATION_EXPORT extern "C"
#else
#define FOUNDATION_EXPORT extern
#endif
#endif
#endif

#import "HDAssociationManager.h"
#import "HDCellFrameCacheHelper.h"
#import "HDDefines.h"
#import "HDHeaderStopHelper.h"
#import "HDUpdateUIProtocol.h"
#import "HDYogaCalculateHelper.h"
#import "NSObject+HDCopy.h"
#import "HDBaseLayout+Cache.h"
#import "HDBaseLayout.h"
#import "HDCollectionViewFlowLayout.h"
#import "HDCollectionViewLayout.h"
#import "HDLayoutProtocol.h"
#import "HDWaterFlowLayout.h"
#import "HDYogaFlowLayout.h"
#import "HDCellModel.h"
#import "HDSectionModel.h"
#import "HDCollectionCell.h"
#import "HDCollectionView.h"
#import "HDSectionView.h"

FOUNDATION_EXPORT double HDCollectionViewVersionNumber;
FOUNDATION_EXPORT const unsigned char HDCollectionViewVersionString[];

