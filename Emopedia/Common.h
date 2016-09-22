//
//  Common.h
//  Emopedia
//
//  Created by Eric Liang on 4/14/15.
//  Copyright (c) 2015 Xiaoyong Liang. All rights reserved.
//

#ifndef Emopedia_Common_h
#define Emopedia_Common_h

#define iPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)
#define iPhone6 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(750, 1334), [[UIScreen mainScreen] currentMode].size) : NO)
#define iPhone6Plus ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242, 2208), [[UIScreen mainScreen] currentMode].size) : NO)

#define iOS8_3  ([[[UIDevice currentDevice] systemVersion] compare:@"8.3" options:NSNumericSearch] != NSOrderedAscending)


#define SYSTEM_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)


//user default keys
#define USER_DEFAULT_KEY_ACTIVE_UNICODE_CATEGORIES @"active_categories"
#define USER_DEFAULT_KEY_FREQUENTLY_USED @"frequently_used"
#define USER_DEFAULT_KEY_MORE_CATEGORIES @"more_categories"

#import "Chameleon.h"

#define COLOR_DEFAULT FlatPoisonBlusher
#define FONT_DEFAULT_WITH_SIZE(v) [UIFont fontWithName:@"CaeciliaLTStd-Roman" size:v]
#endif
