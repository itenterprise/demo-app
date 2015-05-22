//
//  UILabel+calcSize.m
//  CaseManagement
//
//  Created by Администратор on 5/21/14.
//  Copyright (c) 2014 Information Technologies Ltd. All rights reserved.
//

#import "UILabel+calcSize.h"

@implementation UILabel (calcSize)

- (CGSize)calcSize:(CGSize)maxSize
{
    NSDictionary * stringAttributes = [NSDictionary dictionaryWithObject:self.font forKey:NSFontAttributeName];
    CGSize expectedLabelSize = [self.text boundingRectWithSize:maxSize options: (NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingTruncatesLastVisibleLine) attributes:stringAttributes context:nil].size;
    return expectedLabelSize;
}

@end
