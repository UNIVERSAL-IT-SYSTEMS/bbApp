//
//  FeedAPI.m
//  KabNew
//
//  Created by Gabriel Morales on 11/29/15.
//  Copyright © 2015 Gabe Morales. All rights reserved.
//

#import "FeedAPI.h"
#import "FeedModel.h"
#import "Archive.h"
#import "Blog.h"
#import "Book.h"
#import <XMLDictionary/XMLDictionary.h>
#import <AFNetworking/AFNetworking.h>

@implementation FeedAPI {
    AFHTTPRequestOperationManager *_rssOperationManager;
    AFHTTPRequestOperationManager *_operationManager;
}

+ (instancetype)api {
    return [[self alloc] init];
}

+ (FeedAPI *)sharedInstance {
    static dispatch_once_t once;
    static FeedAPI *instance;
    dispatch_once(&once, ^{
        if (!instance) {
            instance = [[FeedAPI alloc] init];
        }
    });
    return instance;
}


- (void)getFeedWithCompletion:(void (^)(NSArray<Archive *> *, NSError *))block {
    [_rssOperationManager GET:@"https://feeds.feedburner.com/kabbalah-archive/ENG" parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSDictionary *dict = [NSDictionary dictionaryWithXMLParser:responseObject];
        NSDictionary *channel = dict[@"channel"];
        NSArray *items = channel[@"item"];
        NSMutableArray *parsedFeed = [NSMutableArray array];
        for (NSDictionary *item in items) {
            [parsedFeed addObject:[Archive feedWithDictionary:item]];   
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            block([parsedFeed copy], nil);
        });
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        block(nil, error);
    }];
}

- (void)getBlogWithCompletion:(void (^)(NSArray<Blog *> *, NSError *))block {
    [_rssOperationManager GET:@"http://laitman.com/feed" parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSDictionary *dict = [NSDictionary dictionaryWithXMLParser:responseObject];
        NSDictionary *channel = dict[@"channel"];
        NSArray *items = channel[@"item"];
        NSMutableArray *parsedFeed = [NSMutableArray array];
        for (NSDictionary *item in items) {
            [parsedFeed addObject:[Blog feedWithDictionary:item]];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            block([parsedFeed copy], nil);
        });
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        block(nil, error);
    }];
}

- (void)getBooksWithCompletion:(void (^)(NSArray<Book*> *, NSError *error))block {
    [_operationManager GET:[self encodedURLStringWithString:@"library.json"] parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        [self runBlockInParserQueue:^{
            NSArray *response = (NSArray *)responseObject;
            NSMutableArray *parsedFeed = [NSMutableArray array];
            for (NSDictionary *dict in response) {
                [parsedFeed addObject:[Book feedWithDictionary:dict]];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                block([parsedFeed copy], nil);
            });
        }];
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        block(nil, error);
    }];
}

- (void)getChannelWithCompletion:(void (^)(NSArray<FeedModel*> *, NSError *error))block {
    [_operationManager GET:[self encodedURLStringWithString:@"bbtv/bb-static-new.json"] parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        [self runBlockInParserQueue:^{
            NSArray *response = (NSArray *)responseObject;
            NSMutableArray *parsedFeed = [NSMutableArray array];
            for (NSDictionary *dict  in response) {
                [parsedFeed addObject:[FeedModel feedWithDictionary:dict]];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                block([parsedFeed copy], nil);
            });
        }];
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        block(nil, error);
    }];
}

- (void)requestFeedWithUrl:(NSString *)url withCompletion:(CompletionBlock)comp {
    NSString *request = url;
    [self getRequest:request parameters:nil completion:^(BOOL success, NSData *response, NSError *error) {
        comp(success, response, error);
    }];
    
}


- (void)getRequest:(NSString *)requestPath parameters:(NSDictionary *)parameters completion:(CompletionBlock)completion {
    NSURL *url = [NSURL URLWithString:requestPath];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    op.responseSerializer = [AFJSONResponseSerializer serializer];
    op.responseSerializer.acceptableContentTypes = [NSSet setWithArray:@[@"text/plain"]];
    
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (completion != nil) completion(TRUE, responseObject, nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Failure!");
        [self handleError:error];
    }];
    [op start];
}


- (instancetype)init {
    if (self = [super init]) {
        _rssOperationManager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:nil];
        _rssOperationManager.responseSerializer = [AFXMLParserResponseSerializer serializer];
        [_rssOperationManager.responseSerializer setAcceptableContentTypes:[NSSet setWithArray:@[@"application/rss+xml",@"text/xml",@"text/plain"]]];
        
        static NSString *const bbBaseURL = @"http://m.kab.tv/ios/";
        _operationManager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:[NSURL URLWithString:bbBaseURL]];
        _operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
        
        AFJSONResponseSerializer *responseSerializer = [AFJSONResponseSerializer serializer];
        responseSerializer.removesKeysWithNullValues = YES;
        _operationManager.responseSerializer = responseSerializer;
        _operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithArray:@[@"text/plain"]];
    }
    return self;
}

- (dispatch_queue_t)sharedParserQueue
{
    static dispatch_queue_t sharedQueue = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedQueue = dispatch_queue_create("BB-parser", NULL);
    });
    return sharedQueue;
}

- (void)runBlockInParserQueue:(void (^)())block
{
    dispatch_async([self sharedParserQueue], ^{
        if (block != nil) {
            block();
        }
    });
}


#pragma mark - Network
- (void)handleError:(NSError *)error{
    // display user friendly error
    
    if(![AFNetworkReachabilityManager sharedManager].reachable){
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Oops!" message:@"Please make sure you are connecting to a network." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
        
    }else{
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Oops!" message:@"Something went wrong , Please try again later." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
        
    }
    NSString * message = error.localizedDescription;
    // send error to the server or use some bug tracking tool.
    NSLog(@"Error = %@",message);
    
}

- (NSString *)encodedURLStringWithString:(NSString *)urlString
{
    return [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}
@end
