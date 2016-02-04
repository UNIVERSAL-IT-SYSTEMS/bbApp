//
//  DailyScheduleViewController.h
//  Kabbalah
//
//  Created by MexRockstar.
//  Copyright (c) 2012 Bnei Baruch USA. All rights reserved.
//
//

#import <UIKit/UIKit.h>

@class Reachability;

@interface DailyScheduleViewController : UIViewController<UIWebViewDelegate, UIActionSheetDelegate, MFMailComposeViewControllerDelegate>{
    
    IBOutlet UIWebView *webView;
    UIActivityIndicatorView *activityIndicator;
    
    Reachability *internetReach;
}

@property (nonatomic, retain) UIWebView *webView;
@property (nonatomic, retain) UIActivityIndicatorView *activityIndicator;

//Action Sheet
- (void)openActionSheet:(id)sender;

@end

NSTimer *timer;