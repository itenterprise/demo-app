//
//  ITEmployeeDetailsViewController.h
//  Demo
//
//  Created by Admin on 12.02.15.
//  Copyright (c) 2015 Information Technologies Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SlideNavigationController.h"
#import "ITEmployee.h"
#import "ITUpdatableViewControllerDelegate.h"

@interface ITEmployeeDetailsViewController : UIViewController <SlideNavigationControllerDelegate, ITUpdatableViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, weak) ITEmployee * employeeItem;

@end
