//
//  UIView+ViewExtension.m
//  Demo
//
//  Created by Администратор on 5/21/14.
//  Copyright (c) 2014 Information Technologies Ltd. All rights reserved.
//

#import "UIView+ViewExtension.h"

@implementation UIView (ViewExtension)

- (NSUInteger) availableInnerWidth
{
    NSInteger frameWidth = CGRectGetWidth(self.frame);
    const NSInteger elementPadding = 40;
    NSInteger availableWidth = frameWidth - elementPadding;
    return availableWidth;
}

- (UIViewController *) parentViewController
{
    Class controllerClass = [UIViewController class];
    UIResponder * responder = self;
    while((responder = [responder nextResponder]))
    {
        if ([responder isKindOfClass:controllerClass])
        {
            return (UIViewController *)responder;
        }
    }
    return nil;
}

+ (CGSize) currentScreenSize
{
    CGRect screenBounds = [UIScreen mainScreen].bounds;
    CGFloat width = CGRectGetWidth(screenBounds);
    CGFloat height = CGRectGetHeight(screenBounds);
    UIInterfaceOrientation interfaceOrientation = [UIApplication sharedApplication].statusBarOrientation;
    CGSize size = screenBounds.size;
    if (NSFoundationVersionNumber <= NSFoundationVersionNumber_iOS_7_1 && UIInterfaceOrientationIsLandscape(interfaceOrientation))
    {
        size = CGSizeMake(height, width);
    }
    else if (UIInterfaceOrientationIsPortrait(interfaceOrientation))
    {
        size = CGSizeMake(width, height);
    }
    return size;
}

@end
