//
//  ITRootObjectsSource.h
//  CaseManagement
//
//  Created by Admin on 20.11.14.
//  Copyright (c) 2014 Information Technologies Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ITRootModelObject.h"

@protocol ITRootObjectsSource <NSObject>

@required
- (BOOL)hasNext;
- (BOOL)hasPrev;
- (void)navigateNext: (UIViewController *)controller;
- (void)navigatePrev: (UIViewController *)controller;

@end
