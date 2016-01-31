//
//  ArchiveCustomCell.h
//  Kabbalah
//
//  Created by Rockstar. on 12/16/12.
//  Copyright (c) 2012 Bnei Baruch USA. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ArchiveCustomCell : UITableViewCell

@property (nonatomic, strong) IBOutlet UILabel *medTitle;
@property (nonatomic, strong) IBOutlet UILabel *medSubTitle;
@property (nonatomic, strong) IBOutlet UILabel *medThr;
@property (nonatomic, strong) IBOutlet UILabel *medCategory;

@property (nonatomic, strong) IBOutlet UIImageView *medImageView;
@property (nonatomic, strong) IBOutlet UIImageView *medCellBackground;
@property (nonatomic, strong) IBOutlet UIImageView *medImagePlaceholder;

@end
