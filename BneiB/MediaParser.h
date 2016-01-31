//
//  MediaParser.h
//  Kabbalah
//
//  Created by MexRockstar.
//  Copyright (c) 2012 Bnei Baruch USA. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol MediaParserDelegate <NSObject>
- (void)receivedItems:(NSArray *)theItems;
@end

@interface MediaParser : NSObject <NSXMLParserDelegate> {
	id _delegate;
	
	NSMutableData *responseData;
	NSMutableArray *items;
	
	NSMutableDictionary *item;
	NSString *currentElement;
	NSMutableString * currentTitle, * currentDate, * currentSummary, * currentLink, * currentPodcastLink, * currentCategory;
    

}

@property (retain, nonatomic) NSMutableData *responseData;
@property (retain, nonatomic) NSMutableArray *items;
@property (retain, nonatomic) NSMutableString *currentTitle;
@property (retain, nonatomic) NSMutableString *currentDate;
@property (retain, nonatomic) NSMutableString *currentSummary;
@property (retain, nonatomic) NSMutableString *currentLink;
@property (retain, nonatomic) NSMutableString *currentPodcastLink;
@property (retain, nonatomic) NSMutableString *currentCategory;



- (void)parseRssFeed:(NSString *)url withDelegate:(id)aDelegate;

- (id)delegate;
- (void)setDelegate:(id)new_delegate;

@end
