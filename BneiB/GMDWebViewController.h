//
//  GMDWebViewController.h
//  KabNew
//
//  Created by Rockstar. on 11/12/14.
//  Copyright (c) 2014 Gabe Morales. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GMWebView.h"
#import <MessageUI/MessageUI.h>
#import "Book.h"

@interface GMDWebViewController : UIViewController<GMWebViewDelegate, UIActionSheetDelegate, MFMailComposeViewControllerDelegate, UINavigationControllerDelegate>

@property (nonatomic, strong) GMWebView *webView;

- (void)loadURL:(NSURL *)url;
- (NSURL *)currentURL;

- (void)close:(id)sender;
- (void)openSafari:(id)sender;
- (void)openActionSheet:(id)sender;
- (void)copyURL:(id)sender;
- (void)emailURL:(id)sender;

//Book Download
@property (nonatomic) Book *bookSelected;

@end
