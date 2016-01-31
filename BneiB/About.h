//
//  About.h
//  Kabbalah
//
//  Created by MexRockstar.
//  Copyright (c) 2012 Bnei Baruch USA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>

@class Reachability;

@interface About : UIViewController <UIWebViewDelegate, UIActionSheetDelegate, MFMailComposeViewControllerDelegate>{
    
    IBOutlet UIWebView *webView;
    UIActivityIndicatorView *activityIndicator;
    
    Reachability *internetReach;
    
}
@property (nonatomic, retain) UIWebView *webView;
@property (nonatomic, retain) UIActivityIndicatorView *activityIndicator;

//Action Sheet
- (IBAction)openActionSheet;

@end

NSTimer *timer;
