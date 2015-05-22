//
//  AppDelegate.h
//  Demo
//
//  Created by Admin on 22.01.15.
//  Copyright (c) 2015 IT-Enterprise. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ITAppBaseDelegate.h"
#import "ITMenuViewController.h"

@interface AppDelegate : ITAppBaseDelegate

@property (strong, nonatomic) UIWindow *window;

@property (nonatomic, retain, readonly) NSManagedObjectModel * managedObjectModel;
@property (nonatomic, retain, readonly) NSManagedObjectContext * managedObjectContext;
@property (nonatomic, retain, readonly) NSPersistentStoreCoordinator * persistentStoreCoordinator;
@property (nonatomic, strong, readonly) ITMenuViewController * menuController;

- (NSString *) applicationDocumentsDirectory;

@end

