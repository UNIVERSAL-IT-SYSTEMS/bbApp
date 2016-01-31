//
//  ArchiveCustomCell.m
//  Kabbalah
//
//  Created by Rockstar. on 12/16/12.
//  Copyright (c) 2012 Bnei Baruch USA. All rights reserved.
//

#import "ArchiveCustomCell.h"

@implementation ArchiveCustomCell

@synthesize medTitle;
@synthesize medSubTitle;
@synthesize medThr, medCategory;
@synthesize medImageView, medCellBackground, medImagePlaceholder;

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    if(selected)
    {
        UIImage* bg = [UIImage imageNamed:@"ipad-list-item-selected.png"];
        
        [medCellBackground setImage:bg];
        
        //[UIFont fontWithName:@"AbadiMTCondensedExtraBold.ttf" size: 13.0];
        //[blogTitle setFont:[UIFont fontWithName:@"AbadiMTCondensedExtraBold" size:8.0]];
        [medTitle setTextColor:[UIColor whiteColor]];
        [medTitle setShadowColor:[UIColor colorWithRed:25.0/255 green:96.0/255 blue:148.0/255 alpha:1.0]];
        [medTitle setShadowOffset:CGSizeMake(0, 0)];
        
        
        [medSubTitle setTextColor:[UIColor whiteColor]];
        [medSubTitle setShadowColor:[UIColor colorWithRed:25.0/255 green:96.0/255 blue:148.0/255 alpha:1.0]];
        [medSubTitle setShadowOffset:CGSizeMake(0, 0)];
        
        [medThr setTextColor:[UIColor whiteColor]];
        [medThr setShadowColor:[UIColor colorWithRed:25.0/255 green:96.0/255 blue:148.0/255 alpha:1.0]];
        [medThr setShadowOffset:CGSizeMake(0, 0)];
        
        [medCategory setTextColor:[UIColor whiteColor]];
        [medCategory setShadowColor:[UIColor colorWithRed:153.0/255 green:0.0/255 blue:0.0/255 alpha:1.0]];
        [medCategory setShadowOffset:CGSizeMake(0, 0)];
        
    }
    else
    {
        UIImage* bg = [UIImage imageNamed:@"ipad-list-element.png"];
        
        [medCellBackground setImage:bg];
        
        //[blogTitle setFont:[UIFont fontWithName:@"AbadiMTCondensedExtraBold" size:8.0]];
        [medTitle setTextColor:[UIColor colorWithRed:27/255.0 green:135/255.0 blue:195/255.0 alpha:1.0]];
        [medTitle setShadowColor:[UIColor whiteColor]];
        [medTitle setShadowOffset:CGSizeMake(0, 0)];
        
        
        [medSubTitle setTextColor:[UIColor colorWithRed:113.0/255 green:133.0/255 blue:148.0/255 alpha:1.0]];
        [medSubTitle setShadowColor:[UIColor whiteColor]];
        [medSubTitle setShadowOffset:CGSizeMake(0, 0)];
        
        [medThr setTextColor:[UIColor colorWithRed:113.0/255 green:133.0/255 blue:148.0/255 alpha:1.0]];
        [medThr setShadowColor:[UIColor clearColor]];
        [medThr setShadowOffset:CGSizeMake(0, 0)];
        
        [medCategory setTextColor:[UIColor colorWithRed:153.0/255 green:0.0/255 blue:0.0/255 alpha:1.0]];
        [medCategory setShadowColor:[UIColor whiteColor]];
        [medCategory setShadowOffset:CGSizeMake(0, 0)];
        
    }
    
    
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}



@end
