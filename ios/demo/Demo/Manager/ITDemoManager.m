//
//  ITDemoManager.m
//  Demo
//
//  Created by Admin on 10.02.15.
//  Copyright (c) 2015 Information Technologies Ltd. All rights reserved.
//

#import "ITDemoManager.h"
#import "ITEmployee.h"
#import "UserInfo.h"
#import "AppDelegate.h"
#import "ITPhotoManager.h"

@interface ITDemoManager()

@property (strong, nonatomic) UserInfo * userInfo;

@end

@implementation ITDemoManager

+ (ITDemoManager*)sharedManager
{
    static ITDemoManager * manager = nil;
    static dispatch_once_t tocken;
    dispatch_once(&tocken, ^{
        manager = [ITDemoManager new];
        [super setSharedManager:manager];
    });
    return manager;
}

- (NSString *)applicationIdentifier
{
    return @"Demo";
}

- (UIStoryboard *)storyboard
{
    if (_storyboard == nil)
    {
        _storyboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
    }
    return _storyboard;
}

- (void) getEmployees:(NSString *)ids withBlock:(void (^)(NSArray *))block
{
    __weak ITDemoManager * theSelf = self;
    [self getConnections:@"" withBlock:^(NSArray * connections) {
        [[theSelf serviceManager] executeMethod:@"_DEMO.GETEMPLOYEES" args:
         [NSDictionary dictionaryWithObjectsAndKeys: ids, @"USERS", nil]
                                    callback:^(id result) {
                                        if ([result isKindOfClass:[NSArray class]])
                                        {
                                            NSArray * employees = [ITEmployee initWithArray:result];
                                            
                                            for (ITEmployee *employee in employees)
                                            {
                                                if (employee.login == nil || [employee.login isEqualToString:@""])
                                                {
                                                    continue;
                                                }
                                                for (ITConnection *connection in connections)
                                                {
                                                    if (connection.userLogin != nil && [[employee.login uppercaseString] isEqualToString:[connection.userLogin uppercaseString]])
                                                    {
                                                        employee.isOnline = YES;
                                                        break;
                                                    }
                                                }
                                            }
                                            dispatch_async(dispatch_get_main_queue(), ^{
                                                block(employees);
                                            });
                                        }
                                    }];
    }];
}

- (void) getConnections:(NSString *)login withBlock:(void (^)(NSArray *))block
{
    [[self serviceManager] executeMethod:@"BASEMON.GETCONNECTIONS" args:
     [NSDictionary dictionaryWithObjectsAndKeys: login, @"USERLOGIN", nil]
                                callback:^(id result) {
                                    if ([result isKindOfClass:[NSArray class]])
                                    {
                                        NSArray * connections = [ITConnection initWithArray:result];
                                        dispatch_async(dispatch_get_main_queue(), ^{
                                            block(connections);
                                        });
                                    }
                                }];
}

- (void) getDetailsForConnection: (ITConnection *)connection withBlock:(void (^)(ITConnectionDetails *)) block
{
    [[self serviceManager] executeMethod:@"BASEMON.GETCONNECTIONINFO" args:@{@"SPID": [NSNumber numberWithInteger:[connection spid]]} callback:^(id result)
     {
         if ([result isKindOfClass:[NSDictionary class]])
         {
             ITConnectionDetails *details = [ITConnectionDetails initWithDictionary:result];
             dispatch_async(dispatch_get_main_queue(), ^{
                 block(details);
             });
         }
     }];
}

- (void) usersInfosForUsers:(NSArray *)ids withBlock: (void(^)(void))block
{
    // Отбор всех сех пользователей по userId
    NSPredicate * predicate = [NSPredicate predicateWithFormat:@"(self.userId IN %@)", ids];
    NSFetchRequest * fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"UserInfo"];
    [fetchRequest setPredicate:predicate];
    NSManagedObjectContext * context = [self managedContext];
    NSArray * users = [context executeFetchRequest:fetchRequest error:nil];
    // Создать аргументы для вызова веб-расчета
    NSMutableArray * requestObj = [NSMutableArray new];
    // Копия идентификаторов для удаления идентификаторов, по которым уже есть данные пользователя
    NSMutableArray * mutableIds = [ids mutableCopy];
    // Добавить идентификаторы пользователей с хешем
    for (UserInfo * user in users)
    {
        //TODO real hash
        //NSDictionary * dict = @{ @"USERID" : user.userId, @"HASH" : user.checksum };
        NSDictionary * dict = @{ @"USERID" : user.userId, @"HASH" : @"" };
        [requestObj addObject:dict];
        [self removeString: user.userId fromArray: mutableIds];
    }
    // Добавить идентификаторы пользователей, данных о которых еще нет
    for (NSString * userId in mutableIds)
    {
        [requestObj addObject:@{ @"USERID" : userId, @"HASH": @"" }];
    }
    // Получить информацию о пользователях
    [self.serviceManager executeMethod:@"DESKTOP.GETUSERS" args:@{ @"USERS": requestObj } callback:^(id ret) {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSArray * result = (NSArray *)ret;
            // Получить описание сущности пользователя
            NSEntityDescription * entity = [NSEntityDescription entityForName:@"UserInfo" inManagedObjectContext:context];
            // Пройтись по всем словарям возврата и обновить или добавить новых пользователей
            NSMutableArray * photos = [NSMutableArray new];
            NSMutableArray * fetchedUsers = [NSMutableArray new];
            for (NSDictionary * userDict in result)
            {
                NSString * userId = userDict[@"USERID"];
                NSString * email = userDict[@"EMAIL"];
                NSString * phone = userDict[@"PHONE"];
                NSString * photo = userDict[@"PHOTO"];
                NSString * hash = userDict[@"HASH"];
                // Предикат для поиска существующего пользователя
                NSPredicate * predicate = [NSPredicate predicateWithFormat:@"%K == %@", @"userId", userId];
                [fetchRequest setPredicate:predicate];
                NSArray * users = [context executeFetchRequest:fetchRequest error:nil];
                UserInfo * user;
                // Пользователь существует
                if (users && users.count)
                {
                    user = users[0];
                }
                // Пользователь не существует
                else
                {
                    user = [[UserInfo alloc] initWithEntity:entity insertIntoManagedObjectContext:context];
                }
                user.userId = userId;
                user.email = email;
                user.checksum = hash;
                user.phone = phone;
                if (!photo.length)
                {
                    photo = @"";
                }
                [photos addObject:photo];
                [fetchedUsers addObject: user];
            }
            if (fetchedUsers.count)
            {
                //                NSError * error = nil;
                //                [context save:&error];
                ITPhotoManager * photoManager = [ITPhotoManager new];
                [photoManager loadPhotos:photos forUsers:fetchedUsers inContext:context];
            }
            //            // Если указано фото, то загрузить
            //            if (photo.length)
            //            {
            //                [self.serviceManager getFile:photo withBlock:^(NSString * tempName) {
            //                    user.imageContents = [NSData dataWithContentsOfFile:tempName];
            //                    [context save:nil];
            //                }];
            //            }
            block();
            
        });
    }];
}

// Показать информацию о текущем пользователе
- (void)updateAccountInfo
{
    // Пользователь не совершил вход
    if (![self userId])
    {
        return;
    }
    // Если уже есть информация о текущем пользователе - использовать ее
    if (self.userInfo)
    {
        AppDelegate * appDelegate = ((AppDelegate *)[UIApplication sharedApplication].delegate);
        if (self.userInfo.imageContents)
        {
            appDelegate.menuController.fotoView.image = self.userInfo.imageContents;
        }
        else
        {
            appDelegate.menuController.fotoView.image = [self defaultUserImage];
        }
        appDelegate.menuController.nameLabel.text = [self currentUserName];
    }
    NSArray * users = @[[[self userId] uppercaseString]];
    // Получить пользователя с сервера
    [self usersInfosForUsers:users withBlock:^{
        NSPredicate * predicate = [NSPredicate predicateWithFormat:@"(self.userId ==[c] %@)", [self userId]];
        NSFetchRequest * fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"UserInfo"];
        [fetchRequest setPredicate:predicate];
        AppDelegate * appDelegate = ((AppDelegate *)[UIApplication sharedApplication].delegate);
        NSArray * users = [appDelegate.managedObjectContext executeFetchRequest:fetchRequest error:nil];
        if (appDelegate.menuController && users.count)
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                UserInfo * user = users[0];
                if (user.imageContents)
                {
                    appDelegate.menuController.fotoView.image = user.imageContents;
                }
                else
                {
                    appDelegate.menuController.fotoView.image = [self defaultUserImage];
                }
                appDelegate.menuController.nameLabel.text = [self currentUserName];
            });
        }
    }];
}

- (NSManagedObjectContext *)managedContext
{
    return ((AppDelegate *)[UIApplication sharedApplication].delegate).managedObjectContext;
}

// Удалить строку из массива, если она там есть
- (void) removeString: (NSString *)string fromArray: (NSMutableArray *)array
{
    for (NSString * str in array)
    {
        if ([str isEqualToString:string])
        {
            [array removeObject:str];
            return;
        }
    }
}

- (UIImage *)defaultUserImage
{
    static UIImage * defaultImage;
    static dispatch_once_t imgTocken;
    dispatch_once(&imgTocken, ^{
        defaultImage = [UIImage imageNamed:@"user_icon"];
    });
    return defaultImage;
}

@end
