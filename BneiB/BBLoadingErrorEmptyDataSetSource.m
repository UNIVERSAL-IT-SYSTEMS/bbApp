//
//  BBLoadingErrorEmptyDataSetSource.m
//  KabNew
//
//  Created by Gabriel Morales on 12/21/15.
//  Copyright © 2015 Gabe Morales. All rights reserved.
//

#import "BBLoadingErrorEmptyDataSetSource.h"

@implementation BBLoadingErrorEmptyDataSetSource

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView {
    UIFont *font = [UIFont fontWithName:@"Avenir-Black" size:22];
    NSDictionary *attributeDict = [NSDictionary dictionaryWithObject:font forKey:NSFontAttributeName];
    return [[NSAttributedString alloc] initWithString:@"Loading error!" attributes:attributeDict];
}

- (NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView {
    UIFont *font = [UIFont fontWithName:@"Avenir-Book" size:16];
    NSDictionary *attributeDict = [NSDictionary dictionaryWithObject:font forKey:NSFontAttributeName];
    return [[NSAttributedString alloc] initWithString:@"Looks like something went wrong! Tap 'Retry' to try loading the data again." attributes:attributeDict];
}

- (NSAttributedString *)buttonTitleForEmptyDataSet:(UIScrollView *)scrollView forState:(UIControlState)state {
    UIFont *font = [UIFont fontWithName:@"Avenir-Black" size:16];
    UIColor *foregroundColor = [UIColor colorWithRed:35/255 green:25/255 blue:35/255 alpha:1.0];
    NSDictionary *attributesDict = @{
                                     NSFontAttributeName: font,
                                     NSForegroundColorAttributeName: foregroundColor
                                     };
    return [[NSAttributedString alloc] initWithString:@"Retry" attributes:attributesDict];
}

@end
