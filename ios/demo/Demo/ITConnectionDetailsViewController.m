//
//  ITConnectionDetailsViewController.m
//  Demo
//
//  Created by Admin on 12.02.15.
//  Copyright (c) 2015 Information Technologies Ltd. All rights reserved.
//

#import "ITConnectionDetailsViewController.h"
#import "ITDateFormatter.h"
#import "ITColorParser.h"
#import "ITDemoManager.h"
#import "DejalActivityView.h"
#import "ITUpdatableViewControllerDelegate.h"
#import "ITConnectionDetails.h"
#import <QuartzCore/QuartzCore.h>

@interface ITConnectionDetailsViewController ()

@property (strong, nonatomic) ITConnectionDetails * connectionDetails;

@end

@implementation ITConnectionDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setConnectionItem:(ITConnection *)connectionItem
{
    _connectionItem = connectionItem;
    [self loadDetails];
}

- (void)loadDetails
{
    __weak ITConnectionDetailsViewController * theSelf = self;
    [DejalBezelActivityView activityViewForView:self.view withLabel:NSLocalizedString(@"Загрузка подключения", nil)];
    [[ITDemoManager sharedManager] getDetailsForConnection:self.connectionItem withBlock:^(ITConnectionDetails * details) {
        [DejalBezelActivityView removeView];
        theSelf.connectionDetails = details;
        [theSelf updateUI];
    }];
}

- (void) updateUI
{
    if ((self.connectionDetails.fio && self.connectionDetails.status && self.connectionDetails.functionName) ||
        ![self.connectionDetails.fio isEqualToString: self.connectionItem.fio ])
    {
        // Установить текстовые значения
        self.functionLabel.text = self.connectionDetails.functionName;
        self.statusLabel.text = self.connectionDetails.status;
        self.dateLabel.text = [[ITDateFormatter sharedInstance] format:self.connectionDetails.dateTransfer];
        self.fioLabel.text = self.connectionDetails.fio;
        self.loginItLabel.text = self.connectionDetails.itLogin;
        self.loginWindowsLabel.text = self.connectionDetails.winLogin;
        self.loginSqlLabel.text = self.connectionDetails.sqlLogin;
        self.hostNameLabel.text = self.connectionDetails.host;
        self.dbNameLabel.text = self.connectionDetails.dataBase;
        self.serverNameLabel.text = self.connectionDetails.server;
        self.applicationNameLabel.text = self.connectionDetails.application;
        // Задать цвет статуса
        self.statusCircleView.layer.cornerRadius = 5;
        self.statusCircleView.backgroundColor = [ITColorParser colorWithHexString:self.connectionDetails.statusColor];
    
        // Обновить функцию, статус и дату последней передачи данных
        self.connectionItem.functionName = self.connectionDetails.functionName;
        self.connectionItem.status = self.connectionDetails.status;
        self.connectionItem.statusColor = self.connectionDetails.statusColor;
        self.connectionItem.dateTransfer = self.connectionDetails.dateTransfer;
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Нет информации о подключении"
                                                        message:@"Необходимо обновить список подключений."
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if ([self.masterController conformsToProtocol:@protocol(ITUpdatableViewControllerDelegate)])
    {
        [(id<ITUpdatableViewControllerDelegate>)self.masterController reloadData];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

@end
