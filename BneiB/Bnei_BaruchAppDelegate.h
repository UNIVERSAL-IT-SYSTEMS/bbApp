//
//  Bnei_BaruchAppDelegate.h
//  Kabbalah
//
//  Created by MexRockstar.
//  Copyright (c) 2012 Bnei Baruch USA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LocalyticsUtilities.h"

@interface Bnei_BaruchAppDelegate : UIResponder <UIApplicationDelegate, UITabBarControllerDelegate, UITabBarDelegate, UIActionSheetDelegate, MFMailComposeViewControllerDelegate>
{
    UIBackgroundTaskIdentifier bgTask; 
}

@property (strong, nonatomic) UIWindow *window;

@end
