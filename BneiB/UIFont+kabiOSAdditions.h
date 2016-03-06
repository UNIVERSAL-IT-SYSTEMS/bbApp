//
//  UIFont+kabiOSAdditions.h
//  KabNew
//
//  Created by Rockstar. on 11/6/14.
//  Copyright (c) 2014 Gabe Morales. All rights reserved.
//

extern NSString *const kBBFontRegularKey;
extern NSString *const kBBFontItalicKey;
extern NSString *const kBBFontBoldKey;
extern NSString *const kBBFontBoldItalicKey;

@interface UIFont (kabiOSAdditions)

#pragma mark - Font Names

+ (NSDictionary *)kabFontMapForFontKey:(NSString *)key;
+ (NSString *)kabFontNameForFontKey:(NSString *)key style:(NSString *)style;

#pragma mark - Fonts

+ (UIFont *)kabFontOfSize:(CGFloat)fontSize fontKey:(NSString *)key;
+ (UIFont *)boldKabFontOfSize:(CGFloat)fontSize fontKey:(NSString *)key;
+ (UIFont *)boldItalicKabFontOfSize:(CGFloat)fontSize fontKey:(NSString *)key;
+ (UIFont *)italicKabFontOfSize:(CGFloat)fontSize fontKey:(NSString *)key;

#pragma mark - Interface

+ (UIFont *)kabInterfaceFontOfSize:(CGFloat)fontSize;
+ (UIFont *)boldKabInterfaceFontOfSize:(CGFloat)fontSize;

@end
