//
//  ITDateFormatter.m
//  CaseManagement
//
//  Created by Администратор on 5/21/14.
//  Copyright (c) 2014 Information Technologies Ltd. All rights reserved.
//

#import "ITDateFormatter.h"

@interface ITDateFormatter ()

@property(strong, nonatomic) NSDateFormatter * formatter;
@property(strong, nonatomic) NSCalendar * calendar;

@end

@implementation ITDateFormatter

@synthesize formatter = _formatter;
@synthesize calendar = _calendar;

- (NSDateFormatter * )formatter
{
    if (_formatter == nil)
    {
        _formatter = [NSDateFormatter new];
        [_formatter setDateFormat:@"HH:mm, dd.MM.yyyy"];
    }
    return _formatter;
}

- (NSCalendar *)calendar
{
    if (_calendar == nil)
    {
        _calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    }
    return _calendar;
}

// Настроить форматировщик для форматирования даты
- (void)configureDateFormaterForDate:(NSDate *)date
{
    NSDate * dateNow = [NSDate new];
    NSInteger dateDiff = [self daysBetween:date and:dateNow];
//    if ([date compare:dateNow] == NSOrderedDescending)
//    {
//        [self.formatter setDateFormat:@"HH:mm, dd.MM.yyyy"];
//    }
    if (abs(dateDiff) >= 1)
    {
        [self.formatter setDateFormat:@"dd.MM.yy"];
    }
    else if (dateDiff == 0)
    {
        [self.formatter setDateFormat:@"HH:mm"];
    }
//    else if (dateDiff == 1)
//    {
//        [self.formatter setDateStyle:NSDateFormatterShortStyle];
//    }
//    else
//    {
//        [self.formatter setDateFormat:@"HH:mm, EEE"];
//    }
//    if (dateDiff == 1)
//    {
//        [self.formatter setDoesRelativeDateFormatting:YES];
//    }
//    else
//    {
//        [self.formatter setDoesRelativeDateFormatting:NO];
//    }
}

// Разница в днях между датами
- (NSInteger)daysBetween: (NSDate *)date1 and:(NSDate*)date2
{
    double secPerDays = 24 * 60 * 60;
    //NSUInteger unitFlags = NSDayCalendarUnit;
    //NSCalendar * calendar = self.calendar;
    date1 = [self extractDateFrom:date1];
    date2 = [self extractDateFrom:date2];
    NSTimeInterval date1Seconds = [date1 timeIntervalSince1970];
    NSTimeInterval date2Seconds = [date2 timeIntervalSince1970];
    return (date2Seconds - date1Seconds) / secPerDays;
    
    //NSDateComponents * components = [calendar components:unitFlags fromDate:[self extractDateFrom: date1] toDate:[self extractDateFrom: date2] options:0];
    //return [components day];
}

// Получить дату без временти
- (NSDate*) extractDateFrom: (NSDate *) date
{
    NSDateComponents * components = [self.calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:date];
    return [self.calendar dateFromComponents:components];
}

// Единственный экземпляр объекта форматирования
+ (ITDateFormatter *)sharedInstance
{
    static ITDateFormatter * shared = nil;
    static dispatch_once_t onceTocken;
    dispatch_once(&onceTocken, ^{
        shared = [[self alloc]init];
    });
    return shared;
}

// Форматировать дату для списка
- (NSString *)format:(NSDate *)date
{
    if (!date || [date timeIntervalSince1970] < 0)
    {
        return @"";
    }
    [self configureDateFormaterForDate:date];
    return [[self.formatter stringFromDate:date] lowercaseString];
}

// Дата для новой задачи. Рассчитывается как дата сегодня + 1 день + округление к большему часу
- (NSDate *)tommorowDateForTask
{
    NSDate * tommorow = [[NSDate date] dateByAddingTimeInterval:60*60*24];
    NSDateComponents * comps = [[NSCalendar currentCalendar] components:NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit fromDate:tommorow];
    [comps setHour: comps.minute > 0 ? comps.hour + 1 : comps.hour];
    [comps setMinute:0];
    return [[NSCalendar currentCalendar] dateFromComponents:comps];
}

// Преобразовать дату в текст в формате HH:mm, dd.MM.yyyy
- (NSString *) formatDateWithTime: (NSDate *)date
{
    if (!date || [date timeIntervalSince1970] < 0)
    {
        return @"";
    }
    [self.formatter setDateFormat:@"HH:mm, dd.MM.yyyy"];
    return [self.formatter stringFromDate:date];
}

// Преобразовать дату в текст в формате dd.MM.yyyy
- (NSString *) formatDate: (NSDate *)date
{
    if (!date || [date timeIntervalSince1970] < 0)
    {
        return @"";
    }
    [self.formatter setDateFormat:@"dd.MM.yyyy"];
    return [self.formatter stringFromDate:date];
}

@end
