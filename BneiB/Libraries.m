//
//  Libraries.m
//  Kabbalah
//
//  Created by Rockstar. on 8/6/12.
//  Copyright (c) 2012 Bnei Baruch USA. All rights reserved.
//

#import "Libraries.h"

@interface Libraries ()

@end

@implementation Libraries
@synthesize webView, activityIndicator;

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
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
    
    
    internetReach = [Reachability reachabilityForInternetConnection];
    [internetReach startNotifier];
    NetworkStatus netStatus = [internetReach currentReachabilityStatus];
    
    switch (netStatus)
    {
        case ReachableViaWWAN:
        {
            break;
        }
        case ReachableViaWiFi:
        {
            break;
        }
        case NotReachable:
        {
            //            BlockAlertView *alert = [BlockAlertView alertWithTitle:@"Alert" message:@"No 3G/WiFi detected. Some functionality will be limited until a connection is made."];
            //            
            //            [alert setDestructiveButtonWithTitle:@"OK" block:nil];
            //            [alert show];
            break;
        }
            
    }
    
    /*NSString *fullURL = @"http://edu.kabbalah.info/register-free";
     NSURL *url = [NSURL URLWithString:fullURL];
     NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
     [webView loadRequest:requestObj];*/
    
    ///////Local Web View///////
    [webView loadRequest:[NSURLRequest requestWithURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"libraries" ofType:@"html" inDirectory:NO]]]];
    // Do any additional setup after loading the view.
}

-(void)loading {
    if (!webView.loading) {
        [activityIndicator stopAnimating];
    }
    else {
        [activityIndicator startAnimating];
    }
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void) reachabilityChanged: (NSNotification* )note
{
    Reachability* curReach = [note object];
    NSParameterAssert([curReach isKindOfClass: [Reachability class]]);
    
    NetworkStatus netStatus = [curReach currentReachabilityStatus];
    switch (netStatus)
    {
        case ReachableViaWWAN:
        {
            break;
        }
        case ReachableViaWiFi:
        {
            break;
        }
        case NotReachable:
        {
            //            BlockAlertView *alert = [BlockAlertView alertWithTitle:@"Alert" message:@"No 3G/WiFi detected. Some functionality will be limited until a connection is made."];
            //            
            //            [alert setDestructiveButtonWithTitle:@"OK" block:nil];
            //            [alert show];
            break;
        }
    }
}


- (IBAction)openActionSheet{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Open in Safari", nil];
    [actionSheet showInView:self.view];
}

- (void)actionSheet: (UIActionSheet *) actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0) {
        NSURL * currentURL = [webView.request URL];
        [[UIApplication sharedApplication] openURL:currentURL];
        
    }
    
}


@end
