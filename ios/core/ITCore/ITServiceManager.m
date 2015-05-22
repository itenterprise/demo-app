//
//  ITService.m
//  Desktop
//
//  Created by Администратор on 2/7/14.
//  Copyright (c) 2014 Information Technologies Ltd. All rights reserved.
//

#import "ITServiceManager.h"
#import "ITApplicationManager.h"
#import "Reachability.h"

@interface ITServiceManager()

@property(nonatomic, strong) NSString * url;

@end

@implementation ITServiceManager

+ (ITServiceManager*)sharedManagerWithUrl:(NSString *)url
{
    static ITServiceManager * manager = nil;
    static dispatch_once_t tocken;
    dispatch_once(&tocken, ^{
        manager = [ITServiceManager new];
    });
    manager.url = url;
    return manager;
}

- (void)logout
{
    [self setTicket: nil];
}

- (NSString *)ticket
{
    if (_ticket == nil)
    {
        return @"";
    }
    return _ticket;
}

- (void) loginWithLogin: (NSString*)login password: (NSString*) password callback:(ServiceCallback)callback
{
    [self exec:@"LoginEx" withArgs:[[NSDictionary alloc] initWithObjectsAndKeys:
                                    login, @"login",
                                    password, @"password",
                                    nil] callback:^(id data){
        callback(data);
    }];
}

- (NSString *)url
{
    if (!_url)
    {
        return @"";
    }
    NSString * separator = @"/";
    NSString * suffix = @"ws/webservice.asmx";
    NSString * lowerUrl = [_url lowercaseString];
    if (![lowerUrl hasPrefix:@"http"])
    {
        lowerUrl = [@"http://" stringByAppendingString:lowerUrl];
    }
    if (![lowerUrl hasSuffix:suffix])
    {
        if (![lowerUrl hasSuffix:separator])
        {
            lowerUrl = [lowerUrl stringByAppendingString:separator];
        }
        lowerUrl = [lowerUrl stringByAppendingString:suffix];
    }
    return lowerUrl;
}

// Получить версию сервера
- (ITInitResponse *) startApplicationWithRequest:(ITInitRequest *)initRequest
{
    NSArray * params = [self.url componentsSeparatedByString:@"?"];
    NSString * serviceUrl = params[0];
    NSString * getParams = @"";
    if (params.count > 1)
    {
        getParams = params[1];
    }
    // Сформировать URL
    NSMutableString * url = [NSMutableString stringWithFormat:@"%@/%@?pureJSON=%@", serviceUrl, @"ExecuteEx",
                             [getParams isEqualToString:@""] ? @"" : [NSString stringWithFormat:@"&%@", getParams]];
    NSURL *postURL = [NSURL URLWithString: url];
    
    NSString * itVersionArgs = [[NSString alloc] initWithData:[NSJSONSerialization dataWithJSONObject:[initRequest dictionaryRepresentation] options: 0 error: nil] encoding:NSUTF8StringEncoding];
    // Параметры для вызова asmx-метода
    NSDictionary * args = [[NSDictionary alloc] initWithObjectsAndKeys:@"INIT", @"calcId", itVersionArgs, @"args", @"", @"ticket", nil];
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:args options:0 error:nil];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL: postURL
                                                           cachePolicy: NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval: 60.0];
    
    [request setHTTPMethod: @"POST"];
    [request setValue: @"application/json" forHTTPHeaderField: @"Accept"];
    [request setValue: @"application/json; charset=utf-8" forHTTPHeaderField: @"Content-Type"];
    [request setValue:[NSString stringWithFormat:@"%luld", (unsigned long)[jsonData length]] forHTTPHeaderField:@"Content-Length"];
    [request setHTTPBody: jsonData];
    NSData * response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    if (response)
    {
        return [[ITInitResponse alloc] initWithDictionary:[NSJSONSerialization JSONObjectWithData:response options:kNilOptions error:nil]];
    }
    return [ITInitResponse new];
}


- (NSDictionary *) executeMethodSync: (NSString*) method args: (id) args
{
    NSArray * params = [self.url componentsSeparatedByString:@"?"];
    NSString * serviceUrl = params[0];
    NSString * getParams = @"";
    if (params.count > 1)
    {
        getParams = params[1];
    }
    // Сформировать URL
    NSMutableString * url = [NSMutableString stringWithFormat:@"%@/%@?pureJSON=%@", serviceUrl, @"ExecuteEx",
                             [getParams isEqualToString:@""] ? @"" : [NSString stringWithFormat:@"&%@", getParams]];
    NSURL *postURL = [NSURL URLWithString: url];

    if (args == nil)
    {
        args = @"{}";
    }
    
    // Параметры для вызова asmx-метода
    NSDictionary * webArgs = [[NSDictionary alloc] initWithObjectsAndKeys:method, @"calcId", args, @"args", @"", @"ticket", nil];
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:webArgs options:0 error:nil];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL: postURL
                                                           cachePolicy: NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval: 60.0];
    
    [request setHTTPMethod: @"POST"];
    [request setValue: @"application/json" forHTTPHeaderField: @"Accept"];
    [request setValue: @"application/json; charset=utf-8" forHTTPHeaderField: @"Content-Type"];
    [request setValue:[NSString stringWithFormat:@"%luld", (unsigned long)[jsonData length]] forHTTPHeaderField:@"Content-Length"];
    [request setHTTPBody: jsonData];
    NSData * response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    return [NSJSONSerialization JSONObjectWithData:response options:kNilOptions error:nil];

}

- (void) executeMethod: (NSString*) method args:(NSDictionary *)args isAnonymous:(BOOL)isAnonymous callback:(ServiceCallback)callback
{
    NSString * jsonArgs;
    if (args != nil)
    {
        jsonArgs = [[NSString alloc] initWithData:[NSJSONSerialization dataWithJSONObject:args options: 0 error: nil] encoding:NSUTF8StringEncoding];
    }
    else
    {
        jsonArgs = @"{}";
    }
    NSString * ticket = isAnonymous ? @"" : self.ticket;
    NSDictionary * theArgs = [[NSDictionary alloc] initWithObjectsAndKeys:
        method, @"calcId",
        jsonArgs, @"args",
        ticket, @"ticket",
        nil];
    
    [self exec:@"ExecuteEx" withArgs:theArgs callback:callback];
}

- (void) executeMethod: (NSString*) method args:(NSDictionary *)args callback:(ServiceCallback)callback
{
    [self executeMethod:method args:args isAnonymous:NO callback:callback];
}

- (void) changePassword:(NSString *)oldPassword toPassword:(NSString *)newPassword forUser:(NSString *)user withBlock: (void(^)(id ret)) block
{
    NSDictionary * args = @{ @"login" : user,
                             @"oldPassword": oldPassword,
                             @"newPassword": newPassword,
                             @"ticket": self.ticket };
    [self exec:@"ChangePassword" withArgs:args callback:^(id ret) {
        dispatch_async(dispatch_get_main_queue(), ^{
            block(ret);
        });
    }];
}



-(void)exec: (NSString *)method withArgs: (NSDictionary *)args callback: (ServiceCallback)callback
{
    if (![self hasInternetConnection])
    {
        if (self.serviceDelegate != nil)
        {
            [self.serviceDelegate handleConnectionLost];
        }
        callback(nil);
    }
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    NSArray * params = [self.url componentsSeparatedByString:@"?"];
    NSString * serviceUrl = params[0];
    NSString * getParams = @"";
    if (params.count > 1)
    {
        getParams = params[1];
    }
    NSMutableString * url = [NSMutableString stringWithFormat:@"%@/%@?pureJSON=%@", serviceUrl, method,
                             [getParams isEqualToString:@""] ? @"" : [NSString stringWithFormat:@"&%@", getParams]];
    NSURL *postURL = [NSURL URLWithString: url];
    
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:args options:0 error:&error];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL: postURL
                                                           cachePolicy: NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval: 60.0];
    
    [request setHTTPMethod: @"POST"];
    [request setValue: @"application/json" forHTTPHeaderField: @"Accept"];
    [request setValue: @"application/json; charset=utf-8" forHTTPHeaderField: @"Content-Type"];
    if ([@"LoginEx" isEqualToString:method])
    {
        //NSLog(@"LOCALE = %@", [NSLocale preferredLanguages][0]);
        [request setValue:[NSLocale preferredLanguages][0] forHTTPHeaderField:@"Accept-Language"];
    }
    [request setValue:[NSString stringWithFormat:@"%luld", (unsigned long)[jsonData length]] forHTTPHeaderField:@"Content-Length"];
    [request setHTTPBody: jsonData];
    
    if ([@"_CRASHREPORT.ADD" isEqualToString:[args valueForKey:@"calcId"]]) {
        // Отправка синхронного запроса
        NSURLResponse * response = nil;
        NSData * data = [NSURLConnection sendSynchronousRequest:request
                                              returningResponse:&response
                                                          error:&error];
        [self handleCompletedWithMethod:method args:args callback:callback responce:response data:data error:error];
        return;
    }
    
    // Отправка асинхронного запроса
    [NSURLConnection sendAsynchronousRequest: request
                                       queue: queue
                           completionHandler: ^(NSURLResponse *response, NSData *data, NSError *error) {
        @autoreleasepool {
            [self handleCompletedWithMethod:method args:args callback:callback responce:response data:data error:error];
        }
        }];
}

// Обработка получения ответа от веб-сервиса
- (void) handleCompletedWithMethod:(NSString *)method args: (NSDictionary *)args callback: (ServiceCallback)callback
                          responce:(NSURLResponse *)response data:(NSData *)data error:(NSError *)error
{
    self.skipNextError = NO;
    NSHTTPURLResponse * httpResponce = (NSHTTPURLResponse*)response;
    // Если статус 404 или 403 - или неверная ссылка или нет доступа к интернет
    if (httpResponce.statusCode == 404 || httpResponce.statusCode == 403){
        dispatch_async(dispatch_get_main_queue(), ^{
            [[ITApplicationManager sharedManager] handleConnectionLost];
        });
        callback(nil);
    }
    // Произошла ошибка, которую невозможно обработать
    if (error || !data) {
        callback(nil);
        return;
    }
    //NSLog(@"%@",[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding]);
    // Тикет умер. необходимо получить новый, если есть учетные данные или перебросить на форму входа
    if ([@"WRONG_TICKET" isEqualToString:[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding]])
    {
        // Попытаться войти используя данные из keychain
        [self tryLoginWithKeychain:YES block:^(BOOL success){
            // Успешно вошли - вызвать расчет заново
            if (success)
            {
                NSDictionary * params = [[NSDictionary alloc] initWithObjectsAndKeys:
                                         args[@"calcId"], @"calcId",
                                         args[@"args"], @"args",
                                         self.ticket, @"ticket", nil];
                [self exec:method withArgs:params callback:callback];
            }
            // Перебросить на форму входа
            else
            {
                if (self.serviceDelegate != nil)
                {
                    [self.serviceDelegate handleSessionTimeout];
                }
            }
        }];
        return;
    }
    // Преобразовать JSON в словарь или строку
    id jsonResponse = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    if (!jsonResponse)
    {
        jsonResponse = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    }
    NSDictionary * jsonDictionary;
    if ([jsonResponse isKindOfClass:[NSDictionary class]])
    {
        jsonDictionary = jsonResponse;
    }
    // Если есть ключи StackTrace и Message - ошибка веб-расчета. Попытаться обработать
    if (!self.skipNextError && jsonDictionary && [jsonDictionary objectForKey:@"StackTrace"] && [jsonDictionary objectForKey:@"Message"])
    {
        NSString * message = [jsonDictionary objectForKey:@"Message"];
        [self handleExceptionWidthMessage:message callback:callback];
        return;
    }
    // Вызвать обработчик результата
    if (callback != nil)
    {
        callback(jsonResponse);
    }
}

// Обработать исключительную ситуацию
- (void) handleExceptionWidthMessage: (NSString *)message callback:(ServiceCallback)callback
{
    // Для обратной совместимости со старыми версиями сервера.
    // Если расчет не существует вызвать обработчик результата с nil
    if ([@"Calculation not exists" isEqualToString:message])
    {
        if (callback)
        {
            callback(nil);
        }
    }
    // Нет лицензий
    else if ([@"No license" isEqualToString:message])
    {
        dispatch_async(dispatch_get_main_queue(), ^{
           [[ITApplicationManager sharedManager] handleNoLicense];
        });
    }
    // Нет доступа к выполнению расчета
    else if ([message rangeOfString:@"doesn't have access to calculation"].location != NSNotFound)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            [[ITApplicationManager sharedManager] handleNoAccess];
        });
    }
    // Невозможно выполнить имперсонализацию
    else if ([message hasPrefix:@"Can't impersonate by token"])
    {
        if (self.serviceDelegate != nil)
        {
            [self.serviceDelegate handleSessionTimeout];
        }
    }
    else
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            [[ITApplicationManager sharedManager] handleError];
        });
    }
}

// Попытать войти используя учетные данные из keychain
- (void) tryLoginWithKeychain: (BOOL)useKeychain block: (void(^)(BOOL))block
{
    if (useKeychain && self.loginSource != nil)
    {
        NSDictionary * loginInfo = [self.loginSource loginInfo];
        NSString * user = loginInfo[@"user"];
        NSString * password = loginInfo[@"password"];
        if (user.length && password.length)
        {
            [self.loginSource loginWithName:user password:password remember:false callback:^(BOOL success){
                block(success);
            }];
            return;
        }
    }
    block(NO);
}

- (BOOL)hasInternetConnection
{
    Reachability *theNetworkReachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus theNetworkStatus = [theNetworkReachability currentReachabilityStatus];
    return theNetworkStatus != NotReachable;
}

/* ------------------------------------------------------------------------------------------------------------------
 * Передать картинку на веб-сервер. После передачи вызывается блок, которому передается имя файла во временном каталоге веб-сервера
 * ------------------------------------------------------------------------------------------------------------------*/
- (void) sendImage: (UIImage *)image withBlock: (void(^)(NSString*))block
{
    NSData * imageData = UIImageJPEGRepresentation(image, 90);
    
    NSString * url = [[self baseUrl] stringByAppendingString: @"AddFile.ashx"];
    
    NSMutableURLRequest * request = [NSMutableURLRequest new];
    [request setURL:[NSURL URLWithString:url]];
    [request setHTTPMethod:@"POST"];
    
    NSString * boundary = @"---------------------------14737809831466499882746641449";
    NSString * contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary];
    [request addValue:contentType forHTTPHeaderField:@"Content-Type"];
    
    NSMutableData * body = [NSMutableData data];
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"Content-Disposition: form-data; name=\"userfile\"; filename=\"img.1.png\"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"Content-Type: application/octet-stream\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[NSData dataWithData:imageData]];
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [request setHTTPBody:body];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue new] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        NSString * returnString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        block(returnString);
    }];
}

/* ------------------------------------------------------------------------------------------------------------------
 * Получить ссылку на корневой каталог веб-сервиса
 * ------------------------------------------------------------------------------------------------------------------*/
- (NSString *)baseUrl
{
    return [self.url substringToIndex:[self.url rangeOfString:@"webservice.asmx"].location];
}

/* ------------------------------------------------------------------------------------------------------------------
 * Получить файл, загрузить во временной каталог телефона. После загрузки вызывается блок, которому передается локальная ссылка на файл
 * ------------------------------------------------------------------------------------------------------------------*/
- (void) getTempFile: (NSString *) name withBlock: (void(^)(NSString *))block
{
    [self getFile:name temp:YES withBlock:block];
}

- (void) getFile: (NSString *) name withBlock: (void(^)(NSString *))block
{
    [self getFile:name temp:NO withBlock:block];
}

- (void) getFile: (NSString *)name temp:(BOOL)temp withBlock: (void(^)(NSString *))block
{
    NSString * getFileUrl = [[self baseUrl] stringByAppendingString:@"GetFile.ashx?file="];
    getFileUrl = [getFileUrl stringByAppendingString:name];
    
    NSURL * url = [NSURL URLWithString:getFileUrl];
    NSOperationQueue * queue = [[NSOperationQueue alloc] init];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL: url
                                                           cachePolicy: NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval: 60.0];
    [NSURLConnection sendAsynchronousRequest: request
                                       queue: queue
                           completionHandler: ^(NSURLResponse *response, NSData *data, NSError *error) {
                               dispatch_async(dispatch_get_main_queue(), ^{
                                   if (data)
                                   {
                                       NSURL * tempPath = temp
                                            ? [[ITApplicationManager sharedManager] tempFilePath:name]
                                            : [[ITApplicationManager sharedManager] documentsFilePath:name];
                                       [data writeToFile:tempPath.path atomically:YES];
                                       block(tempPath.path);
                                   }
                                   else
                                   {
                                       block(nil);
                                   }
                               });
                           }];
    
}

@end
