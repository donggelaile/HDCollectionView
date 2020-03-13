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

#import "NSAttributedString+SJMake.h"
#import "SJAttributesFactory.h"
#import "SJAttributesRecorder.h"
#import "SJAttributeWorker.h"
#import "SJUIKitAttributesDefines.h"
#import "SJUIKitTextMaker.h"
#import "SJUTAttributes.h"
#import "SJUTRangeHandler.h"
#import "SJUTRecorder.h"
#import "SJUTRegexHandler.h"

FOUNDATION_EXPORT double SJAttributesFactoryVersionNumber;
FOUNDATION_EXPORT const unsigned char SJAttributesFactoryVersionString[];

