//
//  ITSectionHeaderCell.m
//  CaseManagement
//
//  Created by Администратор on 7/8/14.
//  Copyright (c) 2014 Information Technologies Ltd. All rights reserved.
//

#import "ITSectionHeaderCell.h"

@implementation ITSectionHeaderCell

- (void)setHeaderText:(NSString *)headerText
{
    self.header.title = headerText;
    _headerText = headerText;
}

- (void) addActionButton:(id)target action:(SEL)selector
{
    UIBarButtonItem * actionItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:target action:selector];
    NSMutableArray * items = [self.toolbar.items mutableCopy];
    [items addObject:actionItem];
    self.toolbar.items = items;
}

@end
