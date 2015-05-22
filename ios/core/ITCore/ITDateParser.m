//
//  ITDateParser.m
//  CaseManagement
//
//  Created by Администратор on 6/12/14.
//  Copyright (c) 2014 Information Technologies Ltd. All rights reserved.
//

#import "ITDateParser.h"

@implementation ITDateParser

+ (NSDate *)jsonDateToDate: (NSString*)jsonDate
{
    NSString * milliseconds = [jsonDate stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"/Date()/"]];
    return [NSDate dateWithTimeIntervalSince1970:[milliseconds doubleValue]/1000];
}

+ (NSString *)dateToJson: (NSDate*)date
{
//    [date ]
    NSTimeInterval interval = [date timeIntervalSince1970];
    //interval += [[NSTimeZone localTimeZone] secondsFromGMT];
    interval *= 1000;
    return [NSString stringWithFormat:@"/Date(%.0f)/", interval];
}

@end
