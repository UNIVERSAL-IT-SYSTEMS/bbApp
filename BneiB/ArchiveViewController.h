//
//  KabTVViewController.h
//  Kabbalah
//
//  Created by MexRockstar.
//  Copyright (c) 2012 Bnei Baruch USA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>
#import <FacebookSDK/FacebookSDK.h>

@class Reachability;

@interface ArchiveViewController : UIViewController<UIActionSheetDelegate, MFMailComposeViewControllerDelegate>{
    MPMoviePlayerViewController *moviePlayer;
    NSURL *videoURL;
    
    Reachability *internetReach;  

}
@property(nonatomic, strong) MPMoviePlayerViewController *moviePlayer;
@property (nonatomic, strong) IBOutlet UIImageView *detailBG;
@property (nonatomic, strong) IBOutlet UIButton *mediButton;
@property (nonatomic, strong) IBOutlet UIButton *libraryButton;
@property (nonatomic, strong) IBOutlet UIButton *booksButton;
@property (nonatomic, strong) IBOutlet UIButton *selfButton;


- (void)SelfStudy:(id)sender;
- (void)Media:(id)sender;
- (void)Library:(id)sender;
- (void)Books:(id)sender;
//- (IBAction)viewSettings;

//Action Sheet
- (IBAction)openActionSheet;
@end
