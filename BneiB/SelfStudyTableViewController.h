//
//  SelfStudyTableViewController.h
//  BneiB
//
//  Created by MexRockstar.
//  Copyright (c) 2012 Bnei Baruch USA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>
#import <FacebookSDK/FacebookSDK.h>

@class Reachability;

@interface SelfStudyTableViewController : UITableViewController<UIActionSheetDelegate, MFMailComposeViewControllerDelegate>{
    NSMutableArray *SelfStudy;
    NSMutableArray *SelfStudyDetail;
    MPMoviePlayerViewController *moviePlayer;
    
    Reachability *internetReach;  

}

/*- (IBAction)done:(id)sender;

@property (retain, nonatomic) IBOutlet UINavigationBar *navBar;
- (IBAction)viewSettings;*/
@property (strong, nonatomic) NSString *imageString;
@property (strong, nonatomic) NSString *urlString;

//- (IBAction)tweetTapped:(id)sender;

//Action Sheet
- (IBAction)openActionSheet;



@end
