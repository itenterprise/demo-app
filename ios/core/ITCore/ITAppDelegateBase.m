//
//  ITAppDelegateBase.m
//  ITCore
//
//  Created by Администратор on 7/30/14.
//  Copyright (c) 2014 Information Technologies Ltd. All rights reserved.
//

#import "ITAppDelegateBase.h"
#import "ITApplicationManager.h"
#import "ITVersion.h"

@implementation ITAppDelegateBase

- (void) checkVersionWithBlock:(void(^)(BOOL))callback
{
    [[ITApplicationManager sharedManager].serviceManager executeMethod:@"ITVERSION" args:nil callback:^(id result) {
        BOOL success = YES;
        if (result == nil){
            success = NO;
        }
        else {
            ITVersion * server = [[ITVersion alloc] initWithDictionary:result];
            ITVersion * mobile = [ITVersion mobileVersion];
            success = [ITVersion compareServerVersion:server withMobile:mobile];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            callback(success);
        });
        if (!success)
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Не совпадает версия мобильного клиента и сервера IT-Enterprise" delegate:self cancelButtonTitle:@"Выход" otherButtonTitles: nil];
                [alert show];
            });
        }
    }];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    exit(0);
}

@end
