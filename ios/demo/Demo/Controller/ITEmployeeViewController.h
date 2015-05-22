//
//  ITEmployeeViewController.h
//  Demo
//
//  Created by Admin on 12.02.15.
//  Copyright (c) 2015 Information Technologies Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SlideNavigationController.h"
#import "ITLoginControllerDelegate.h"
#import "ITUpdatableViewControllerDelegate.h"
#import "UserInfo.h"

@interface ITEmployeeViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, UISearchDisplayDelegate, ITUpdatableViewControllerDelegate, SlideNavigationControllerDelegate, ITLoginControllerDelegate, UIActionSheetDelegate, NSFetchedResultsControllerDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

- (void)afterDataLoaded;
- (UserInfo *)userById: (NSString *)userId;

@end
