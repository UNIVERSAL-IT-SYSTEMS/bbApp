//
//  BBEmptyDataSetSource.m
//  KabNew
//
//  Created by Gabriel Morales on 12/21/15.
//  Copyright © 2015 Gabe Morales. All rights reserved.
//

#import "BBEmptyDataSetSource.h"

@interface BBEmptyDataSetSource ()
@property (nonatomic, strong) NSString *emptyTitle;
@property (nonatomic, strong) NSString *emptyDescription;

@end

@implementation BBEmptyDataSetSource

+ (instancetype)emptyDataSetSourceWithTitle:(NSString *)title description:(NSString *)description {
    BBEmptyDataSetSource *source = [[self alloc] init];
    source.emptyTitle = title;
    source.emptyDescription = description;
    return source;
}

#pragma mark - DZNEmptyDataSetSource
- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView {
    UIFont *font = [UIFont fontWithName:@"Avenir-Black" size:22.0];
    NSDictionary *attributeDict = [NSDictionary dictionaryWithObject:font forKey:NSFontAttributeName];
    return [[NSAttributedString alloc] initWithString:_emptyTitle attributes:attributeDict];
}

- (NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView {
    UIFont *font = [UIFont fontWithName:@"Avenir-Book" size:16.0];
    NSDictionary *attributeDict = [NSDictionary dictionaryWithObject:font forKey:NSFontAttributeName];
    return [[NSAttributedString alloc] initWithString:_emptyDescription attributes:attributeDict];
}

@end
