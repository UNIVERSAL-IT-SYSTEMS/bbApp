//
//  GMWebView.h
//  Hipster
//
//  Created by Rockstar. on 8/17/14.
//  Copyright (c) 2014 Bnei Baruch. All rights reserved.
//

@protocol GMWebViewDelegate;

@interface GMWebView: UIView <UIWebViewDelegate>

@property (nonatomic, assign) BOOL shadowsHidden;
@property (nonatomic, assign) id<GMWebViewDelegate> delegate;

- (void)loadData:(NSData *)data MIMEType:(NSString *)MIMEType textEncodingName:(NSString *)textEncodingName baseURL:(NSURL *)baseURL;
- (void)loadHTMLString:(NSString *)string baseURL:(NSURL *)baseURL;
- (void)loadRequest:(NSURLRequest *)aRequest;
- (void)loadHTMLString:(NSString *)string;
- (void)loadURL:(NSURL *)aURL;
- (void)loadURLString:(NSString *)string;

@property (nonatomic, strong, readonly) NSURLRequest *request;
@property (nonatomic, strong, readonly) NSURLRequest *lastRequest;
@property (nonatomic, readonly, getter = isLoading) BOOL loading;
@property (nonatomic, readonly, getter = isLoadingPage) BOOL loadingPage;

- (void)stopLoading;
- (void)reload;

@property (nonatomic, readonly) BOOL canGoBack;
@property (nonatomic, readonly) BOOL canGoForward;

- (void)goBack;
- (void)goForward;

@property (nonatomic, assign) BOOL scalesPageToFit;
@property (nonatomic, strong, readonly) UIScrollView *scrollView;

- (NSString *)stringByEvaluatingJavaScriptFromString:(NSString *)script;

@property (nonatomic, assign) BOOL consoleEnabled;
@property (nonatomic, assign) UIDataDetectorTypes dataDetectorTypes;
@property (nonatomic, assign) BOOL allowsInLineMediaPlayback;
@property (nonatomic, assign) BOOL mediaPlaybackRequiresUserAction;

- (void)dismissKeyboard;
- (void)removeTextSelection;
- (void)reset;

@end

@protocol GMWebViewDelegate <NSObject>

@optional

- (void)webViewDidStartLoadingPage:(GMWebView *)aWebView;
- (void)webViewDidLoadDOM:(GMWebView *)aWebView;
- (void)webViewDidFinishLoadingPage:(GMWebView *)aWebView;
- (void)webView:(GMWebView *)aWebView didFailLoadWithError:(NSError *)error;

- (BOOL)webView:(GMWebView *)aWebView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType;

- (void)webViewDidFinishLoad:(GMWebView *)aWebView;
- (void)webViewDidStartLoad:(GMWebView *)aWebView;

@end
