//
//  ITEmployeeDetailsCellTableViewCell.m
//  Demo
//
//  Created by Admin on 12.02.15.
//  Copyright (c) 2015 Information Technologies Ltd. All rights reserved.
//

#import "ITEmployeeDetailsCell.h"
#import "ITDemoManager.h"

@interface  ITEmployeeDetailsCell()

@property (nonatomic, weak) ITEmployee * employeeItem;
@property (nonatomic, weak) UserInfo * userInfo;

@end

@implementation ITEmployeeDetailsCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setEmployeeItem:(ITEmployee *)employeeItem
{
    _employeeItem = employeeItem;
    [self updateUI];
}

- (void) updateUI
{
    // Установить текстовые значения
    self.fioLabel.text = self.employeeItem.fio;
    self.onlineLabel.text = self.employeeItem.isOnline ? @"Онлайн" : @"";
    self.departmentLabel.text = self.employeeItem.department;
    self.phoneTextView.text = self.employeeItem.phone;
    self.emailTextView.text = self.employeeItem.email;
    [self setUserImage: self.employeeItem.photo];
}

- (void) setUserImage: (UIImage *)image
{
    if (image != nil)
    {
        self.photoImageView.image = image;
    }
    else
    {
        self.photoImageView.image = [[ITDemoManager sharedManager] defaultUserImage];
    }
}

@end