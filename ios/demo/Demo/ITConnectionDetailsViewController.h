//
//  ITConnectionDetailsViewController.h
//  Demo
//
//  Created by Admin on 12.02.15.
//  Copyright (c) 2015 Information Technologies Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SlideNavigationController.h"
#import "ITConnection.h"

@interface ITConnectionDetailsViewController : UIViewController <SlideNavigationControllerDelegate>
@property (weak, nonatomic) IBOutlet UILabel *functionLabel;
@property (weak, nonatomic) IBOutlet UIView *statusCircleView;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *fioLabel;
@property (weak, nonatomic) IBOutlet UILabel *loginItLabel;
@property (weak, nonatomic) IBOutlet UILabel *loginWindowsLabel;
@property (weak, nonatomic) IBOutlet UILabel *loginSqlLabel;
@property (weak, nonatomic) IBOutlet UILabel *hostNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *dbNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *serverNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *applicationNameLabel;

@property (nonatomic, weak) ITConnection * connectionItem;
@property (nonatomic, weak) UIViewController * masterController;

@end
