//
//  AppDelegate.m
//  LaVentanaDelArte
//
//  Created by Ruben Jeronimo Fernandez on 11/07/14.
//  Copyright (c) 2014 IronHack. All rights reserved.
//

#import "AppDelegate.h"
#import "MainTabBarControllerDelegate.h"
#import "EspaciosTableViewController.h"
#import "EventosViewController.h"
#import "CoreDataStack.h"
@interface AppDelegate ()
@property (nonatomic,strong)MainTabBarControllerDelegate *tabBarControllerDelegate;
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
        

    
    
    self.tabBarControllerDelegate = [[MainTabBarControllerDelegate alloc]init];
    
    UITabBarController *tabBarController = (UITabBarController *)self.window.rootViewController;
    tabBarController.delegate = self.tabBarControllerDelegate;
    

    EspaciosTableViewController *tablaVC = (EspaciosTableViewController *)[[tabBarController.viewControllers objectAtIndex:1]topViewController];
    tablaVC.contexto = coredataStack.context;
    
    
//    EventosViewController *evenVC = (EventosViewController*)[[tabBarController.viewControllers objectAtIndex:0]topViewController];
//    evenVC.contexto = coredataStack.context;
    
    
    NSURL *docURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"FirstDocument"];
    UIManagedDocument *miModelo = [[UIManagedDocument alloc]initWithFileURL:docURL];

    
    if ([[NSFileManager defaultManager] fileExistsAtPath:[docURL path]]) {
        [miModelo openWithCompletionHandler:^(BOOL success){
            if (!success) {
                // Handle the error.
            }
        }];
    }
    else {
        [miModelo saveToURL:docURL forSaveOperation:UIDocumentSaveForCreating completionHandler:^(BOOL success){
            if (!success) {
                // Handle the error.
            }
        }];
    }
   EspaciosTableViewController *eventosVC = (EspaciosTableViewController *)[[tabBarController.viewControllers objectAtIndex:1]topViewController];
    eventosVC.miModelo = miModelo;
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
