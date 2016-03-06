//
//  BBInforBaseViewController.m
//  Kabbalah
//
//  Created by Gabriel Morales on 2/5/16.
//  Copyright © 2016 Bnei Baruch USA. All rights reserved.
//

#import "BBInforBaseViewController.h"
#import "GMWebView.h"

@interface BBInforBaseViewController ()

@end

@implementation BBInforBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _webView = [[GMWebView alloc] initWithFrame:self.view.bounds];
    _webView.translatesAutoresizingMaskIntoConstraints = NO;
    _webView.backgroundColor = [UIColor kabStaticColor];
    _webView.delegate = self;
    _webView.scalesPageToFit = YES;
    _webView.scrollView.showsHorizontalScrollIndicator = NO;
    [_webView.scrollView setZoomScale:1.0 animated:YES];
    [self.view addSubview:_webView];
    
    NSDictionary *views = NSDictionaryOfVariableBindings(_webView);
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_webView]|" options:kNilOptions metrics:nil views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_webView]|" options:kNilOptions metrics:nil views:views]];
    
    UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    indicator.hidesWhenStopped = YES;
    [indicator stopAnimating];
    self.activityIndicator = indicator;
    
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithCustomView:indicator];
    self.navigationItem.rightBarButtonItem = rightButton;
    
    timer = [NSTimer scheduledTimerWithTimeInterval: (0.5)
                                             target:self
                                           selector:@selector(loading)
                                           userInfo:Nil
                                            repeats:YES];
    
    [self loadWebViewWithPath:_webPath];
    
}

-(void)loading {
    if (!_webView.loading) {
        [_activityIndicator stopAnimating];
    }
    else {
        [_activityIndicator startAnimating];
    }
}


- (void)loadWebViewWithPath:(NSString *)path {
    _webPath = path;
    if (_webPath != nil) {
        NSURL *url = [NSURL fileURLWithPath:_webPath isDirectory:NO];
//        NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:60];
        [_webView loadURL:url];
    }
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (void)checkInternet {
    _internetReach = [Reachability reachabilityForInternetConnection];
    [_internetReach startNotifier];
    NetworkStatus netStatus = [_internetReach currentReachabilityStatus];
    switch (netStatus) {
        case ReachableViaWWAN:
        case ReachableViaWiFi: {
            break;
        }
        case NotReachable: {
            [self showAlertWithTitle:@"Alert" andMessage:@"No internet connection detected. Some functionality will be limited until a connection is made."];
            break;
        }
    }
}

- (void)showAlertWithTitle:(NSString *)title andMessage:(NSString *)message {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
    [alert addAction:cancel];
    [self presentViewController:alert animated:YES completion:nil];
}
@end
