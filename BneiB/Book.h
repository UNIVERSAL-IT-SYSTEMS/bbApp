//
//  Book.h
//  KabNew
//
//  Created by Gabriel Morales on 12/22/15.
//  Copyright © 2015 Gabe Morales. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Book : NSObject

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *author;
@property (nonatomic, copy) NSString *synopsis;
@property (nonatomic, copy) NSString *picLarge;
@property (nonatomic, copy) NSString *picSmall;
@property (nonatomic, copy) NSString *pdfURL;
@property (nonatomic, copy) NSString *itunesURL;

+ (instancetype)feedWithDictionary:(NSDictionary *)dict;


@end
