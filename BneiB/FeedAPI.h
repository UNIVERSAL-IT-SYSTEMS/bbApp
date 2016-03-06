//
//  FeedAPI.h
//  KabNew
//
//  Created by Gabriel Morales on 11/29/15.
//  Copyright © 2015 Gabe Morales. All rights reserved.
//

#import <Foundation/Foundation.h>

@class FeedModel;
@class Archive;
@class Blog;
@class Book;

@interface FeedAPI : NSObject
typedef void(^CompletionBlock)(BOOL success, NSData * response, NSError * error );

+ (FeedAPI *)sharedInstance;
@property (nonatomic, strong) AFHTTPRequestSerializer *requestSerializer;
- (void)requestFeedWithUrl:(NSString *)url withCompletion:(CompletionBlock)comp;

+ (instancetype)api;

- (void)getFeedWithCompletion:(void (^)(NSArray<Archive*>*feed, NSError *error))block;
- (void)getBlogWithCompletion:(void (^)(NSArray<Blog*>*blog, NSError *error))block;
- (void)getBooksWithCompletion:(void (^)(NSArray<Book*>*books, NSError *error))block;
- (void)getChannelWithCompletion:(void (^)(NSArray<FeedModel*>*channel, NSError *error))block;
@end
