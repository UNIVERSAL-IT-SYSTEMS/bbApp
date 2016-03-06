//
//  GMDWebViewController.m
//  KabNew
//
//  Created by Rockstar. on 11/12/14.
//  Copyright (c) 2014 Gabe Morales. All rights reserved.
//

#import "GMDWebViewController.h"
#import <Social/Social.h>
#import <Twitter/Twitter.h>
#import <Accounts/Accounts.h>

@interface GMDWebViewController ()
- (void)_updateBrowserUI;

@end

@implementation GMDWebViewController{
    NSURL *_url;
    UIActivityIndicatorView *_indicator;
    UIBarButtonItem *_backBarButton;
    UIBarButtonItem *_forwardBarButton;
    UIBarButtonItem *_reloadBarButton;
    UIBarButtonItem *_shareBarButton;
}

@synthesize webView = _webView;

#pragma mark - UIViewController

- (instancetype)init {
    if ((self = [super init])) {
        self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc]
                                   initWithTitle:@" "
                                   style:UIBarButtonItemStylePlain
                                   target:nil
                                   action:nil];
    self.navigationItem.backBarButtonItem=backButton;
    // Do any additional setup after loading the view.
    
    _indicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 22.0f, 22.0f)];
    _indicator.hidesWhenStopped = YES;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:_indicator];
    
    _webView = [[GMWebView alloc] initWithFrame:self.view.bounds];
    _webView.backgroundColor = [UIColor kabStaticColor];
    _webView.translatesAutoresizingMaskIntoConstraints = NO;
    //    _webView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    _webView.delegate = self;
    _webView.scalesPageToFit = YES;
    _webView.scrollView.showsHorizontalScrollIndicator = NO;
    [_webView.scrollView setZoomScale:1.0 animated:YES];
    if (self.bookSelected != nil) {
        self.title = self.bookSelected.title;
        [_webView loadURL:[NSURL URLWithString:self.bookSelected.pdfURL]];
    } else {
        [_webView loadURL:_url];
    }
    [self.view addSubview:_webView];
    
    _backBarButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back-button"] landscapeImagePhone:[UIImage imageNamed:@"back-button-mini"] style:UIBarButtonItemStylePlain target:_webView action:@selector(goBack)];
    _backBarButton.tintColor = [UIColor whiteColor];
    
    _forwardBarButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"forward-button"] landscapeImagePhone:[UIImage imageNamed:@"forward-button-mini"] style:UIBarButtonItemStylePlain target:_webView action:@selector(goForward)];
    _forwardBarButton.tintColor = [UIColor whiteColor];
    
    _reloadBarButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"safari-button"] landscapeImagePhone:[UIImage imageNamed:@"safari-button-mini"] style:UIBarButtonItemStylePlain target:self action:@selector(openSafari:)];
    _reloadBarButton.tintColor = [UIColor whiteColor];
    
    _shareBarButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"action-button"] landscapeImagePhone:[UIImage imageNamed:@"action-button-mini"] style:UIBarButtonItemStylePlain target:self action:@selector(openActionSheet:)];
    _shareBarButton.tintColor = [UIColor whiteColor];
    
    UIBarButtonItem *flex = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    [self.navigationController setToolbarHidden:NO];
    self.navigationController.toolbar.frame = CGRectMake(0.0f, [[UIScreen mainScreen] bounds].size.height - 44, _webView.frame.size.width, 44.0f);
    self.navigationController.toolbar.tintColor = [UIColor whiteColor];
    self.toolbarItems = [NSArray arrayWithObjects:
                         _backBarButton,
                         flex,
                         _forwardBarButton,
                         flex,
                         _reloadBarButton,
                         flex,
                         _shareBarButton,
                         nil];
    
    for (UIBarButtonItem *button in self.toolbarItems) {
        button.imageInsets = UIEdgeInsetsMake(3.0f, 0.0f, 0.0f, 0.0f);
    }
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"close" style:UIBarButtonItemStylePlain target:self action:@selector(close:)];
    }
    
    NSDictionary *viewDict = @{@"webView": _webView};
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[webView]|"
                                                                      options:kNilOptions metrics:nil
                                                                        views:viewDict]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[webView]|"
                                                                      options:kNilOptions metrics:nil
                                                                        views:viewDict]];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (![_url isFileURL]) {
        [self.navigationController setToolbarHidden:NO animated:animated];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.navigationController setToolbarHidden:YES animated:animated];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    self.bookSelected = nil;
}

#pragma mark - URL Loading

- (void)loadURL:(NSURL *)url {
    _url = url;
}

- (NSURL *)currentURL {
    NSURL *url = _webView.lastRequest.mainDocumentURL;
    if (!url) {
        url = _url;
    }
    
    return url;
}

#pragma mark - Actions

- (void)close:(id)sender {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (void)openSafari:(id)sender {
    [[UIApplication sharedApplication] openURL:self.currentURL];
}

- (void)openActionSheet:(id)sender {
    NSString *urlString = [NSString stringWithFormat:@"%@", _url];
    if ([UIActivityViewController class] && [urlString containsString:@"pdf"]) {
        NSString *url = urlString;
        NSArray *items = @[self, [NSURL URLWithString:[NSString stringWithFormat:@"%@", url]]];
        UIActivityViewController *activityViewController = [[UIActivityViewController alloc] initWithActivityItems:items
                                                                                             applicationActivities:nil];
        
        activityViewController.excludedActivityTypes = @[UIActivityTypeSaveToCameraRoll, UIActivityTypePostToVimeo, UIActivityTypeCopyToPasteboard];
        [activityViewController.navigationItem.leftBarButtonItem setTintColor:[UIColor whiteColor]];
        
        UIActivityViewControllerCompletionWithItemsHandler completionBlock = ^(NSString *activityType, BOOL completed, NSArray *returnedItems, NSError *activityError) {
            if (completed) {
                [self alertWithTitle:@"Done" andMessage:nil];
            }
            if (activityError) {
                [self alertWithTitle:@"Error!" andMessage:activityError.localizedDescription];
            }
        };
        activityViewController.completionWithItemsHandler = completionBlock;
        [self presentViewController:activityViewController animated:YES completion:^{
            [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
        }];
    } else {
        UIActionSheet *actionSheet = nil;
        
        if ([MFMailComposeViewController canSendMail] == NO) {
            actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Copy URL", nil];
        } else {
            actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Copy URL", @"Email URL", nil];
        }
        
        actionSheet.actionSheetStyle = UIActionSheetStyleDefault;
        [actionSheet showInView:self.navigationController.view];
    }
}

- (id) activityViewController:(UIActivityViewController *)activityViewController itemForActivityType:(NSString *)activityType {
    NSString *string = [NSString stringWithFormat:@"Check out %@. Via %@", self.bookSelected.title, @"@KabbalahApp"];
    
    if ([activityType isEqualToString:UIActivityTypeMail]) {
        NSMutableString *body = [NSMutableString string];
        [body appendString:@"<html><body><h2>"];
        [body appendString:self.bookSelected.title];
        [body appendString:@"</h2><h3>"];
        [body appendString:self.bookSelected.author];
        [body appendString:@"</h3><p>"];
        [body appendString:self.bookSelected.synopsis];
        [body appendString:@"</p><a href=\""];
        [body appendString:self.bookSelected.itunesURL];
        [body appendString:@"\"> Link</a>\n<p>Follow us on <a href=\"http://www.twitter.com/KabbalahApp\">Twitter</a></br>"];
        [body appendString:@"Like us on <a href=\"https://www.facebook.com/KabbalahApp\">Facebook</a></br></p></body></html>"];
        return body;
    } else if ([activityType isEqualToString:UIActivityTypePostToTwitter] || [activityType isEqualToString:UIActivityTypeMessage]) {
        return string;
    } else {
        return nil;
    }
    
}


- (id) activityViewController:(UIActivityViewController *)activityViewController dataTypeIdentifierForActivityType:(NSString *)activityType {
    NSURL *url = [NSURL URLWithString:self.bookSelected.itunesURL];
    NSData *data = [NSData dataWithContentsOfURL:url];
    
    if ([activityType isEqualToString:UIActivityTypeMail]) {
        return [NSData dataWithContentsOfURL:[NSURL URLWithString:self.bookSelected.pdfURL]];
    }
    else if ([activityType isEqualToString:UIActivityTypePostToTwitter]) {
        return nil;
    } else {
        return data;
    }
}

- (void)copyURL:(id)sender {
    [[UIPasteboard generalPasteboard] setURL:self.currentURL];
}

- (void)emailURL:(id)sender {
    if ([MFMailComposeViewController canSendMail] == NO) {
        return;
    }
    
    MFMailComposeViewController *viewController = [[MFMailComposeViewController alloc] init];
    viewController.mailComposeDelegate = self;
    [viewController setSubject:self.title];
    [viewController.navigationBar setTintColor:[UIColor whiteColor]];
    [viewController setMessageBody:_webView.lastRequest.mainDocumentURL.absoluteString isHTML:YES];
    [self.navigationController presentViewController:viewController animated:YES completion:^{
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
    }];
    
}

#pragma mark - Private

- (void)_updateBrowserUI {
    _backBarButton.enabled = [_webView canGoBack];
    _forwardBarButton.enabled = [_webView canGoForward];
    
    UIBarButtonItem *reloadButton = nil;
    
    if ([_webView isLoadingPage]) {
        [_indicator startAnimating];
        reloadButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"stop-button"] landscapeImagePhone:[UIImage imageNamed:@"stop-button-mini"] style:UIBarButtonItemStylePlain target:_webView action:@selector(stopLoading)];
    } else {
        [_indicator stopAnimating];
        reloadButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"reload-button"] landscapeImagePhone:[UIImage imageNamed:@"reload-button-mini"] style:UIBarButtonItemStylePlain target:_webView action:@selector(reload)];
    }
    reloadButton.imageInsets = UIEdgeInsetsMake(3.0f, 0.0f, 0.0f, 0.0f);
    
    NSMutableArray *items = [self.toolbarItems mutableCopy];
    [items replaceObjectAtIndex:4 withObject:reloadButton];
    self.toolbarItems = items;
}

#pragma mark - GMWebVieDelegate

- (void)webViewDidStartLoadingPage:(GMWebView *)aWebView {
    NSURL *url = _webView.lastRequest.mainDocumentURL;
    //    self.title = url.absoluteString;
    [self _updateBrowserUI];
    
    [self.navigationController setToolbarHidden:[url isFileURL] animated:YES];
}

- (void)webViewDidLoadDOM:(GMWebView *)aWebView {
    NSString *title = [_webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    if (title && title.length > 0) {
        self.title = title;
    }
}

- (void)webViewDidFinishLoadingPage:(GMWebView *)aWebView {
    [self _updateBrowserUI];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    
    [webView.scrollView setContentSize: CGSizeMake(webView.frame.size.width + 25, webView.scrollView.contentSize.height)];
    
}

#pragma mark - UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        [self copyURL:actionSheet];
    } else if (buttonIndex == 1 && [MFMailComposeViewController canSendMail]) {
        [self emailURL:actionSheet];
    }
}


#pragma mark - MFMailComposeViewControllerDelegate

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {
    [controller dismissViewControllerAnimated:YES completion:nil];
    
    if (result == MFMailComposeResultSent) {
        [self alertWithTitle:@"Sent" andMessage:nil];
    }
    else if (result == MFMailComposeResultCancelled) {
        [self.navigationController setToolbarHidden:NO];
    }
}


#pragma mark - Alert
- (void)alertWithTitle:(NSString *)title andMessage:(NSString *)message {
    if ([UIDevice currentDevice].systemVersion.floatValue < 8.) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    } else {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancel =[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
        [alert addAction:cancel];
        [self presentViewController:alert animated:YES completion:nil];
    }
}

@end
