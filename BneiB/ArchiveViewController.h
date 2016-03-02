//
//  ArchiveViewController.h
//  KabNew
//
//  Created by Gabriel Morales on 12/20/15.
//  Copyright © 2015 Gabe Morales. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ArchiveViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic) UITableView *table;

@end
