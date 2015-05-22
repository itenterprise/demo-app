//
//  ITDateParser.h
//  CaseManagement
//
//  Created by Администратор on 6/12/14.
//  Copyright (c) 2014 Information Technologies Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

/*
 * Сериализация и десериализация дат из json
 */
@interface ITDateParser : NSObject

+ (NSDate *)jsonDateToDate: (NSString*)jsonDate;
+ (NSString *)dateToJson: (NSDate*)date;
@end
