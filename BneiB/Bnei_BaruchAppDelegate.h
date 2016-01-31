//
//  Bnei_BaruchAppDelegate.h
//  Kabbalah
//
//  Created by MexRockstar.
//  Copyright (c) 2012 Bnei Baruch USA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TestFlight.h"
//#import <FacebookSDK/FacebookSDK.h>
#import "LocalyticsSession.h"
#import "LocalyticsUtilities.h"

@interface Bnei_BaruchAppDelegate : UIResponder <UIApplicationDelegate, UITabBarControllerDelegate, UITabBarDelegate, UIActionSheetDelegate, MFMailComposeViewControllerDelegate>
{
   UIBackgroundTaskIdentifier bgTask; 
}


@property (strong, nonatomic) UIWindow *window;

//+ (Bnei_BaruchAppDelegate *)sharedAppDelegate;

-(void)customizeiPadTheme;

-(void)customizeiPhoneTheme;

-(void)iPadInit;


//@property (strong, nonatomic) FBSession *session;

//extern NSString *const FBSessionStateChangedNotification;

//- (void) openSessionCheckCache:(BOOL)check;

//- (void) closeSession;

@end
