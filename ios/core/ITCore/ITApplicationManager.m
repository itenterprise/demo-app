//
//  ITTest.m
//  ITCoreSDK
//
//  Created by Администратор on 2/26/14.
//  Copyright (c) 2014 Information Technologies Ltd. All rights reserved.
//

#import "ITApplicationManager.h"
#import "KeychainItemWrapper.h"
#import "ITLoginResult.h"
#import "ITLoginViewController.h"
#import "DejalActivityView.h"
#import "ITInitRequest.h"
#import "ITInitResponse.h"
#import "ITURLUtils.h"
#import "CrashReport.h"
#import "ITEdsRepository.h"

@interface ITApplicationManager()

@property(nonatomic, strong) NSString * login;
@property(nonatomic, strong) NSString * password;
@property(nonatomic, strong) NSString * urlToNavigate;
@property(nonatomic, unsafe_unretained) BOOL inited;

@end

@implementation ITApplicationManager

NSString * _currentUserName;

- (NSString *) currentUserName
{
    return _currentUserName;
}

- (NSString *) applicationIdentifier
{
    return nil;
}

- (BOOL) isLoggedIn
{
    return self.serviceManager.ticket.length > 0;
}

- (BOOL)iPad
{
    return UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad;
}

- (void)loginWithName: (NSString *)name password:(NSString*) password remember: (BOOL)remember callback:(void(^)(BOOL success)) callback
{
    __weak ITApplicationManager * manager = self;
    [self.serviceManager loginWithLogin:name password:password callback:^(id result){
        ITLoginResult * loginResult = [[ITLoginResult alloc] initWithDictionary:result];
        BOOL success = loginResult.success;
        if (success)
        {
            _currentUserName = loginResult.userName;
            _userId = name;
            [self.serviceManager setTicket: loginResult.ticket];
            if (remember && [[manager applicationIdentifier] length])
            {
                KeychainItemWrapper * ki = [[KeychainItemWrapper alloc] initWithIdentifier:[manager applicationIdentifier] accessGroup:nil];
                [ki setObject:password forKey:(__bridge id)kSecValueData];
                [ki setObject:name forKey:(__bridge id)kSecAttrAccount];
                [self sendPushNotificationTocken];
            }
            [self loadUserSettings];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            callback(success);
        });
    }];
}

- (void)logout
{
    if ([self isUsingEds])
    {
        [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"EdsPrivateKeyName"];
        [[ITEdsRepository new] clearCredentials];
    }
    
    _currentUserName = nil;
    KeychainItemWrapper * ki = [[KeychainItemWrapper alloc] initWithIdentifier:[self applicationIdentifier] accessGroup:nil];
    [ki resetKeychainItem];
    if (self.pushNotificationTocken.length)
    {
        NSString * tocken = [[[NSString stringWithFormat:@"%@", self.pushNotificationTocken] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]] stringByReplacingOccurrencesOfString:@" " withString:@""];
        self.serviceManager.skipNextError = YES;
        [self.serviceManager executeMethod:@"UNREGUSER" args:@{@"APPID": [self applicationIdentifier], @"DEVICEID": tocken} callback:^(id ret) {
            [self.serviceManager logout];
        }];
    }
    else
    {
        [self.serviceManager logout];
    }
}

- (NSString *)serviceUrl
{
    NSUserDefaults * userDefauts = [NSUserDefaults standardUserDefaults];
    return [userDefauts objectForKey:@"serviceurl"];
}

- (ITServiceManager *)serviceManager
{
    ITServiceManager * manager = [ITServiceManager sharedManagerWithUrl:[self serviceUrl]];
    manager.serviceDelegate = self;
    manager.loginSource = self;
    return manager;
}

- (void)tryLoginFromKeychain:(void(^)(BOOL))callback
{
    if ([[self applicationIdentifier] length])
    {
        KeychainItemWrapper * ki = [[KeychainItemWrapper alloc] initWithIdentifier:[self applicationIdentifier] accessGroup:nil];
        NSString * user = [ki objectForKey:(__bridge id)kSecAttrAccount];
        NSString * password = [ki objectForKey:(__bridge id)kSecValueData];
        if (user.length && password)
        {
            [self loginWithName:user password:password remember:NO callback:^(BOOL success) {
                if (!success)
                {
                    if ([self isUsingEds])
                    {
                        [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"EdsPrivateKeyName"];
                        [[ITEdsRepository new] clearCredentials];
                    }
                    
                    KeychainItemWrapper * ki = [[KeychainItemWrapper alloc] initWithIdentifier:[self applicationIdentifier] accessGroup:nil];
                    [ki resetKeychainItem];
                }
                else
                {
                    [self sendPushNotificationTocken];
                }
                callback(success);
            }];
            return;
        }
    }
    callback(NO);
}

- (NSDictionary *)getUserAndPasswordFromKeychain
{
    NSString * user = nil;
    NSString * password = nil;
    if ([[self applicationIdentifier] length])
    {
        KeychainItemWrapper * ki = [[KeychainItemWrapper alloc] initWithIdentifier:[self applicationIdentifier] accessGroup:nil];
        user = [ki objectForKey:(__bridge id)kSecAttrAccount];
        password = [ki objectForKey:(__bridge id)kSecValueData];
    }
    return [[NSDictionary alloc] initWithObjectsAndKeys:
            user, @"user",
            password, @"password", nil];
}

- (void)sendPushNotificationTocken
{
    if (!self.pushNotificationTocken)
    {
        return;
    }
    NSString * tocken = [[[NSString stringWithFormat:@"%@", self.pushNotificationTocken] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]] stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSDictionary * deviceParams = [[NSDictionary alloc] initWithObjectsAndKeys:
                                   [self applicationIdentifier], @"APPID",
                                   tocken, @"DEVICEID",
                                   @"IOS", @"MOBILEOS", nil];
    [self.serviceManager executeMethod:@"REGDEVICE" args:deviceParams callback:^(id result){
    }];
}

- (void)loadUserSettings { }

- (void)sendCrashReport: (NSException*)exception
{
    NSDictionary * report = [[NSDictionary alloc] initWithObjectsAndKeys:
                             [CrashReport createReport:exception], @"REPORT", nil];
    ITServiceManager * manager = [ITServiceManager sharedManagerWithUrl:@"https://m.it.ua/ws/webservice.asmx"];
    manager.serviceDelegate = self;
    manager.loginSource = self;
    [manager executeMethod:@"_CRASHREPORT.ADD" args:report isAnonymous:YES callback:^(id result){}];
}

- (NSDictionary*)handlePushNotification: (NSString*)notificationBody
{
    if (!notificationBody.length)
    {
        return nil;
    }
    NSData * jsonData = [notificationBody dataUsingEncoding:NSUTF8StringEncoding];
    return [NSJSONSerialization JSONObjectWithData:jsonData options:kNilOptions error:nil];
}

- (NSDictionary *)loginInfo
{
    if (self.login.length && self.password.length)
    {
        return [[NSDictionary alloc] initWithObjectsAndKeys:self.login, @"user", self.password, @"password", nil];
    }
    return [self getUserAndPasswordFromKeychain];
}

- (void)handleSessionTimeout
{
    dispatch_async(dispatch_get_main_queue(), ^{
        UIViewController * viewController = [self topMostController];
        if ([viewController isKindOfClass:[ITLoginViewController class]])
        {
            return;
        }
        ITLoginViewController * loginController = [ITLoginViewController new];
        [DejalBezelActivityView removeView];
        [viewController presentViewController:loginController animated:YES completion:nil];
    });
}

- (UIViewController*) topMostController
{
    UIViewController * topController = [UIApplication sharedApplication].keyWindow.rootViewController;
    while (topController.presentedViewController)
    {
        topController = topController.presentedViewController;
    }
    return topController;
}

- (void)handleConnectionLost
{
    NSString * message = NSLocalizedStringFromTableInBundle(@"Для использования данного приложения Вы должны быть подключены к Интернету", @"LocalizableCore", [self resourcesBundle], nil);
    NSString * vpn = NSLocalizedStringFromTableInBundle(@"Для использования данного приложения Вы должны быть подключены к Интернету и VPN-сети", @"LocalizableCore", [self resourcesBundle], nil);
    UIAlertView *noConnectionAlert = [[UIAlertView alloc]
                                      initWithTitle:NSLocalizedStringFromTableInBundle(@"Отсутствует соединение",@"LocalizableCore", [self resourcesBundle], nil)
                                      message: [self requiresVPN] ? vpn : message
                                      delegate:self
                                      cancelButtonTitle:NSLocalizedStringFromTableInBundle(@"Выход", @"LocalizableCore", [self resourcesBundle], nil)
                                      otherButtonTitles:nil];
    [noConnectionAlert show];
}

- (void)handleNoLicense
{
    UIAlertView *noConnectionAlert = [[UIAlertView alloc]
                                      initWithTitle:NSLocalizedStringFromTableInBundle(@"Нет лицензии", @"LocalizableCore", [self resourcesBundle], nil)
                                      message:NSLocalizedStringFromTableInBundle(@"Нет доступных лицензий. Повторите попытку позже", @"LocalizableCore", [self resourcesBundle], nil)
                                      delegate:self
                                      cancelButtonTitle:NSLocalizedStringFromTableInBundle(@"Выход", @"LocalizableCore", [self resourcesBundle], nil)
                                      otherButtonTitles:nil];
    [noConnectionAlert show];
}

- (void)handleNoAccess
{
    UIAlertView *noConnectionAlert = [[UIAlertView alloc]
                                      initWithTitle:NSLocalizedStringFromTableInBundle(@"Нет доступа", @"LocalizableCore", [self resourcesBundle], nil)
                                      message:NSLocalizedStringFromTableInBundle(@"Нет доступа для выполнения расчета", @"LocalizableCore", [self resourcesBundle], nil)
                                      delegate:nil
                                      cancelButtonTitle:@"OK"
                                      otherButtonTitles:nil];
    [noConnectionAlert show];
}

- (void)handleError
{
    UIAlertView *noConnectionAlert = [[UIAlertView alloc]
                                      initWithTitle:NSLocalizedStringFromTableInBundle(@"Исключительная ситуация", @"LocalizableCore", [self resourcesBundle], nil)
                                      message:NSLocalizedStringFromTableInBundle(@"Произошла исключительная ситуация при выполнении расчета", @"LocalizableCore", [self resourcesBundle], nil)
                                      delegate:self
                                      cancelButtonTitle:NSLocalizedStringFromTableInBundle(@"Выход", @"LocalizableCore", [self resourcesBundle], nil)
                                      otherButtonTitles:nil];
    [noConnectionAlert show];
}

- (BOOL)checkServiceUrl
{
    NSString * url = ITApplicationManager.sharedManager.serviceUrl;
    if (!url.length || [url rangeOfString:@"webservice.asmx"].location == NSNotFound)
    {
        UIAlertView *noConnectionAlert = [[UIAlertView alloc]
                                          initWithTitle:NSLocalizedStringFromTableInBundle(@"Недопустимый URL", @"LocalizableCore", [self resourcesBundle], nil)
                                          message:NSLocalizedStringFromTableInBundle(@"Для использования данного приложения Вы должны указать корректный URL веб-сервиса IT-Enterprise", @"LocalizableCore", [self resourcesBundle], nil)
                                          delegate:self
                                          cancelButtonTitle:NSLocalizedStringFromTableInBundle(@"Выход", @"LocalizableCore", [self resourcesBundle], nil)
                                          otherButtonTitles:nil];
        [noConnectionAlert show];
        return NO;
    }
    return YES;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 250)
    {
        if (self.urlToNavigate.length)
        {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.urlToNavigate]];
        }
        self.urlToNavigate = nil;
    }
    exit(0);
}

- (BOOL)requiresVPN
{
    return NO;
}

// Получить полный путь к файлу во временном каталоге
- (NSURL *) tempFilePath:(NSString *)name
{
    return [NSURL fileURLWithPath:[NSTemporaryDirectory() stringByAppendingPathComponent:name]];
}

- (NSURL *) documentsFilePath: (NSString *)name
{
    NSArray * documentDirectory = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    if (documentDirectory.count)
    {
        return [NSURL fileURLWithPath:[documentDirectory[0] stringByAppendingPathComponent:name]];
    }
    return nil;
}

// Проверить версию клиента и сервера
- (void) initApplicationWithBlock: (void(^)(BOOL success))block
{
    if (self.inited)
    {
        block(YES);
        return;
    }
    ITInitRequest * request = [ITInitRequest new];
    //NSString * itVersionArgs = [[NSString alloc] initWithData:[NSJSONSerialization dataWithJSONObject:[request dictionaryRepresentation] options: 0 error: nil] encoding:NSUTF8StringEncoding];
    // Параметры для вызова asmx-метода
    //    NSDictionary * args = [[NSDictionary alloc] initWithObjectsAndKeys:@"INIT", @"calcId", itVersionArgs, @"args", @"", @"ticket", nil];
    [self.serviceManager executeMethod:@"INIT" args:[request dictionaryRepresentation] callback:^(id ret) {
        ITInitResponse * response = [[ITInitResponse alloc] initWithDictionary:ret];
        dispatch_async(dispatch_get_main_queue(), ^{
            BOOL success = [self handleInitResult:response];
            block(success);
        });
    }];
}

- (BOOL) initApplication
{
    ITInitRequest * request = [ITInitRequest new];
    ITInitResponse * response = [self.serviceManager startApplicationWithRequest:request];
    return [self handleInitResult:response];
}

- (BOOL)handleInitResult: (ITInitResponse *)response
{
    BOOL success = NO;
    NSString * errorMessage;
    switch (response.responseStatus) {
        case kInitResponseStatusSuccess:
            // Все ok
            success = YES;
            break;
        case kInitResponseStatusModuleError:
            // Модуль отсутствует
            errorMessage = [NSString stringWithFormat: NSLocalizedStringFromTableInBundle(@"Отсутствует модуль \"%@\"", @"LocalizableCore", [self resourcesBundle], nil), [self applicationModule]];
            break;
        case kInitResponseStatusProjectError:
            // Неподходящий объект
            errorMessage = [NSString stringWithFormat:NSLocalizedStringFromTableInBundle(@"Приложение можно запускать только на объекте \"%@\"", @"LocalizableCore", [self resourcesBundle], nil), [self applicationProject]];
            break;
        case kInitResponseStatusNewVersion:
        {
            // Есть новая версия
            NSString * launchUrl = response.additionalProperties[@"URL"];
            UIApplication * app = [UIApplication sharedApplication];
            if (![app canOpenURL:[NSURL URLWithString:launchUrl]])
            {
                errorMessage = NSLocalizedStringFromTableInBundle(@"Установите новую версию приложения из AppStore. После установки запустите это приложение еще раз для настройки новой версии", @"LocalizableCore", [self resourcesBundle], nil);
                self.urlToNavigate = response.additionalProperties[@"IOSSTORE"];
            }
            else
            {
                self.urlToNavigate = launchUrl;
                errorMessage = NSLocalizedStringFromTableInBundle(@"Используйте новую версию приложения", @"LocalizableCore", [self resourcesBundle], nil);
            }
            break;
        }
        default:
            break;
    }
    self.inited = YES;
    if (!success && errorMessage.length)
    {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"" message:errorMessage delegate:self cancelButtonTitle:NSLocalizedStringFromTableInBundle(@"Выход", @"LocalizableCore", [self resourcesBundle], nil) otherButtonTitles: nil];
        alert.tag = 250;
        [alert show];
    }
    return success;
}

- (NSString *) applicationModule
{
    return @"";
}

- (NSString *) applicationProject
{
    return @"";
}

static ITApplicationManager * shared = nil;

+ (void)setSharedManager:(ITApplicationManager *)manager
{
    shared = manager;
}

+ (ITApplicationManager *)sharedManager
{
    return shared;
}

- (NSString *) itURLFromQRCode: (NSString *)qrCode
{
    NSDictionary * getParams = [[ITURLUtils sharedInstance]URLQueryParameters:[NSURL URLWithString:qrCode]];
    NSString * itUrl = qrCode;
    if (getParams && getParams[@"ITURL"])
    {
        itUrl = getParams[@"ITURL"];
    }
    if ([self hasServiceSuffix:itUrl])
    {
        return itUrl;
    }
    return @"";
}

- (BOOL) hasServiceSuffix: (NSString *)url
{
    return [url rangeOfString:@"webservice.asmx"].location != NSNotFound;
}

- (BOOL) isIOS7
{
    return NSFoundationVersionNumber <= NSFoundationVersionNumber_iOS_7_1;
}

- (BOOL) isUsingEds
{
    return NO;
}

- (NSBundle *)resourcesBundle
{
    if (_resourcesBundle == nil)
    {
        _resourcesBundle = [NSBundle bundleWithIdentifier:@"com.it.ITCoreResources"];
        if (_resourcesBundle == nil)
        {
            _resourcesBundle = [NSBundle bundleWithURL:[[NSBundle mainBundle] URLForResource:@"ITCoreResources" withExtension:@"bundle"]];
        }
    }
    return _resourcesBundle;
}

- (void) changePassword:(NSString *)oldPassword toPassword:(NSString *)newPassword withBlock: (void(^)(id ret)) block
{
    [[self serviceManager] changePassword: oldPassword toPassword: newPassword forUser:self.userId withBlock: ^(id ret){
        if (ret && [ret[@"SUCCESS"] intValue])
        {
            NSDictionary * keyChain = [self getUserAndPasswordFromKeychain];
            if (keyChain[@"user"] && keyChain[@"password"])
            {
                KeychainItemWrapper * ki = [[KeychainItemWrapper alloc] initWithIdentifier:[self applicationIdentifier] accessGroup:nil];
                [ki setObject:newPassword forKey:(__bridge id)kSecValueData];
            }
        }
        block(ret);
    }];
}

@end