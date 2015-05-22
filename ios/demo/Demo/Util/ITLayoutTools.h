//
//  ITFontTools.h
//  Demo
//
//  Created by Администратор on 6/20/14.
//  Copyright (c) 2014 Information Technologies Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ITEmployee.h"
#import "ITConnection.h"

extern NSInteger const kCellMargin;

/*
 * Вспомагательный класс для работы с размерами ячеек UITableView
 */
@interface ITLayoutTools : NSObject

+ (float) calcHeightForEmployee: (ITEmployee *) employee;
+ (float) calcHeightForConnection: (ITConnection *) connection withShowFullInfo: (BOOL) showFullInfo;
//+ (float) calcHeightForTask: (ITTask *) task showingStatus: (BOOL)showStatus;
//+ (float) calcHeightForDiscuss: (ITComment *)comment;
//+ (float) calcHeightForTaskDetails: (ITTask *)task;
//+ (float) calcHeightForHistory: (ITHistory *)history;
//+ (float) calcHeightForDocumentHeader: (ITDocument *)document;
//+ (float) calcHeightForCase: (ITCase *) item fullInfo:(BOOL) showFullInfo;
@end
