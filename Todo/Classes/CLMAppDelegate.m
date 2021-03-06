//
//  CLMAppDelegate.m
//  Todo
//
//  Created by Andrew Hulsizer on 5/23/13.
//  Copyright (c) 2013 Andrew Hulsizer. All rights reserved.
//

#import "CLMAppDelegate.h"
#import "CLMApplicationViewController.h"
#import "CLMTodoDataManager.h"
#import "CLMMenuViewController.h"
#import "CLMListsViewController.h"
#import "CLMListNavigationViewController.h"

@interface CLMAppDelegate ()

@property (nonatomic, strong) CLMApplicationViewController *applicationViewController;

@end
@implementation CLMAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.applicationViewController = [[CLMApplicationViewController alloc] init];
    
    __weak CLMApplicationViewController *weakSelf = self.applicationViewController;
    [self.applicationViewController setApplicationLaunchBlock:^(void)
    {
        //do set up in here
        CLMListsViewController *listViewController = [[CLMListsViewController alloc] init];
        weakSelf.listNavigationController = [[CLMListNavigationViewController alloc] initWithRootListViewController:listViewController];
        [weakSelf addChildViewController:weakSelf.listNavigationController];
        [weakSelf.view addSubview:weakSelf.listNavigationController.view];
        [weakSelf.listNavigationController didMoveToParentViewController:weakSelf];
        
//        weakSelf.menuViewController = [[CLMMenuViewController alloc] init];
//        [weakSelf addChildViewController:weakSelf.menuViewController];
//        [weakSelf.view addSubview:weakSelf.menuViewController.view];
//        [weakSelf.menuViewController didMoveToParentViewController:weakSelf];
        
    }];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window setRootViewController:self.applicationViewController];
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    [[CLMTodoDataManager sharedManager] saveData];
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    
}

@end
