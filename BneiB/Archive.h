//
//  Archive.h
//  KabNew
//
//  Created by Gabriel Morales on 12/21/15.
//  Copyright © 2015 Gabe Morales. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Archive : NSObject

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *link;
@property (nonatomic, copy) NSString *summary;
@property (nonatomic, copy) NSDate *date;
@property (nonatomic, copy) NSString *content;

//- (instancetype)initWithDictionary:(NSDictionary *)dict;
+ (instancetype)feedWithDictionary:(NSDictionary *)dict;

@end
