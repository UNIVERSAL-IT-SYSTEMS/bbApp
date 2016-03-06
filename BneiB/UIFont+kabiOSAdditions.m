//
//  UIFont+kabiOSAdditions.m
//  KabNew
//
//  Created by Rockstar. on 11/6/14.
//  Copyright (c) 2014 Gabe Morales. All rights reserved.
//

#import "UIFont+kabiOSAdditions.h"

NSString *const kBBFontRegularKey = @"Book";
NSString *const kBBFontItalicKey = @"Oblique";
NSString *const kBBFontBoldKey = @"Heavy";
NSString *const kBBFontBoldItalicKey = @"HeavyOblique";
NSString *const kCDIFontHelveticaNeueKey = @"Avenir";
NSString *const kBBRegularFontName = @"Avenir-Book";
NSString *const kBBBoldFontName = @"Avenir-Heavy";

@implementation UIFont (kabiOSAdditions)

#pragma mark - Font Name
+ (NSDictionary *)kabFontMapForFontKey:(NSString *)key {
    static NSDictionary *fontDictionary = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        fontDictionary = [[NSDictionary alloc] initWithObjectsAndKeys:
                          [[NSDictionary alloc] initWithObjectsAndKeys:
                           @"Avenir-Book", kBBFontRegularKey,
                           @"Avenir-BookOblique", kBBFontItalicKey,
                           @"Avenir-Heavy", kBBFontBoldKey,
                           @"Avenir-HeavyOblique", kBBFontBoldItalicKey,
                           nil], kCDIFontHelveticaNeueKey,
                          nil];
    });
    return [fontDictionary objectForKey:key];
}

+ (NSString *)kabFontNameForFontKey:(NSString *)key style:(NSString *)style {
    return [[self kabFontMapForFontKey:key] objectForKey:style];
}

#pragma mark - Fonts

+ (UIFont *)kabFontOfSize:(CGFloat)fontSize fontKey:(NSString *)key {
    NSString *fontName = [self kabFontNameForFontKey:key style:kBBFontRegularKey];
    return [self fontWithName:fontName size:fontSize];
}

+ (UIFont *)boldKabFontOfSize:(CGFloat)fontSize fontKey:(NSString *)key {
    NSString *fontName = [self kabFontNameForFontKey:key style:kBBFontBoldKey];
    return [self fontWithName:fontName size:fontSize];
}

+ (UIFont *)boldItalicKabFontOfSize:(CGFloat)fontSize fontKey:(NSString *)key {
    NSString *fontName = [self kabFontNameForFontKey:key style:kBBFontBoldItalicKey];
    return [self fontWithName:fontName size:fontSize];
}

+ (UIFont *)italicKabFontOfSize:(CGFloat)fontSize fontKey:(NSString *)key {
    NSString *fontName = [self kabFontNameForFontKey:key style:kBBFontItalicKey];
    return [self fontWithName:fontName size:fontSize];
}

#pragma mark - Interface

+ (UIFont *)kabInterfaceFontOfSize:(CGFloat)fontSize {
    return [self fontWithName:kBBRegularFontName size:fontSize];
}

+ (UIFont *)boldKabInterfaceFontOfSize:(CGFloat)fontSize {
    return [self fontWithName:kBBBoldFontName size:fontSize];
}

@end
