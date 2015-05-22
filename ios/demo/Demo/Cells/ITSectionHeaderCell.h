//
//  ITSectionHeaderCell.h
//  CaseManagement
//
//  Created by Администратор on 7/8/14.
//  Copyright (c) 2014 Information Technologies Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ITSectionHeaderCell : UIView

@property (weak, nonatomic) IBOutlet UIBarButtonItem *header;

@property (weak, nonatomic) IBOutlet UIToolbar *toolbar;
@property (strong, nonatomic) NSString * headerText;
- (void) addActionButton:(id)target action:(SEL)selector;

@end
