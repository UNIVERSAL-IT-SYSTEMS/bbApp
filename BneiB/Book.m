//
//  Book.m
//  KabNew
//
//  Created by Gabriel Morales on 12/22/15.
//  Copyright © 2015 Gabe Morales. All rights reserved.
//

#import "Book.h"

@implementation Book

//+ (instancetype)feedWithDictionary:(NSDictionary *)dict{
//    Blog *blog = [[self alloc] init];
//    blog.title = dict[@"title"];
//    blog.content = dict[@"description"];
//    blog.summary = dict[@"content:encoded"][@"__text"];
//    blog.thrTotal = dict[@"thr:total"];
//    blog.itunesKeyworkds = dict[@"itunes:keywords"];
//    blog.feedBurnerURL = dict[@"feedburner:origLink"];
//    blog.link = dict[@"link"];
//    
//    
//    NSDictionary *enclosure = dict[@"enclosure"];
//    if (enclosure != nil) {
//        blog.mediaContent = enclosure[@"media:content"];
//    }
//    
//    NSString *pubDate = dict[@"pubDate"];
//    blog.date = [[self sharedDateFormatter] dateFromString:pubDate];
//    
//    return blog;
//}

+ (instancetype)feedWithDictionary:(NSDictionary *)dict {
    Book *model = [[self alloc] init];
    model.title = dict[@"title"];
    model.author = dict[@"author"];
    model.synopsis = dict[@"description"];
    model.picSmall = dict[@"thumbnail-small"];
    model.picLarge = dict[@"thumbnail-medium"];
    model.itunesURL = dict[@"url"];
    model.pdfURL = dict[@"pdf"];
    
    return model;
}

@end
