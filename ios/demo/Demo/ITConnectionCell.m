//
//  ITConnectionCell.m
//  Demo
//
//  Created by Admin on 06.02.15.
//  Copyright (c) 2015 Information Technologies Ltd. All rights reserved.
//

#import "ITConnectionCell.h"
#import "ITDateFormatter.h"
#import "ITColorParser.h"
#import <QuartzCore/QuartzCore.h>

@interface  ITConnectionCell()

@property (nonatomic, weak) ITConnection * connectionItem;

@end

@implementation ITConnectionCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
    self.statusCircleView.backgroundColor = [ITColorParser colorWithHexString:self.connectionItem.statusColor];
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated;
{
    [super setHighlighted:highlighted animated: animated];
    self.statusCircleView.backgroundColor = [ITColorParser colorWithHexString:self.connectionItem.statusColor];
}

- (void)didMoveToSuperview
{
    [super didMoveToSuperview];
}

- (void)setConnectionItem:(ITConnection *)connectionItem
{
    _connectionItem = connectionItem;
    [self updateUI];
}

- (void) updateUI
{
    // Установить текстовые значения
    self.functionLabel.text = self.connectionItem.functionName;
    self.statusLabel.text = self.connectionItem.status;
    self.lastDateLabel.text = [[ITDateFormatter sharedInstance] format:self.connectionItem.dateTransfer];
    self.fioLabel.text = self.showFullInfo ? self.connectionItem.fio : @"";
    // Задать цвет статуса
    self.statusCircleView.layer.cornerRadius = 5;
    self.statusCircleView.backgroundColor = [ITColorParser colorWithHexString:self.connectionItem.statusColor];
}

@end
