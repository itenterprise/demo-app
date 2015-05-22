//
//  ITEmployee.h
//  Demo
//
//  Created by Admin on 10.02.15.
//  Copyright (c) 2015 Information Technologies Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

/*
 * Сотрудник
 */
@interface ITEmployee : NSObject

/*
 * Логин пользователя в системе IT
 */
@property (nonatomic, strong) NSString * login;

/*
 * Идентификатор N_KDK
 */
@property (nonatomic, strong) NSString * nkdk;

/*
 * Телефон
 */
@property (nonatomic, strong) NSString * phone;

/*
 * Почта
 */
@property (nonatomic, strong) NSString * email;

/*
 * ФИО пользователя
 */
@property (nonatomic, strong) NSString * fio;

/*
 * Подразделение
 */
@property (nonatomic, strong) NSString * department;

/*
 * Фото (имя в Temp каталоге)
 */
@property (nonatomic, strong) NSString * photoName;

/*
 * Хеш
 */
@property (nonatomic, strong) NSString * checksum;

/**
 * Признак online
 */
@property (nonatomic, unsafe_unretained) BOOL isOnline;

/**
 * Признак online
 */
@property (nonatomic, strong) id photo;

+ (ITEmployee *)initWithDictionary: (NSDictionary*) dict;
+ (NSArray*)initWithArray:(NSArray*)array;

@end
