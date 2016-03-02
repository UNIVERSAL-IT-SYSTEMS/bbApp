//
//  Blog.m
//  KabNew
//
//  Created by Gabriel Morales on 12/21/15.
//  Copyright © 2015 Gabe Morales. All rights reserved.
//

#import "Blog.h"

@implementation Blog

+ (instancetype)feedWithDictionary:(NSDictionary *)dict{
    Blog *blog = [[self alloc] init];
    blog.title = dict[@"title"];
    blog.content = dict[@"description"];
    blog.summary = dict[@"content:encoded"];
    blog.thrTotal = dict[@"thr:total"];
    blog.itunesKeyworkds = dict[@"itunes:keywords"];
    blog.feedBurnerURL = dict[@"feedburner:origLink"];
    blog.link = dict[@"link"];
    
    
    NSDictionary *enclosure = dict[@"enclosure"];
    if (enclosure != nil) {
//        blog.mediaContent = enclosure[@"media:content"];
    }
    
    NSString *pubDate = dict[@"pubDate"];
    blog.date = [[self sharedDateFormatter] dateFromString:pubDate];
    
    return blog;
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
