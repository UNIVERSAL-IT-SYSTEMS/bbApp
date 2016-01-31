//
//  ArchiveShareViewController.m
//  Kabbalah
//
//  Created by Rockstar. on 9/12/12.
//  Copyright (c) 2012 Bnei Baruch USA. All rights reserved.
//

#import "ArchiveShareViewController.h"
#import <FacebookSDK/FacebookSDK.h>
#import "Bnei_BaruchAppDelegate.h"

NSString *const kPlaceholderArchivePostMessage = @"Say something about this...";
@interface ArchiveShareViewController ()

@property (retain, nonatomic) IBOutlet UITextView *postMessageTextView;

@property (retain, nonatomic) IBOutlet UIImageView *postImageView;

@property (retain, nonatomic) IBOutlet UILabel *postNameLabel;

@property (retain, nonatomic) IBOutlet UILabel *postCaptionLabel;

@property (retain, nonatomic) IBOutlet UILabel *postDescriptionLabel;

@property (strong, nonatomic) NSMutableDictionary *postParams;
@property (strong, nonatomic) NSMutableData *imageData;
@property (strong, nonatomic) NSURLConnection *imageConnection;

@end

@implementation ArchiveShareViewController
@synthesize postMessageTextView = _postMessageTextView;
@synthesize postImageView = _postImageView;
@synthesize postNameLabel = _postNameLabel;
@synthesize postCaptionLabel = _postCaptionLabel;
@synthesize postDescriptionLabel = _postDescriptionLabel;
@synthesize postParams = _postParams;
@synthesize imageData = _imageData;
@synthesize imageConnection = _imageConnection;

- (IBAction)cancelButtonAction {
    
    [[self presentingViewController]
     dismissViewControllerAnimated:YES completion:nil];
}

- (void)resetPostMessage
{
    self.postMessageTextView.text = kPlaceholderArchivePostMessage;
    self.postMessageTextView.textColor = [UIColor lightGrayColor];
}


- (void)textViewDidBeginEditing:(UITextView *)textView
{
    // Clear the message text when the user starts editing
    if ([textView.text isEqualToString:kPlaceholderArchivePostMessage]) {
        textView.text = @"";
        textView.textColor = [UIColor blackColor];
    }
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    // Reset to placeholder text if the user is done
    // editing and no message has been entered.
    if ([textView.text isEqualToString:@""]) {
        [self resetPostMessage];
    }
}

/*
 * A simple way to dismiss the message text view:
 * whenever the user clicks outside the view.
 */
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *) event
{
    UITouch *touch = [[event allTouches] anyObject];
    if ([self.postMessageTextView isFirstResponder] &&
        (self.postMessageTextView != touch.view))
    {
        [self.postMessageTextView resignFirstResponder];
    }
}

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
    self.postParams =
    [[NSMutableDictionary alloc] initWithObjectsAndKeys:
     @"http://kabbalahmedia.info", @"link",
     @"http://i1051.photobucket.com/albums/s422/kabbalahapp/9d00fa7b.png", @"picture",
     @"Free Kabbalah Lessons, Sources, Video and Audio Downloads", @"name",
     @"Bnei Baruch Kabbalah Education & Research Institute", @"caption",
     @"Keep up to date with the latest lessons, sources, videos and audio. ", @"description",
     nil];
    
    // Show placeholder text
    [self resetPostMessage];
    // Set up the post information, hard-coded for this sample
    self.postNameLabel.text = (self.postParams)[@"name"];
    self.postCaptionLabel.text = (self.postParams)[@"caption"];
    [self.postCaptionLabel sizeToFit];
    self.postDescriptionLabel.text = (self.postParams)[@"description"];
    [self.postDescriptionLabel sizeToFit];
    
    // Kick off loading of image data asynchronously so as not
    // to block the UI.
    self.imageData = [[NSMutableData alloc] init];
    NSURLRequest *imageRequest = [NSURLRequest
                                  requestWithURL:
                                  [NSURL URLWithString:
                                   (self.postParams)[@"picture"]]];
    self.imageConnection = [[NSURLConnection alloc] initWithRequest:
                            imageRequest delegate:self];
	// Do any additional setup after loading the view.
	// Do any additional setup after loading the view.
}

- (void)connection:(NSURLConnection*)connection
    didReceiveData:(NSData*)data{
    [self.imageData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection{
    // Load the image
    self.postImageView.image = [UIImage imageWithData:
                                [NSData dataWithData:self.imageData]];
    self.imageConnection = nil;
    self.imageData = nil;
}

- (void)connection:(NSURLConnection *)connection
  didFailWithError:(NSError *)error{
    self.imageConnection = nil;
    self.imageData = nil;
}

- (IBAction)shareButtonAction:(id)sender {
    // Hide keyboard if showing when button clicked
    if ([self.postMessageTextView isFirstResponder]) {
        [self.postMessageTextView resignFirstResponder];
    }
    // Add user message parameter if user filled it in
    if (![self.postMessageTextView.text
          isEqualToString:kPlaceholderArchivePostMessage] &&
        ![self.postMessageTextView.text isEqualToString:@""]) {
        (self.postParams)[@"message"] = self.postMessageTextView.text;
    }
    [FBRequestConnection
     startWithGraphPath:@"me/feed"
     parameters:self.postParams
     HTTPMethod:@"POST"
     completionHandler:^(FBRequestConnection *connection,
                         id result,
                         NSError *error) {
         NSString *alertText;
         if (error) {
             alertText = [NSString stringWithFormat:@"There seems to be a problem. Please check the settings to make sure you are logged in."];
         } else {
             alertText = [NSString stringWithFormat:
                          @"Posted action, id: %@",
                          result[@"id"]];
         }
         // Show the result in an alert
         BlockAlertView *alert = [BlockAlertView alertWithTitle:@"Result" message:alertText];
         
         [alert setDestructiveButtonWithTitle:@"OK" block:nil];
         [alert show];
     }];
}


- (void)viewDidUnload
{
    [self setPostMessageTextView:nil];
    [self setPostImageView:nil];
    [self setPostNameLabel:nil];
    [self setPostCaptionLabel:nil];
    [self setPostDescriptionLabel:nil];
    [super viewDidUnload];
    
    if (self.imageConnection) {
        [self.imageConnection cancel];
        self.imageConnection = nil;
    }
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void) alertView:(UIAlertView *)alertView
didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    [[self presentingViewController]
     dismissViewControllerAnimated:YES completion:nil];
}



@end
