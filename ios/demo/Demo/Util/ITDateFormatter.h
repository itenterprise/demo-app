//
//  ITDateFormatter.h
//  CaseManagement
//
//  Created by Администратор on 5/21/14.
//  Copyright (c) 2014 Information Technologies Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
/*
 * Форматирование дат
 */
@interface ITDateFormatter : NSObject

+ (ITDateFormatter*) sharedInstance;

- (NSString *) format: (NSDate *)date;
- (NSString *) formatDate: (NSDate *)date;
- (NSDate *)tommorowDateForTask;
- (NSString *) formatDateWithTime: (NSDate *)date;

@end
