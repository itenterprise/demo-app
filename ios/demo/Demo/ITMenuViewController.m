//
//  ITMenuViewController.m
//  CaseManagement
//
//  Created by Администратор on 5/16/14.
//  Copyright (c) 2014 Information Technologies Ltd. All rights reserved.
//

#import "ITMenuViewController.h"
#import "ITEmployeeViewController.h"
#import "ITConnectionViewController.h"
#import "SlideNavigationController.h"
#import "ITDemoManager.h"
#import "ITLoginViewController.h"
#import "ITChangePasswordViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface ITMenuViewController ()

@end

@implementation ITMenuViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView.tableFooterView = [UIView new];
    self.tableView.backgroundColor = [UIColor colorWithRed:51.0/255 green:51.0/255 blue:51.0/255 alpha:255];
    [self.fotoView.layer setMasksToBounds:YES];
    [self.fotoView.layer setCornerRadius:5];
//    for (UIImageView * image in self.images)
//    {
//        UIImage * checkedImage = [[UIImage imageNamed:@"Ok"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
//        image.image = checkedImage;
//        image.tintColor = [UIColor whiteColor];
//        image.hidden = YES;
//    }
//    self.myActiveImage.hidden = NO;
//    
    for (UITableViewCell * cell in self.cells) {
        cell.backgroundColor = [UIColor darkGrayColor];
    }
    [[ITDemoManager sharedManager] updateAccountInfo];
    // Do any additional setup after loading the view.
}

// Выбор пункта меню
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Уменьшить индекс на 1 из-за пустого пункта меню сверху
    int index = (int)indexPath.row - 2;
    if (index < 0)
    {
        return;
    }
    UIViewController * controller = nil;
    // Выбрали фильтр по сотрудникам
    if (index == 0)
    {
        controller = [self createEmployeeController];
    }
    // Выбрали фильтр по подключениям
    else if (index == 1)
    {
        controller = [self createConnectionController];
    }
    // Выполнить переход к сотрудникам или подключениям
    if (controller)
    {
        [[SlideNavigationController sharedInstance] popAllAndSwitchToViewController:controller withCompletion:nil];
    }
    if (index == 2)
    {
        ITChangePasswordViewController * changePasswordController = [ITChangePasswordViewController new];
        UINavigationController * controller = (UINavigationController*)[SlideNavigationController sharedInstance];
        [controller presentViewController:changePasswordController animated:NO completion:nil];
    }
    // Выбрали выход
    if (index == 3)
    {
        [[ITDemoManager sharedManager] logout];
        ITLoginViewController * loginController = [ITLoginViewController new];
        UINavigationController * controller = (UINavigationController*)[SlideNavigationController sharedInstance];
        if ([controller.visibleViewController conformsToProtocol:@protocol(ITLoginControllerDelegate) ])
        {
            loginController.delegate = (id<ITLoginControllerDelegate>)controller.visibleViewController;
        }
        [controller presentViewController:loginController animated:NO completion:nil];
    }
    //[self showSelectedImage: index];
}

//// Показать выбор пункта меню
//- (void)showSelectedImage:(NSInteger)index
//{
//    for (UIImageView * image in self.images)
//    {
//        image.hidden = YES;
//    }
//    UIImageView * selectedImage;
//    switch (index)
//    {
//        case 0:
//        case 1:
//            selectedImage = self.myActiveImage;
//            break;
//        case 2:
//            selectedImage = self.myCompleteImage;
//            break;
//        case 3:
//            selectedImage = self.myCancelImage;
//            break;
//        case 4:
//            selectedImage = self.controlActiveImage;
//            break;
//        case 5:
//            selectedImage = self.controlCompleteImage;
//            break;
//        case 6:
//            selectedImage = self.controlCancelImage;
//            break;
//        case 7:
//        case 8:
//            selectedImage = self.inDocumentsImage;
//            break;
//        case 9:
//            selectedImage = self.sendDocuments;
//            break;
//        case 10:
//            selectedImage = self.archiveImage;
//            break;
//        default:
//            break;
//    }
//    if (selectedImage)
//    {
//        selectedImage.hidden = NO;
//    }
//}


// Создать контроллер сотрудников
- (ITEmployeeViewController *)createEmployeeController
{
    ITEmployeeViewController * controller = (ITEmployeeViewController*)[[ITDemoManager sharedManager].storyboard instantiateViewControllerWithIdentifier: @"ITEmployeeViewController"];
    return controller;
}

// Создать контроллер подключений
-(ITConnectionViewController *) createConnectionController
{
    ITConnectionViewController * controller = (ITConnectionViewController *)[[ITDemoManager sharedManager].storyboard instantiateViewControllerWithIdentifier: @"ITConnectionViewController"];
    return controller;
}

//// Перетворить индекс пункта меню в статус задачи
//- (NSString *)getTaskStatusFromIndex:(NSInteger) index
//{
//    index--;
//    if (index == -1 || index % 3 == 0)
//    {
//        return @"";
//    }
//    if (index % 3 == 1)
//    {
//        return @"+";
//    }
//    return @"-";
//}
//
//// Перевторить индекс пункта меню в статус документа
//- (NSString *)getDocumentStatusFromIndex: (NSInteger) index
//{
//    index -= 7;
//    switch (index) {
//        case 0:
//        case 1:
//            return @"";
//        case 2:
//            return @"*";
//        default:
//            return @"+";
//    }
//}
//
//// Получить признак контроля
//- (BOOL) getTaskControlFromRowIndex: (NSInteger) index
//{
//    index--;
//    return index > 2;
//}

@end
