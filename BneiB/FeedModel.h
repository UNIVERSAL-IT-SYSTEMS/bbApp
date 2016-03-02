//
//  FeedModel.h
//  KabNew
//
//  Created by Gabriel Morales on 11/29/15.
//  Copyright © 2015 Gabe Morales. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FeedModel : NSObject

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *detail;
@property (nonatomic, copy) NSString *detailDescription;
@property (nonatomic, copy) NSURL *cellImageURL;
@property (nonatomic, copy) NSURL *iPadCellImageURL;
@property (nonatomic, copy) NSURL *iPadBackgroundURL;
@property (nonatomic, copy) NSURL *backgroundURL;
@property (nonatomic, copy) NSURL *detailBackgroundURL;
@property (nonatomic, copy) NSURL *videoURL;
@property (nonatomic, strong) NSArray *videos;

//- (instancetype)initWithDictionary:(NSDictionary *)dict;
+ (instancetype)feedWithDictionary:(NSDictionary *)dict;

@end
