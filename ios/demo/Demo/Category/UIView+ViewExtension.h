//
//  UIView+ViewExtension.h
//  Demo
//
//  Created by Администратор on 5/21/14.
//  Copyright (c) 2014 Information Technologies Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (ViewExtension)

- (NSUInteger) availableInnerWidth;
- (UIViewController *) parentViewController;
+ (CGSize) currentScreenSize;
@end
