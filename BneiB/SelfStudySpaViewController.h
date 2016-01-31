//
//  SelfStudySpaViewController.h
//  Kabbalah
//
//  Created by Rockstar. on 2/3/13.
//  Copyright (c) 2013 Bnei Baruch USA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>
#import <MediaPlayer/MediaPlayer.h>

@class Reachability;

@interface SelfStudySpaViewController : UITableViewController<UIActionSheetDelegate, MFMailComposeViewControllerDelegate>{
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
