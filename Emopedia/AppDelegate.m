//
//  AppDelegate.m
//  iOSKeyboardTemplateContainer
//
//  Created by Eric Liang on 4/14/15.
//  Copyright (c) 2015 Xiaoyong Liang. All rights reserved.
//

#import "AppDelegate.h"
#import "Common.h"
@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    [[UIBarButtonItem appearance] setTintColor:COLOR_DEFAULT];
    NSShadow *shadow = [[NSShadow alloc] init];
    shadow.shadowOffset = CGSizeMake(0.0, 1.0);
    shadow.shadowColor = [UIColor whiteColor];
    
    [[UIBarButtonItem appearanceWhenContainedIn:[UINavigationBar class], nil]
     setTitleTextAttributes:
     @{NSForegroundColorAttributeName:COLOR_DEFAULT,
       NSShadowAttributeName:shadow,
       NSFontAttributeName:[UIFont fontWithName:@"CaeciliaLTStd-Roman" size:16]
       }
     forState:UIControlStateNormal];
    [[UIBarButtonItem appearanceWhenContainedIn:[UINavigationBar class], nil]
     setTitleTextAttributes:
     @{NSForegroundColorAttributeName:[UIColor colorWithComplementaryFlatColorOf:COLOR_DEFAULT],
       NSShadowAttributeName:shadow,
       NSFontAttributeName:[UIFont fontWithName:@"CaeciliaLTStd-Roman" size:16]
       }
     forState:UIControlStateHighlighted];
    
    [[UINavigationBar appearance] setTintColor:COLOR_DEFAULT];
    
    
    
    NSUserDefaults *userdef = [[NSUserDefaults standardUserDefaults]initWithSuiteName:@"group.com.apprilo.emopediagroup"];
    NSArray *allCate = [NSArray arrayWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"Categories" withExtension:@"plist"]];
    NSDictionary *activeCateDef = [NSDictionary dictionaryWithObjectsAndKeys:[NSArray arrayWithObjects:[allCate objectAtIndex:0],[allCate objectAtIndex:1],[allCate objectAtIndex:2],[allCate objectAtIndex:15],[allCate objectAtIndex:16], [allCate objectAtIndex:17], nil], USER_DEFAULT_KEY_ACTIVE_UNICODE_CATEGORIES,nil];
    [userdef registerDefaults:activeCateDef];
    
    
    NSMutableArray *array = [NSMutableArray arrayWithObject:[NSDictionary dictionaryWithObjectsAndKeys:@"",@"Name",@"APPLE LOGO", @"Description", nil]];
    [userdef registerDefaults:[NSDictionary dictionaryWithObject:[NSArray arrayWithArray:array] forKey:USER_DEFAULT_KEY_FREQUENTLY_USED]];
    [userdef synchronize];
    [[NSUserDefaults standardUserDefaults]synchronize];
    
    NSUserDefaults *iosdef = [NSUserDefaults standardUserDefaults];
    [iosdef registerDefaults:[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:NO], USER_DEFAULT_KEY_MORE_CATEGORIES, nil]];
    [iosdef synchronize];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
