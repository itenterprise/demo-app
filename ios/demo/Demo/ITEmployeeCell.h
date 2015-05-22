//
//  ITEmployeeCell.h
//  Demo
//
//  Created by Admin on 10.02.15.
//  Copyright (c) 2015 Information Technologies Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ITEmployee.h"
#import "UserInfo.h"

@interface ITEmployeeCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *userPhoto;
@property (weak, nonatomic) IBOutlet UIView *onlineStatusView;
@property (weak, nonatomic) IBOutlet UILabel *fioLabel;
@property (weak, nonatomic) IBOutlet UILabel *departmentLabel;

@property (weak, nonatomic) UserInfo * userInfo;
@property (nonatomic, unsafe_unretained) BOOL showFullInfo;

- (void)setEmployeeItem: (ITEmployee *)employee;
- (void) setUserImage: (UIImage *)image;

@end
