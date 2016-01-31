//
//  MediaDetail.h
//  Kabbalah
//
//  Created by Rockstar. on 12/16/12.
//  Copyright (c) 2012 Bnei Baruch USA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>
#import <FacebookSDK/FacebookSDK.h>
#import "MBProgressHUD.h"

@interface MediaDetail : UIViewController <UIActionSheetDelegate, MFMailComposeViewControllerDelegate, UIWebViewDelegate, MBProgressHUDDelegate>
{
	NSDictionary *item;
	IBOutlet UILabel *itemTitle;
	IBOutlet UILabel *itemDate;
	IBOutlet UIWebView *itemSummary;
    UIActivityIndicatorView *activityIndicator;
    MBProgressHUD *HUD;

}

@property (retain, nonatomic) NSDictionary *item;
@property (retain, nonatomic) IBOutlet UILabel *itemTitle;
@property (retain, nonatomic) IBOutlet UILabel *itemDate;
@property (retain, nonatomic) IBOutlet UIWebView *itemSummary;
@property (strong, nonatomic) NSString *imageString;
@property (strong, nonatomic) NSString *urlString;
@property (strong, nonatomic) UIActivityIndicatorView *activityIndicator;




- (instancetype)initWithItem:(NSDictionary *)theItem NS_DESIGNATED_INITIALIZER;

// Twitter
//- (IBAction)tweetTapped:(id)sender;

- (void)openActionSheet:(id)sender;

@end

NSTimer *timer;