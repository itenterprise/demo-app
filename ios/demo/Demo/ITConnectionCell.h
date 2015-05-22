//
//  ITConnectionCell.h
//  Demo
//
//  Created by Admin on 06.02.15.
//  Copyright (c) 2015 Information Technologies Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ITConnection.h"

@interface ITConnectionCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *functionLabel;
@property (weak, nonatomic) IBOutlet UIView *statusCircleView;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UILabel *lastDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *fioLabel;

@property (nonatomic, unsafe_unretained) BOOL showFullInfo;

- (void)setConnectionItem: (ITConnection *)connection;

@end
