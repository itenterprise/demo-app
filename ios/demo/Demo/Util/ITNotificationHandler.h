//
//  ITNotificationHandler.h
//  CaseManagement
//
//  Created by Администратор on 7/4/14.
//  Copyright (c) 2014 Information Technologies Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ITAppDelegate.h"
#import "ITLoginControllerDelegate.h"

/*
 * Обработка push-уведомлений
 */
@interface ITNotificationHandler : NSObject <UIAlertViewDelegate, ITLoginControllerDelegate>

// Параметры push-уведомления (словарь, полученный из уведомления)
@property (nonatomic, strong) NSDictionary * notificationParameters;
// Обработать push-уведомление
- (void) handleWithAppDelegate: (ITAppDelegate *)delegate usingAlert:(BOOL)withAlert;

@end
