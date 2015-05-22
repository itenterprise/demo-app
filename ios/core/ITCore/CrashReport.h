//
//  CrashReport.h
//  ITCore
//
//  Created by Admin on 19.03.15.
//  Copyright (c) 2015 Information Technologies Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CrashReport : NSObject

+ (NSDictionary*)createReport:(NSException*)exception;

@end
