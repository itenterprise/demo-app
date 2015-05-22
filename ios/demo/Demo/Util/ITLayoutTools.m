//
//  ITFontTools.m
//  CaseManagement
//
//  Created by Администратор on 6/20/14.
//  Copyright (c) 2014 Information Technologies Ltd. All rights reserved.
//

#import "ITLayoutTools.h"
#import "ITDateFormatter.h"
#import "UIView+ViewExtension.h"

NSInteger const kEmployeeCellMargin = 98;
NSInteger const kConnectionCellMargin = 41;
NSInteger const kCellWithNoSelectionMargin = 40;
const NSInteger kVerticalMargin = 8;
const NSInteger kVerticalSpace = 5;

@implementation ITLayoutTools

/*
 * Рассчитать высоту ячейки сотрудника
 */
+ (float) calcHeightForEmployee: (ITEmployee *) employee
{
    float screenWidth = [UIView currentScreenSize].width;
    // Рассчитываем высоту как:
    // Отступ сверху
    // Высота метки с ФИО
    // Высота метки с названием подразделения
    // Высота метки с NKDK
    // Отступ снизу
    float height = kVerticalMargin;
    height += [ITLayoutTools calcHeightForText:employee.fio withMaxSize:CGSizeMake(screenWidth - kEmployeeCellMargin, 74) font:[UIFont systemFontOfSize:17]] + 5;
    if (employee.department.length)
    {
        height += [ITLayoutTools calcHeightForText:employee.department withMaxSize:CGSizeMake(screenWidth - kEmployeeCellMargin, 34) font:[UIFont systemFontOfSize:13]];
    }
    height += 5;
    height += kVerticalMargin;
    float imageHeight = 2 * kVerticalMargin + 40;
    if (height < imageHeight)
    {
        height = imageHeight;
    }
    return height;
}

/*
 * Рассчитать высоту ячейки подключения
 */
+ (float) calcHeightForConnection: (ITConnection *) connection withShowFullInfo: (BOOL) showFullInfo
{
    const NSInteger kConnectionLineHeight = 17;
    float screenWidth = [UIView currentScreenSize].width;
    float height = kVerticalMargin;
    if (connection.functionName.length)
    {
        height += [ITLayoutTools calcHeightForText:connection.functionName withMaxSize:CGSizeMake(screenWidth - kConnectionCellMargin, 50) font:[UIFont systemFontOfSize:17]];
    }
    if (showFullInfo)
    {
        height += kConnectionLineHeight;
    }
    height += kVerticalSpace + kConnectionLineHeight + kVerticalMargin;
    return height;
}

/*
 * Посчитать высоту текста с заданными ограничениями по размеру и заданным шрифтом
 */
+ (float) calcHeightForText:(NSString *)text withMaxSize:(CGSize) maxSize font: (UIFont *)font
{
    NSDictionary * stringAttributes = [NSDictionary dictionaryWithObject:font forKey:NSFontAttributeName];
    CGSize expectedLabelSize = [text boundingRectWithSize:maxSize options: (NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingTruncatesLastVisibleLine) attributes:stringAttributes context:nil].size;
    return expectedLabelSize.height;
}
@end
