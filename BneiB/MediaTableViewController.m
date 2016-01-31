//
//  MediaTableViewController.m
//  Kabbalah
//
//  Created by MexRockstar.
//  Copyright (c) 2012 Bnei Baruch USA. All rights reserved.
//

#import "MediaTableViewController.h"
#import "MediaParser.h"
#import "MBProgressHUD.h"
#import "Twitter/Twitter.h"
#import "ArchiveShareViewController.h"
#import "ArchiveCustomCell.h"
#import "MediaDetail.h"
#import "MediaIpadDetail.h"

@class MBProgressHUD;

@interface MediaTableViewController (PrivateMethods)
-(void)loadData;

@end

@implementation MediaTableViewController
@synthesize items;

@synthesize imageString = _imageString;
@synthesize urlString = _urlString;

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(NSUInteger)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskAllButUpsideDown;
}

-(BOOL)shouldAutorotate{
    return YES;
}

#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad
{
    [[LocalyticsSession shared] tagEvent:@"Media Main"];

    
    //HUD
    HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
	[self.navigationController.view addSubview:HUD];
	
	HUD.delegate = self;
	HUD.labelText = @"Loading";
	
	[HUD showWhileExecuting:@selector(myTask) onTarget:self withObject:nil animated:YES];
    
	// Super
	[super viewDidLoad];
    
    //UIColor *bg = [UIColor colorWithRed:27/255.0 green:135/255.0 blue:195/255.0 alpha:1.0];
    //[self.view setBackgroundColor:bg];
    
    UIColor* bgColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg_tweet_place_holder~iphone.png"]];
    [self.view setBackgroundColor:bgColor];
    
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
        
        self.title = NSLocalizedString(@"MEDIA_TITLE", nil);
    }
    
    
    
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
            
            BlockAlertView *alert = [BlockAlertView alertWithTitle:@"Alert" message:@"No 3G/WiFi detected. Some sections require internet connection."];
            
            [alert setDestructiveButtonWithTitle:@"OK" block:nil];
            [alert show];
            break;
        }
    }
    
    //UIColor* bgColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"ipad-BG-pattern.png"]];
    //[self.view setBackgroundColor:bgColor];

    
    //[TestFlight passCheckpoint:@"Opened Archive - Media"];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;

}



- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidAppear:(BOOL)animated{
    [self loadData];
    [super viewDidAppear:animated];
}

//-----------------------PARSER-------------------------//
- (void)loadData {
    if (items == nil) {
        
        MediaParser *rssParser = [[MediaParser alloc] init];
        [rssParser parseRssFeed:@"http://feeds2.feedburner.com/kabbalah-archive/ENG" withDelegate:self];
    } else {
        [self.tableView reloadData];
    }
}

- (void)receivedItems:(NSArray *)theItems {
    items = theItems;
    [self.tableView reloadData];
}



#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [items count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    static NSString *CellIdentifier = @"MediaCell";
    
    // Configure the cell...
    
    ArchiveCustomCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[ArchiveCustomCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
    }
    
    cell.medTitle.text = items[indexPath.row][@"title"];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    [dateFormatter setTimeStyle:NSDateFormatterMediumStyle];
    
    cell.medSubTitle.text = [dateFormatter stringFromDate:items[indexPath.row][@"date"]];
    
    cell.medCategory.text = items[indexPath.row][@"itunes:keywords"];

    
    
    //cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
} 


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
        
        MediaIpadDetail *itemDetail = [self.storyboard instantiateViewControllerWithIdentifier:@"MediaIpadDetail"];
        itemDetail.item = items[indexPath.row];
        [self.navigationController pushViewController:itemDetail animated:YES];
    }
    
    else if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone){
    // Show detail
    MediaDetail *itemDetail = [self.storyboard instantiateViewControllerWithIdentifier:@"MediaDetail"];
    itemDetail.item = items[indexPath.row];
    [self.navigationController pushViewController:itemDetail animated:YES];
	}
	// Deselect
	[self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark -
#pragma mark Execution code
//----------------------------HUD SETTINGS--------------------------------//
- (void)myTask {
    
    // Back to indeterminate mode
	HUD.mode = MBProgressHUDModeIndeterminate;
	HUD.labelText = @"Loading ...";
	[self.tableView reloadData];
    sleep(1);
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
		return 92;
	}
    
    return 82;
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
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert" message:@"No 3G/WiFi detected. Some functionality will be limited until a connection is made." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [alert show];
            break;
        }
    }
}

- (IBAction)openActionSheet{
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
    
    [actionSheet showInView:self.tabBarController.tabBar];
}

- (void)actionSheet: (UIActionSheet *) actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0) {
        
        if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter])
        {
            SLComposeViewController *tweetSheet = [SLComposeViewController
                                                   composeViewControllerForServiceType:SLServiceTypeTwitter];
            [tweetSheet setInitialText:@"Kabbalah Media Archive - Free Kabbalah Lessons, Sources, Video and Audio Downloads via @KabbalahApp"];
            [tweetSheet addURL:[NSURL URLWithString:@"http://www.kabbalahmedia.info/"]];
            
            tweetSheet.completionHandler = ^(SLComposeViewControllerResult result){
                [self dismissViewControllerAnimated:YES completion:nil];
                
                NSString *alertText = @"";
                if (SLComposeViewControllerResultCancelled) {
                    
                } else if (result == SLComposeViewControllerResultDone) {
                    alertText = @"Posted successfully.";
                }
                if (![alertText isEqualToString:@""]) {
                    // Show the result in an alert
                    BlockAlertView *alert = [BlockAlertView alertWithTitle:@"Result"
                                                                   message:alertText];
                    
                    [alert setDestructiveButtonWithTitle:@"OK" block:nil];
                    [alert show];
                }
            };
            
            [self presentViewController:tweetSheet animated:YES completion:nil];
        
        }
        
        /*
        TWTweetComposeViewController *tweetSheet = 
        [[TWTweetComposeViewController alloc] init];
        
        [tweetSheet setInitialText:@"Kabbalah Media Archive - Free Kabbalah Lessons, Sources, Video and Audio Downloads @KabbalahApp"];
        [tweetSheet addURL:[NSURL URLWithString:@"http://kabbalahmedia.info/"]];
        
        
        tweetSheet.completionHandler = ^(TWTweetComposeViewControllerResult result){
            [self dismissModalViewControllerAnimated:YES];
        };
        
	    [self presentModalViewController:tweetSheet animated:YES];
        
        [TestFlight passCheckpoint:@"Twitter Media"];*/

    }
    
    if (buttonIndex == 1) {
        MFMailComposeViewController * composer = [[MFMailComposeViewController alloc]init];
        [composer setMailComposeDelegate:self];
        
        if ([MFMailComposeViewController canSendMail]) {
            [composer setToRecipients:@[@""]];
            [composer setSubject:@"Found this and thought of sharing it with you."];
            NSMutableString *body = [NSMutableString string];
            [composer setMessageBody:body isHTML:YES];
            [body appendString:@"<h2>Kabbalah Media Archive</h2>"];
            [body appendString:@"<p>Free Kabbalah Lessons, Sources, Video and Audio Downloads.</p>"];
            [body appendString:@"<a href =\"http://kabbalahmedia.info\">Link</a>\n"];
            [body appendString:@"<p>"];
            [body appendString:@"Follow us on <a href =\"http://www.twitter.com/KabbalahApp\">Twitter</a></br>"];
            [body appendString:@"Like us on <a href =\"https://www.facebook.com/KabbalahApp\">Facebook</a></br>"];
            [body appendString:@"Share us on <a href =\"https://plus.google.com/u/0/b/110517944996918866621/110517944996918866621\">Google +</a>"];
            [body appendString:@"</p>"];
            [body appendString:@"<p>Via <a href =\"http://itunes.apple.com/us/app/kabbalah-app/id550938690\">Kabbalah App</a></p>\n"];
            [composer setModalTransitionStyle:UIModalTransitionStyleCoverVertical];
            [self presentViewController:composer animated:YES completion:nil];
        }
        //[TestFlight passCheckpoint:@"Email Media"];

    }
    
    if (buttonIndex == 2) {
        
        NSString *message = [NSString stringWithFormat:@"Kabbalah Media Archive. Free Kabbalah Lessons, Sources, Video and Audio Downloads | Via Kabbalah App."];
        NSURL *url = [NSURL URLWithString:@"http://kabbalahmedia.info"];
        
        if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter])
        {
            SLComposeViewController *tweetSheet = [SLComposeViewController
                                                   composeViewControllerForServiceType:SLServiceTypeTwitter];
            [tweetSheet setInitialText:message];
            [tweetSheet addURL:url];
            tweetSheet.completionHandler = ^(SLComposeViewControllerResult result){
                [self dismissViewControllerAnimated:YES completion:nil];
                
                NSString *alertText = @"";
                if (SLComposeViewControllerResultCancelled) {
                    
                } else if (result == SLComposeViewControllerResultDone) {
                    alertText = @"Posted successfully.";
                }
                if (![alertText isEqualToString:@""]) {
                    // Show the result in an alert
                    BlockAlertView *alert = [BlockAlertView alertWithTitle:@"Result"
                                                                   message:alertText];
                    
                    [alert setDestructiveButtonWithTitle:@"OK" block:nil];
                    [alert show];
                }
            };
            
            [self presentViewController:tweetSheet animated:YES completion:nil];
        
        }
        
        
        /*
        BOOL displayedNativeDialog =
        [FBNativeDialogs
         presentShareDialogModallyFrom:self
         initialText:message
         image:nil
         url:url
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
        
        ArchiveShareViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"ArchiveShareView"];
        [self presentViewController:viewController animated:YES completion:nil];
        
        [TestFlight passCheckpoint:@"Facebook. Media"];
        }*/
        
    }
    
    if (buttonIndex == 3) {
        NSURL* url = [NSURL URLWithString:@"http://kabbalahmedia.info/"];
        [[UIApplication sharedApplication] openURL:url];
        //[TestFlight passCheckpoint:@"Open in Safari Media"];

    }
}

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error{
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
    if (result == MFMailComposeResultFailed) {
        BlockAlertView *alert = [BlockAlertView alertWithTitle:@"Alert" message:@"Unable to send email"];
        
        [alert setDestructiveButtonWithTitle:@"OK" block:nil];
        [alert show];
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
    
    BlockAlertView *alert = [BlockAlertView alertWithTitle:alertTitle message:alertMsg];
    
    [alert setDestructiveButtonWithTitle:@"OK" block:nil];
    [alert show];
}

#pragma mark Memory management


- (void)viewDidUnload
{
    
    [self setTitle:nil];
    [super viewDidUnload];
    
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


@end
