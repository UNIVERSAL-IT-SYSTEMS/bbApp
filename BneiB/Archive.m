//
//  Archive.m
//  KabNew
//
//  Created by Gabriel Morales on 12/21/15.
//  Copyright © 2015 Gabe Morales. All rights reserved.
//

#import "Archive.h"

@implementation Archive

+ (instancetype)feedWithDictionary:(NSDictionary *)dict{
    Archive *feed = [[self alloc] init];
    feed.title = dict[@"title"];
    feed.content = dict[@"description"];
    
    NSDictionary *enclosure = dict[@"enclosure"];
    if (enclosure != nil) {
        feed.link = enclosure[@"media:content"];
    }
    
    NSString *pubDate = dict[@"pubDate"];
    feed.date = [[self sharedDateFormatter] dateFromString:pubDate];
    
    return feed;
}

+ (NSDateFormatter *)sharedDateFormatter {
    static NSDateFormatter *dateFormatter = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dateFormatter = [NSDateFormatter new];
        dateFormatter.dateFormat = @"E, d LLL yyyy HH:mm:ss zzz";
    });
    return dateFormatter;
}

@end
