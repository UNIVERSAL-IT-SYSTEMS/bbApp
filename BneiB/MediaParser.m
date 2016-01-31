//
//  MediaParser.m
//  Kabbalah
//
//  Created by MexRockstar.
//  Copyright (c) 2012 Bnei Baruch USA. All rights reserved.
//

#import "MediaParser.h"


@implementation MediaParser

@synthesize items, responseData;
@synthesize currentTitle;
@synthesize currentDate;
@synthesize currentSummary;
@synthesize currentLink;
@synthesize currentPodcastLink;
@synthesize currentCategory;



- (void)parseRssFeed:(NSString *)url withDelegate:(id)aDelegate {
	[self setDelegate:aDelegate];
    
	responseData = [[NSMutableData data] retain];
	NSURL *baseURL = [[NSURL URLWithString:url] retain];
	
	
	NSURLRequest *request = [NSURLRequest requestWithURL:baseURL];
	
	[[[NSURLConnection alloc] initWithRequest:request delegate:self] autorelease];
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    [responseData setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [responseData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    NSString * errorString = [NSString stringWithFormat:@"No 3G/WiFi detected. Please check your Internet connection and try again."];
	
    BlockAlertView *errorAlert = [BlockAlertView alertWithTitle:@"Alert" message:errorString];
    
    [errorAlert setDestructiveButtonWithTitle:@"OK" block:nil];
    [errorAlert show];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
	self.items = [[NSMutableArray alloc] init];
	
	NSXMLParser *rssParser = [[NSXMLParser alloc] initWithData:responseData];
	
	[rssParser setDelegate:self];
	
	[rssParser parse];
}

#pragma mark rssParser methods

- (void)parserDidStartDocument:(NSXMLParser *)parser {
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict{
	currentElement = [elementName copy];
	
    if ([elementName isEqualToString:@"item"]) {
        item = [[NSMutableDictionary alloc] init];
        self.currentTitle = [[NSMutableString alloc] init];
        self.currentDate = [[NSMutableString alloc] init];
        self.currentSummary = [[NSMutableString alloc] init];
        self.currentLink = [[NSMutableString alloc] init];
        self.currentPodcastLink = [[NSMutableString alloc] init];
        self.currentCategory = [[NSMutableString alloc] init];


    }
	
	// podcast url is an attribute of the element enclosure
	if ([currentElement isEqualToString:@"enclosure"]) {
        [currentPodcastLink appendString:[attributeDict objectForKey:@"url"]];

	}
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName{
	
    if ([elementName isEqualToString:@"item"]) {
        [item setObject:self.currentTitle forKey:@"title"];
        [item setObject:self.currentLink forKey:@"guid"];
        [item setObject:self.currentSummary forKey:@"summary"];
        [item setObject:self.currentPodcastLink forKey:@"podcastLink"];
        [item setObject:self.currentCategory forKey:@"itunes:keywords"];


		
		// Parse date here
		NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
		
		[dateFormatter setDateFormat:@"E, d LLL yyyy HH:mm:ss zzz"];// Thu, 18 Jun 2010 04:48:09 -0700
		
        NSDate *date = [dateFormatter dateFromString:self.currentDate];
        if (!date)
            date = [NSDate date];
		
        [item setObject:date forKey:@"date"];
		
        [items addObject:[item copy]];
        
    }
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string{
    if ([currentElement isEqualToString:@"title"]) {
        [self.currentTitle appendString:string];
    } else if ([currentElement isEqualToString:@"guid"]) {
        [self.currentLink appendString:string];
    } else if ([currentElement isEqualToString:@"description"]) {
        [self.currentSummary appendString:string];
    } else if ([currentElement isEqualToString:@"pubDate"]) {
		[self.currentDate appendString:string];
		NSCharacterSet* charsToTrim = [NSCharacterSet characterSetWithCharactersInString:@" \n"];
		[self.currentDate setString: [self.currentDate stringByTrimmingCharactersInSet: charsToTrim]];
    }else if ([currentElement isEqualToString:@"itunes:keywords"]){
        [self.currentCategory appendString:string];
    }
}

- (void)parserDidEndDocument:(NSXMLParser *)parser {
	if ([_delegate respondsToSelector:@selector(receivedItems:)])
        [_delegate receivedItems:items];
    else
    { 
        [NSException raise:NSInternalInconsistencyException
					format:@"Delegate doesn't respond to receivedItems:"];
    }
}

#pragma mark Delegate methods

- (id)delegate {
	return _delegate;
}

- (void)setDelegate:(id)new_delegate {
	_delegate = new_delegate;
}

- (void)dealloc {
	[items release];
	[responseData release];
    [currentTitle release];
    [currentSummary release];
    [currentPodcastLink release];
    [currentDate release];
    [currentElement release];
    [currentLink release];
    [currentCategory release];

	[super dealloc];
}
@end