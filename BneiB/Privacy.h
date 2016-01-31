//
//  Privacy.h
//  Kabbalah
//
//  Created by Rockstar. on 8/6/12.
//  Copyright (c) 2012 Bnei Baruch USA. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Reachability;

@interface Privacy : UIViewController<UIWebViewDelegate, UIActionSheetDelegate, MFMailComposeViewControllerDelegate>{
    
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
