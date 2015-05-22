//
//  AppDelegate.m
//  Demo
//
//  Created by Admin on 22.01.15.
//  Copyright (c) 2015 IT-Enterprise. All rights reserved.
//

#import "AppDelegate.h"
#import "ITMenuViewController.h"
#import "SlideNavigationController.h"
#import "ITDemoManager.h"
#import <CoreData/CoreData.h>

@interface AppDelegate ()

@end

@implementation AppDelegate

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (NSManagedObjectContext *)managedObjectContext
{
    if (_managedObjectContext != nil)
    {
        return _managedObjectContext;
    }
    NSPersistentStoreCoordinator * coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil)
    {
        _managedObjectContext = [NSManagedObjectContext new];
        [_managedObjectContext setPersistentStoreCoordinator: coordinator];
    }
    return  _managedObjectContext;
}

- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel != nil)
    {
        return _managedObjectModel;
    }
    NSURL * modelUrl = [[NSBundle mainBundle] URLForResource:@"Model" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelUrl];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *) persistentStoreCoordinator
{
    if (_persistentStoreCoordinator)
    {
        return _persistentStoreCoordinator;
    }
    NSURL * storeUrl = [NSURL fileURLWithPath:[[self applicationDocumentsDirectory] stringByAppendingPathComponent:@"demo.sqlite"]];
    NSError * error = nil;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel: [self managedObjectModel]];
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeUrl options:nil error:&error])
    {
        
    }
    return _persistentStoreCoordinator;
}

- (NSString *)applicationDocumentsDirectory
{
    NSLog(@"%@", [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject]);
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [super application:application didFinishLaunchingWithOptions:launchOptions];
    // Создание выезжающего меню
    _menuController = (ITMenuViewController*)[[ITDemoManager sharedManager].storyboard
                                              instantiateViewControllerWithIdentifier: @"ITMenuViewController"];;
    ITMenuViewController *leftMenu = _menuController;
    [SlideNavigationController sharedInstance].leftMenu = leftMenu;
    [SlideNavigationController sharedInstance].enableShadow = YES;
    [SlideNavigationController sharedInstance].avoidSwitchingToSameClassViewController = YES;
    [SlideNavigationController sharedInstance].rightBarButtonItem = nil;
    BOOL iPad = [ITDemoManager sharedManager].iPad;
    [SlideNavigationController sharedInstance].landscapeSlideOffset = iPad ? 600 : 300;
    if (iPad)
    {
        [SlideNavigationController sharedInstance].portraitSlideOffset = 500;
    }
    return YES;
}

/*
 * Открыли приложение с помощью ссылки
 */
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    NSString * enterprisePrefix = @"demo.2015.ent.itconfig";
    NSString * appStorePrefix = @"demo.2015.itconfig";
    NSString * httpScheme = @"http";
    NSString * itUrl = @"";
    // Заменить схему на http
    if ([url.absoluteString rangeOfString:enterprisePrefix].location != NSNotFound)
    {
        itUrl = [url.absoluteString stringByReplacingOccurrencesOfString:enterprisePrefix withString:httpScheme];
    }
    else if ([url.absoluteString rangeOfString:appStorePrefix].location != NSNotFound)
    {
        itUrl = [url.absoluteString stringByReplacingOccurrencesOfString:appStorePrefix withString:httpScheme];
    }
    if (![itUrl isEqualToString:@""])
    {
        [self setDefaultUrl:itUrl];
    }
    return YES;
}

@end
