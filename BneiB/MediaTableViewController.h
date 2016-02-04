//
//  MediaTableViewController.h
//  Kabbalah
//
//  Created by MexRockstar.
//  Copyright (c) 2012 Bnei Baruch USA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"


@class Reachability;

@interface MediaTableViewController : UITableViewController <MBProgressHUDDelegate, UIActionSheetDelegate, MFMailComposeViewControllerDelegate> {
    
    MBProgressHUD *HUD;
    
	long long expectedLength;
	long long currentLength;
	
	// Parsing
    NSArray *items;
	
	// Displaying
	NSArray *itemsToDisplay;
	NSDateFormatter *formatter;
    
    Reachability *internetReach;
	
}

// Properties
@property (retain, nonatomic) NSArray *items;
@property (strong, nonatomic) NSString *imageString;
@property (strong, nonatomic) NSString *urlString;

// Twitter
//- (IBAction)tweetTapped:(id)sender;

//Action Sheet
- (IBAction)openActionSheet;

@end
