//
//  LocalyticsUtilities.m
//  Kabbalah
//
//  Created by Rockstar. on 5/29/13.
//  Copyright (c) 2013 Bnei Baruch USA. All rights reserved.
//

#import "LocalyticsUtilities.h"

void LLStartSession(NSString *key) {
#if ANALYTICS_ENABLED
	[[LocalyticsSession sharedLocalyticsSession] startSession:(key)];
#endif
}


void LLTagEvent(NSString *name) {
#if ANALYTICS_ENABLED
	[[LocalyticsSession sharedLocalyticsSession] tagEvent:name];
#endif
}


void LLTagEventWithAttributes(NSString *name, NSDictionary *attributes) {
#if ANALYTICS_ENABLED
	[[LocalyticsSession sharedLocalyticsSession] tagEvent:name attributes:attributes];
#endif
}


void LLTagScreen(NSString *screen) {
#if ANALYTICS_ENABLED
	[[LocalyticsSession sharedLocalyticsSession] tagScreen:screen];
#endif
}