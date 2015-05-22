//
//  ITDemoManager.h
//  Demo
//
//  Created by Admin on 10.02.15.
//  Copyright (c) 2015 Information Technologies Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ITApplicationManager.h"
#import "ITConnection.h"
#import "ITConnectionDetails.h"

@interface ITDemoManager : ITApplicationManager

@property(nonatomic, strong) UIStoryboard * storyboard;

/*
 * Экземпляр менеджера приложения
 */
+ (ITDemoManager*)sharedManager;

/*
 * Получить список сотрудников.
 * Вход: сохраненные идентификаторы сотрудников
 * Вызывается блок с массивом полученных сотрудников
 */
- (void) getEmployees: (NSArray *)ids withBlock:(void (^)(NSArray*)) block;

/*
 * Получить список подключений.
 * Вход: логин пользователя
 * Вызывается блок с массивом полученных подключений
 */
- (void) getConnections:(NSString *)login withBlock:(void (^)(NSArray *))block;

/*
 * Получить детальную информацию по подключению.
 * Вход: подключение
 * Детальная информация о подключении
 */
- (void) getDetailsForConnection: (ITConnection *)connection withBlock:(void (^)(ITConnectionDetails *)) block;

///*
// * Поиск пользователей по строке
// */
//- (void)searchUsers: (NSString *)search withBlock: (void(^)(NSArray*))block;

// Обновить информацию о пользователях
- (void) usersInfosForUsers:(NSArray *)ids withBlock: (void(^)(void))block;

- (void)updateAccountInfo;

- (UIImage *)defaultUserImage;
@end
