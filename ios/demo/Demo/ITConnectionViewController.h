//
//  ITConnectionViewController.h
//  Demo
//
//  Created by Admin on 12.02.15.
//  Copyright (c) 2015 Information Technologies Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SlideNavigationController.h"
#import "ITLoginControllerDelegate.h"
#import "ITUpdatableViewControllerDelegate.h"
#import "ITRootObjectsSource.h"

@interface ITConnectionViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, UISearchDisplayDelegate, ITUpdatableViewControllerDelegate, SlideNavigationControllerDelegate, ITLoginControllerDelegate, UIActionSheetDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end
