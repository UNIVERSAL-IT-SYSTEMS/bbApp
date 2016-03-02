//
//  UIColor+kabIOSAdditions.m
//  KabNew
//
//  Created by Rockstar. on 10/28/14.
//  Copyright (c) 2014 Gabe Morales. All rights reserved.
//

#import "UIColor+kabIOSAdditions.h"

@implementation UIColor (kabIOSAdditions)

+ (UIColor *)kabBlueColor {
    return [self colorWithRed:0.031f green:0.506f blue:0.702f alpha:1.0f];
}

+ (UIColor *)kabStaticColor {
    return [self colorWithPatternImage:[UIImage imageNamed:@"bg_main"]];
}

+ (UIColor *)kabTextColor {
    return [self colorWithWhite:0.267f alpha:1.0f];
}

+ (UIColor *)kabDarkTextColor {
    return [self colorWithRed:0.20 green:0.20 blue:0.20 alpha:1.00];
}


+ (UIColor *)kabLightTextColor {
    return [self colorWithWhite:0.651f alpha:1.0f];
}


+ (UIColor *)kabSteelColor {
    return [self colorWithRed:0.376f green:0.408f blue:0.463f alpha:1.0f];
}

+ (UIColor *)kabHighlightColor {
    return [self colorWithRed:1.000f green:0.996f blue:0.792f alpha:1.0f];
}

+ (UIColor *)kabOrangeColor {
    return [self colorWithRed:1.000f green:0.447f blue:0.263f alpha:1.0f];
}

+ (UIColor *)kabLightGrayColor {
    return [self colorWithRed:0.86 green:0.86 blue:0.86 alpha:1.00];
}

+ (UIColor *)kabGreenColor {
    return [self colorWithRed:0.20 green:0.80 blue:0.00 alpha:1.00];
}

+ (UIColor *)kabDarkerTextColor {
    return [UIColor colorWithRed:0.949f green:0.510f blue:0.380f alpha:1.0f];
}

@end
