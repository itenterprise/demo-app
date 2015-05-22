//
//  ITConnection.h
//  Demo
//
//  Created by Admin on 11.02.15.
//  Copyright (c) 2015 Information Technologies Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import "ITConnectionDetails.h"

/*
 * Подключение к серверу БД
 */
@interface ITConnection : NSObject

/*
 * Идентификатор подключения к серверу БД
 */
@property (nonatomic, unsafe_unretained) NSInteger spid;

/*
 * Дата последней передачи данных
 */
@property (nonatomic, strong) NSDate * dateTransfer;

/*
 * Статус подключения
 */
@property (nonatomic, strong) NSString * status;

/*
 * Цвет статуса подключения
 */
@property (nonatomic, strong) NSString * statusColor;

/*
 * ФИО
 */
@property (nonatomic, strong) NSString * fio;

/*
 * Наименование функции
 */
@property (nonatomic, strong) NSString * functionName;

/*
 * Логин пользователя в системе IT
 */
@property (nonatomic, strong) NSString * userLogin;

/*
 * Детальное описание подключения
 */
//@property (nonatomic, strong) ITConnectionDetails * details;

+ (ITConnection *)initWithDictionary: (NSDictionary*) dict;
+ (NSArray*)initWithArray:(NSArray*)array;

@end
