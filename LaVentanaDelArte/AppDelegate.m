//
//  AppDelegate.m
//  LaVentanaDelArte
//
//  Created by Ruben Jeronimo Fernandez on 11/07/14.
//  Copyright (c) 2014 IronHack. All rights reserved.
//

#import "AppDelegate.h"
#import "EspaciosTableViewController.h"
#import "EventosViewController.h"
#import "CoreDataStack.h"
@interface AppDelegate ()
@property (nonatomic,strong) NSManagedObjectContext *contexto;
@property (nonatomic,strong) NSManagedObjectModel *modelo;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@end


@implementation AppDelegate
@synthesize contexto = _contexto;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;




- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    CoreDataStack *coredataStack = [CoreDataStack coreDataStackWithModelName:@"Modelo"];
    
    UITabBarController *tabBarController = (UITabBarController *)self.window.rootViewController;
    

    EspaciosTableViewController *tablaVC = (EspaciosTableViewController *)[[tabBarController.viewControllers objectAtIndex:1]topViewController];
    tablaVC.contexto = coredataStack.context;
    
    
    EventosViewController *evenVC = (EventosViewController*)[(UINavigationController*)[tabBarController.viewControllers objectAtIndex:0] topViewController];
    evenVC.contexto = coredataStack.context;
    
    EspaciosTableViewController *eventosVC = (EspaciosTableViewController *)[[tabBarController.viewControllers objectAtIndex:1]topViewController];
    eventosVC.contexto = coredataStack.context;
    
    return YES;
}

- (NSURL *) applicationDocumentsDirectory{
    return  [[[NSFileManager defaultManager]URLsForDirectory:NSDocumentationDirectory inDomains:NSUserDomainMask]firstObject];
}


- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
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
