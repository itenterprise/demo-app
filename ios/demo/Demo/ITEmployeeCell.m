//
//  ITEmployeeCell.m
//  Demo
//
//  Created by Admin on 10.02.15.
//  Copyright (c) 2015 Information Technologies Ltd. All rights reserved.
//

#import "ITEmployeeCell.h"
#import "UILabel+calcSize.h"
#import "UIView+ViewExtension.h"
#import "ITDemoManager.h"
#import <QuartzCore/QuartzCore.h>

@interface  ITEmployeeCell()

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *departmentHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *spaceFioDepartment;

@property (nonatomic, weak) ITEmployee * employeeItem;

@end

@implementation ITEmployeeCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
    [self setOnline];
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated;
{
    [super setHighlighted:highlighted animated: animated];
    [self setOnline];
}

- (void)didMoveToSuperview
{
    [super didMoveToSuperview];
}

- (void)setEmployeeItem:(ITEmployee *)employeeItem
{
    _employeeItem = employeeItem;
    [self updateUI];
}

- (void) updateUI
{
    // Установить текстовые значения
    self.fioLabel.text = self.employeeItem.fio;// stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]].length ? self.employeeItem.fio : @"<пусто>";
    self.departmentLabel.text = self.employeeItem.department;
    [self setOnline];
    [self.userPhoto.layer setMasksToBounds:YES];
    [self.userPhoto.layer setCornerRadius:20];
}

- (void) setOnline
{
    if (self.employeeItem.isOnline)
    {
        self.onlineStatusView.layer.cornerRadius = 5;
        self.onlineStatusView.backgroundColor = [UIColor colorWithRed:34/255.0 green:73/255.0 blue:140/255.0 alpha:1];
    }
    else
    {
        self.onlineStatusView.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0];
    }
}

- (void)setUserInfo:(UserInfo *)userInfo
{
    _userInfo = userInfo;
    [self setUserImage:userInfo.imageContents];
}

- (void) setUserImage: (UIImage *)image
{
    if (image != nil)
    {
        self.userPhoto.image = image;
    }
    else
    {
        self.userPhoto.image = [[ITDemoManager sharedManager] defaultUserImage];
    }
}

@end