//
//  MainTabBarControllerDelegate.m
//  LaVentanaDelArte
//
//  Created by Ruben Jeronimo Fernandez on 11/07/14.
//  Copyright (c) 2014 IronHack. All rights reserved.
//

#import "MainTabBarControllerDelegate.h"

@interface MainTabBarControllerDelegate ()

@end

@implementation MainTabBarControllerDelegate
- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController{
    return YES;
}
@end
