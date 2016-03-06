//
//  BookStoreDetailViewController.h
//  KabNew
//
//  Created by Gabriel Morales on 12/22/15.
//  Copyright © 2015 Gabe Morales. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Book.h"

@interface BookStoreDetailViewController : UIViewController
@property (nonatomic) Book *selected;
- (void)setDetailItem:(id)selectedItem;

@end
