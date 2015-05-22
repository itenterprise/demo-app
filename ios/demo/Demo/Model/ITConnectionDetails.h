//
//  ITConnectionDetails.h
//  Demo
//
//  Created by Admin on 11.02.15.
//  Copyright (c) 2015 Information Technologies Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ITConnection.h"

/*
 * Детальное описание подключения к серверу БД
 */
@interface ITConnectionDetails : ITConnection

/*
 * Наименование сервера БД
 */
@property (nonatomic, strong) NSString * server;

/*
 * Наименование БД
 */
@property (nonatomic, strong) NSString * dataBase;

/*
 * Логин SQL
 */
@property (nonatomic, strong) NSString * sqlLogin;

/*
 * Логин Windows
 */
@property (nonatomic, strong) NSString * winLogin;

/*
 * Логин ІТ
 */
@property (nonatomic, strong) NSString * itLogin;

/*
 * Наименование приложения
 */
@property (nonatomic, strong) NSString * application;

/*
 * Сетевое имя рабочей машины пользователя
 */
@property (nonatomic, strong) NSString * host;

+ (ITConnectionDetails *)initWithDictionary:(NSDictionary*) dict;

@end
