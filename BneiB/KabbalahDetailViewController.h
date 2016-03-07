//
//  KabbalahDetailViewController.h
//  KabNew
//
//  Created by Rockstar. on 11/8/14.
//  Copyright (c) 2014 Gabe Morales. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FeedModel.h"


@interface KabbalahDetailViewController : UIViewController

@property (nonatomic) FeedModel *selected;

- (void)setDetailItem:(id)selectedItem;

@end
