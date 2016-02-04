//
//  MediaDetail.m
//  Kabbalah
//
//  Created by Rockstar. on 12/16/12.
//  Copyright (c) 2012 Bnei Baruch USA. All rights reserved.
//

#import "MediaDetail.h"
#import "Twitter/Twitter.h"
#import "MBProgressHUD.h"

@class MBProgressHUD;
@interface MediaDetail ()

@end

@implementation MediaDetail{
    
    UIBarButtonItem *_backBarButton;
    UIBarButtonItem *_actionButton;
    UIBarButtonItem *_reloadButton;
}


@synthesize item, itemTitle, itemDate;
@synthesize imageString = _imageString;
@synthesize urlString = _urlString;
@synthesize itemSummary = _itemSummary;
@synthesize activityIndicator;


- (instancetype)initWithItem:(NSDictionary *)theItem {
    if (self = [super initWithNibName:@"MediaDetail" bundle:nil]) {
        self.item = theItem;
        self.title = item[@"title"];
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    //UIColor* bgColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg_tweet_place_holder~iphone.png"]];
    //[self.view setBackgroundColor:bgColor];
    
    UIColor *bgColor = [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1.0];
    [self.view setBackgroundColor:bgColor];
    
    _backBarButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back_arrow"] landscapeImagePhone:[UIImage imageNamed:@"back_arrow"] style:UIBarButtonItemStylePlain target:_itemSummary action:@selector(goBack)];
    _backBarButton.tintColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1.0];
    
    _actionButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(openActionSheet:)];
    _actionButton.tintColor = [UIColor colorWithRed:27/255.0 green:135/255.0 blue:195/255.0 alpha:1.0];
    
    _reloadButton = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"stop-button"] landscapeImagePhone:[UIImage imageNamed:@"stop-button"] style:UIBarButtonItemStylePlain target:_itemSummary action:@selector(reload)];
    _reloadButton.tintColor = [UIColor colorWithRed:143/255.0 green:14/255.0 blue:23/255.0 alpha:1.0];
    
    UIBarButtonItem *flexibleSpace = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    self.toolbarItems = @[_backBarButton,
                          flexibleSpace,
                          _reloadButton,
                          flexibleSpace,
                          _actionButton];
    
    for (UIBarButtonItem *button in self.toolbarItems){
        button.imageInsets = UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, 0.0f);
        
    }
    
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
    
    self.title = item[@"title"];
    _itemSummary.delegate = self;
    _itemSummary.scalesPageToFit = NO;
    
    NSString *titleHTML = [NSString stringWithFormat:@"<b>%@</b>", item[@"title"]];
    NSString *postHTML = [NSString stringWithFormat:@"<h3>%@</h3>", item[@"summary"]];
    NSLog(@"%@",postHTML);
    
    NSURL* url = [NSURL URLWithString:item[@"link"]];
    [_itemSummary loadRequest:[NSURLRequest requestWithURL:url]];
    
    NSString *structure =[NSString stringWithFormat:@"<html><head><link rel=\"stylesheet\" type=\"text/css\"href=\"media.css\" ></style></head><body><section id='container'><section id='Blog'>"];
    
    NSString *close =[NSString stringWithFormat:@"</section></body></html>"];
    
    NSString *HTMLString = [NSString stringWithFormat:@"%@<article><hr><blockquote class='headline-blockquote'>%@</blockquote>%@<hr>%@", structure, titleHTML, postHTML, close];
    
    NSString *path = [[NSBundle mainBundle] bundlePath];
    NSURL *baseURL = [NSURL fileURLWithPath:path];
    [_itemSummary loadHTMLString:HTMLString baseURL:baseURL];
    
    //[TestFlight passCheckpoint:@"Archive Media - Detail View"];
    
    
    //NSURL* url = [NSURL URLWithString:[item objectForKey:@"link"]];
    //[itemSummary loadRequest:[
    
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setToolbarHidden:NO animated:animated];
}


- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setToolbarHidden:YES animated:animated];
}

#pragma mark - Private
-(void)loading {
    _backBarButton.enabled = [_itemSummary canGoBack];
    _backBarButton.tintColor = [UIColor colorWithRed:27/255.0 green:135/255.0 blue:195/255.0 alpha:1.0];
    
    UIBarButtonItem *reloadButton = nil;
    if (!_itemSummary.loading) {
        
        [activityIndicator stopAnimating];
        //reloadButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"reload-button"] landscapeImagePhone:[UIImage imageNamed:@"reload-button"] style:UIBarButtonItemStylePlain target:_itemSummary action:@selector(reload)];
        reloadButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"reload-button"] landscapeImagePhone:[UIImage imageNamed:@"reload-button"] style:UIBarButtonItemStylePlain target:_itemSummary action:@selector(reload)];
        reloadButton.tintColor = [UIColor colorWithRed:27/255.0 green:135/255.0 blue:195/255.0 alpha:1.0];
        _actionButton.enabled = YES;
    }
    else {
        [activityIndicator startAnimating];
        //reloadButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"stop-button"] landscapeImagePhone:[UIImage imageNamed:@"stop-button"] style:UIBarButtonItemStylePlain target:_itemSummary action:@selector(stopLoading)];
        reloadButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"stop-button"] landscapeImagePhone:[UIImage imageNamed:@"stop-button"] style:UIBarButtonItemStylePlain target:_itemSummary action:@selector(stopLoading)];
        reloadButton.tintColor = [UIColor colorWithRed:143/255.0 green:14/255.0 blue:23/255.0 alpha:1.0];
        _actionButton.enabled = NO;
    }
    reloadButton.imageInsets = UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, 0.0f);
    
    NSMutableArray *items = [self.toolbarItems mutableCopy];
    items[2] = reloadButton;
    self.toolbarItems = items;
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
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



//-------------------TWITTER-----------------------------------//

/*- (IBAction)tweetTapped:(id)sender {
 if ([TWTweetComposeViewController canSendTweet])
 {
 TWTweetComposeViewController *tweetSheet =
 [[TWTweetComposeViewController alloc] init];
 [tweetSheet setInitialText:self.title];
 
 [tweetSheet addImage:[UIImage imageNamed:@"laitman.png"]];
 
 [tweetSheet addURL:[NSURL URLWithString:@"http://bit.ly/NRD55z"]];
 
 
 tweetSheet.completionHandler = ^(TWTweetComposeViewControllerResult result){
 [self dismissModalViewControllerAnimated:YES];
 };
 
 [self presentModalViewController:tweetSheet animated:YES];
 }
 else
 {
 UIAlertView *alertView = [[UIAlertView alloc]
 initWithTitle:@"Sorry"
 message:@"You can't send a tweet right now, make sure your device has an internet connection and you have at least one Twitter account setup"
 delegate:self
 cancelButtonTitle:@"OK"
 otherButtonTitles:nil];
 [alertView show];
 }
 }*/

- (void)openActionSheet:(id)sender{
    
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                  initWithTitle:@""
                                  delegate:self
                                  cancelButtonTitle:@"Cancel"
                                  destructiveButtonTitle:nil
                                  otherButtonTitles:
                                  NSLocalizedString(@"TWITTER", nil),
                                  NSLocalizedString(@"EMAIL", nil),
                                  NSLocalizedString(@"FACEBOOK",nil),
                                  NSLocalizedString(@"SAFARI",nil),
                                  nil];
    
    [actionSheet showFromTabBar:self.tabBarController.tabBar];
}

- (void)actionSheet: (UIActionSheet *) actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0) {
        NSString *message = [NSString stringWithFormat:@"Check out: %@. via @KabbalahApp",item[@"guid"]];
        NSString *urlString = item[@"guid"];
        
        if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter])
        {
            SLComposeViewController *tweetSheet = [SLComposeViewController
                                                   composeViewControllerForServiceType:SLServiceTypeTwitter];
            [tweetSheet setInitialText:message];
            [tweetSheet addURL:[NSURL URLWithString:urlString]];
            
            [tweetSheet setCompletionHandler:^(SLComposeViewControllerResult result) {
                
                switch (result) {
                    case SLComposeViewControllerResultCancelled:
                        NSLog(@"Post Canceled");
                        break;
                    case SLComposeViewControllerResultDone:
                        NSLog(@"Post Sucessful");
                        break;
                        
                    default:
                        break;
                }
            }];
            
            
            [self presentViewController:tweetSheet animated:YES completion:nil];
        }
        
        /*
         TWTweetComposeViewController *tweetSheet =
         [[TWTweetComposeViewController alloc] init];
         
         [tweetSheet setInitialText:message];
         self.urlString = [item objectForKey:@"guid"];
         [tweetSheet addURL:[NSURL URLWithString:self.urlString]];
         
         
         tweetSheet.completionHandler = ^(TWTweetComposeViewControllerResult result){
         [self dismissModalViewControllerAnimated:YES];
         };
         
         [self presentModalViewController:tweetSheet animated:YES];*/
        //[TestFlight passCheckpoint:@"Twitter Archive Media"];
    }
    
    if (buttonIndex == 1) {
        MFMailComposeViewController * composer = [[MFMailComposeViewController alloc]init];
        [composer setMailComposeDelegate:self];
        
        if ([MFMailComposeViewController canSendMail]) {
            [composer setToRecipients:@[@""]];
            [composer setSubject:self.title];
            NSMutableString *body = [NSMutableString string];
            [composer setMessageBody:body isHTML:YES];
            [body appendString:@"<h2>"];
            [body appendString:self.title];
            [body appendString:@"</h2>"];
            [body appendString:@"<p>"];
            [body appendString:item[@"summary"]];
            [body appendString:@"</p>"];
            [body appendString:@"<a href =\""];
            [body appendString:item[@"guid"]];
            [body appendString:@"\"> Link</a>\n"];
            [body appendString:@"<p>"];
            [body appendString:@"Follow us on <a href =\"http://www.twitter.com/KabbalahApp\">Twitter</a></br>"];
            [body appendString:@"Like us on <a href =\"https://www.facebook.com/KabbalahApp\">Facebook</a></br>"];
            [body appendString:@"Share us on <a href =\"https://plus.google.com/u/0/b/110517944996918866621/110517944996918866621\">Google +</a>"];
            [body appendString:@"</p>"];
            [body appendString:@"<p>Via <a href =\"http://itunes.apple.com/us/app/kabbalah-app/id550938690\">Kabbalah App</a></p>\n"];
            [composer setModalTransitionStyle:UIModalTransitionStyleCoverVertical];
            [self presentViewController:composer animated:YES completion:nil];
        }
        //[TestFlight passCheckpoint:@"Email Archive Media"];
    }
    
    if (buttonIndex == 2) {
        
        self.urlString = item[@"guid"];
        NSString *message = [NSString stringWithFormat:@"Check out %@. Via Kabbalah App",item[@"title"]];
        NSURL* url = [NSURL URLWithString:self.urlString];
        
        if([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook]) {
            
            SLComposeViewController *controller = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
            
            [controller setInitialText:message];
            [controller addURL:url];
            
            [controller setCompletionHandler:^(SLComposeViewControllerResult result) {
                
                switch (result) {
                    case SLComposeViewControllerResultCancelled:
                        NSLog(@"Post Canceled");
                        break;
                    case SLComposeViewControllerResultDone:
                        NSLog(@"Post Sucessful");
                        break;
                        
                    default:
                        break;
                }
            }];
            
            [self presentViewController:controller animated:YES completion:Nil];
            
        }
        //NSURL* url = [NSURL URLWithString:[item objectForKey:@"link"]];
        
        /*
         BOOL displayedNativeDialog =
         [FBNativeDialogs
         presentShareDialogModallyFrom:self
         initialText:message
         image:nil
         url:[NSURL URLWithString:self.urlString]
         handler:^(FBNativeDialogResult result, NSError *error) {
         
         // Only show the error if it is not due to the dialog
         // not being supported, i.e. code = 7, otherwise ignore
         // because our fallback will show the share view controller.
         if (error && [error code] == 7) {
         return;
         }
         
         NSString *alertText = @"";
         if (error) {
         alertText = [NSString stringWithFormat:
         @"error: domain = %@, code = %d",
         error.domain, error.code];
         } else if (result == FBNativeDialogResultSucceeded) {
         alertText = @"Posted successfully.";
         }
         if (![alertText isEqualToString:@""]) {
         // Show the result in an alert
         BlockAlertView *alert = [BlockAlertView alertWithTitle:@"Result" message:alertText];
         
         [alert setDestructiveButtonWithTitle:@"OK" block:nil];
         [alert show];
         }
         }];
         
         // Fallback, show the view controller that will post using me/feed
         if (!displayedNativeDialog) {
         
         
         [FBSession activeSession];
         NSString *message = [NSString stringWithFormat:@"Check out %@ \n'%@' \nVia Kabbalah App",[item objectForKey:@"title"], [item objectForKey:@"guid"]];
         
         [FBRequestConnection startForPostStatusUpdate:message
         completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
         
         [self showAlert:message result:result error:error];
         
         }];
         
         //[TestFlight passCheckpoint:@"Facebook. Archive Media"];
         }*/
    }
    
    if (buttonIndex == 3) {
        NSURL* Shareurl = [NSURL URLWithString:@"http://bit.ly/NRD55z"];
        [[UIApplication sharedApplication] openURL:Shareurl];
        
        //[TestFlight passCheckpoint:@"Open in Safari. Archive Media"];
    }
}

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error{
    
    //[controller dismissModalViewControllerAnimated:YES];
    [controller dismissViewControllerAnimated:YES completion:nil];
    
    if (result == MFMailComposeResultSent) {
        //HUD
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"check.png"]];
        hud.mode = MBProgressHUDModeCustomView;
        hud.labelText = @"Sent!";
        
        [hud show:YES];
        [hud hide:YES afterDelay:2];
        
        
    }
    
    else if (result == MFMailComposeResultFailed) {
        //        BlockAlertView *alert = [BlockAlertView alertWithTitle:@"Alert" message:@"Unable to send email"];
        //        
        //        [alert setDestructiveButtonWithTitle:@"OK" block:nil];
        //        [alert show];
    }
    
}

- (void)showAlert:(NSString *)message
           result:(id)result
            error:(NSError *)error {
    
    NSString *alertMsg;
    NSString *alertTitle;
    if (error) {
        alertMsg = [NSString stringWithFormat:@"There seems to be a problem. Please check the settings to make sure you are logged in."];
        alertTitle = @"Error";
    } else {
        alertMsg = [NSString stringWithFormat:@"Successfully posted '%@'.",
                    message];
        alertTitle = @"Success";
    }
    
    //    BlockAlertView *alert = [BlockAlertView alertWithTitle:alertTitle message:alertMsg];
    //    
    //    [alert setDestructiveButtonWithTitle:@"OK" block:nil];
    //    [alert show];
}

@end
