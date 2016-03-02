//
//  BBInforBaseViewController.h
//  Kabbalah
//
//  Created by Gabriel Morales on 2/5/16.
//  Copyright © 2016 Bnei Baruch USA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GMWebView.h"

@class Reachability;

@interface BBInforBaseViewController : UIViewController<GMWebViewDelegate, UIActionSheetDelegate, MFMailComposeViewControllerDelegate>

@property (nonatomic, retain) GMWebView *webView;
@property (nonatomic, retain) UIActivityIndicatorView *activityIndicator;
@property (nonatomic) Reachability *internetReach;
@property (nonatomic, strong) NSString *webPath;

@end

NSTimer *timer;

