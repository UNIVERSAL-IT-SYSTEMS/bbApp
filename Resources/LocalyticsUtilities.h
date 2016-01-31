//
//  LocalyticsUtilities.h
//  Kabbalah
//
//  Created by Rockstar. on 5/29/13.
//  Copyright (c) 2013 Bnei Baruch USA. All rights reserved.
//

#ifndef ANALYTICS_ENABLED
#define ANALYTICS_ENABLED (!DEBUG && !TARGET_IPHONE_SIMULATOR)
#endif

#if ANALYTICS_ENABLED
#import "LocalyticsSession.h"
#endif

void LLStartSession(NSString *key);
void LLTagEvent(NSString *name);
void LLTagEventWithAttributes(NSString *name, NSDictionary *attributes);
void LLTagScreen(NSString *name);
