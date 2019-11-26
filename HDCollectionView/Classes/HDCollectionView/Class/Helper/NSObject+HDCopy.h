//
//  NSObject+HDCopy.h
//  HDCollectionView
//
//  Created by HaoDong chen on 2019/4/17.
//  Copyright © 2019 CHD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>
NS_ASSUME_NONNULL_BEGIN

@interface HDObjectProperty : NSObject
@property (nonatomic, strong, readonly) NSString *name;
@property (nonatomic, strong, readonly) NSString *value;
- (instancetype)initWithProperty:(objc_property_t)property_t obj:(NSObject*)obj;
@end

@protocol hdDiffIdentifierIgnorePropertysProtocol <NSObject>
@optional
- (NSDictionary*)hdDiffIdentifierIgnorePropertys;
- (BOOL)hdDiffIdentifierIsNeedAddModelHash;
@end

@interface NSObject (HDCopy)
- (id)hd_copyWithZone:(NSZone*)zone;
- (NSArray<HDObjectProperty*>*)hdAllPropertys;
- (NSString*)hdObjectIDByPropertys;
@end

NS_ASSUME_NONNULL_END
