//
//  ITNotificationHandler.m
//  CaseManagement
//
//  Created by Администратор on 7/4/14.
//  Copyright (c) 2014 Information Technologies Ltd. All rights reserved.
//

#import "ITNotificationHandler.h"
#import "ITCaseManagementManager.h"
#import "ITDetailViewController.h"
#import "ITDocumentDetailsViewController.h"
#import "ITDetailViewController.h"
#import "ITDocumentDetailsViewController.h"
#import "DejalActivityView.h"
#import "ITLoginViewController.h"

@interface ITNotificationHandler()

@property (weak, nonatomic) ITAppDelegate * delegate;

@end

@implementation ITNotificationHandler

- (void) handleWithAppDelegate: (ITAppDelegate *)delegate usingAlert:(BOOL)withAlert
{
    self.delegate = delegate;
    if (withAlert)
    {
        NSString * message = self.notificationParameters[@"aps"][@"alert"];
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"" message:message delegate:self cancelButtonTitle:@"Закрыть" otherButtonTitles: NSLocalizedString(@"Показать", nil), nil];
        [alert show];
    }
    else
    {
        [self navigateWithCredentialsCheck];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex != 1)
    {
        return;
    }
    [self navigateWithCredentialsCheck];
}

- (void) navigateWithCredentialsCheck
{
    if (![ITCaseManagementManager.sharedManager isLoggedIn])
    {
        UINavigationController * navController = (UINavigationController *)self.delegate.window.rootViewController;
        // Преобразовать дополнительный параметры из json в словарь
        [DejalBezelActivityView activityViewForView:((UIViewController *)navController.viewControllers[navController.viewControllers.count - 1]).view withLabel: NSLocalizedString(@"Вход", nil)];
        [ITCaseManagementManager.sharedManager tryLoginFromKeychain:^(BOOL success) {
            [DejalBezelActivityView removeView];
            if (!success)
            {
                ITLoginViewController * loginController = [ITLoginViewController new];
                loginController.delegate = self;
                [navController presentViewController:loginController animated:YES completion:nil];
            }
            else
            {
                [self navigateToObject];
            }
        }];
    }
}

- (void)loginControllerDidLoginSuccessfully
{
    [self navigateToObject];
}

- (void) navigateToObject
{
    
    // Кликнули "показать"
    // Корневой контроллер - SlideNavigationController, он же контроллер навигации
    UINavigationController * navController = (UINavigationController *)self.delegate.window.rootViewController;
    // Преобразовать дополнительный параметры из json в словарь
    NSDictionary * objectParams = [[ITCaseManagementManager sharedManager] handlePushNotification: self.notificationParameters[@"additional"]];
    [DejalBezelActivityView activityViewForView:((UIViewController *)navController.viewControllers[navController.viewControllers.count - 1]).view withLabel: NSLocalizedString(@"Загрузка", nil)];
    // Уведомление о задаче
    if (objectParams[@"TASKID"] != nil)
    {
        [[ITCaseManagementManager sharedManager] getTask:[objectParams[@"TASKID"] intValue] withBlock:^(ITTask * task){
            [DejalBezelActivityView removeView];
            // Создать контроллер
            ITDetailViewController * taskController = [[ITCaseManagementManager sharedManager].storyboard instantiateViewControllerWithIdentifier:@"ITDetailViewController"];
            [taskController setDetails:task];
            // Показать контроллер
            [self navigateToViewController:taskController];
        }];
    }
    else
    {
        [[ITCaseManagementManager sharedManager] getDocumentWithArso:objectParams[@"ARSO"] keyValue:objectParams[@"KEYVALUE"] kidCopy:objectParams[@"KIDCOPY"] withBlock:^(ITDocument * document) {
            [DejalBezelActivityView removeView];
            // Создать контроллер для отображения документа
            ITDocumentDetailsViewController * documentController = [[ITCaseManagementManager sharedManager].storyboard instantiateViewControllerWithIdentifier:@"ITDocumentDetailsViewController"];
            [documentController setDocument:document];
            // Показать контроллер
            [self navigateToViewController:documentController];
        }];
    }
}

- (void) navigateToViewController: (UIViewController *)controller
{
    UINavigationController * navController = (UINavigationController *)self.delegate.window.rootViewController;
    // Если есть модальное окно - убрать его и показать необходимый контроллер
    if (self.delegate.window.rootViewController.presentedViewController)
    {
        [self.delegate.window.rootViewController dismissViewControllerAnimated:YES completion:^{
            [navController pushViewController:controller animated:YES];
        }];
    }
    else
    {
        // Иначе - просто показать контроллер
        [navController pushViewController:controller animated:YES];
    }
}

@end
