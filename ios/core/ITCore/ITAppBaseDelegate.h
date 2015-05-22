//
//  ITAppBaseDelegate.h
//  ITCore
//
//  Created by Admin on 20.03.15.
//  Copyright (c) 2015 Information Technologies Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ITAppBaseDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

- (void) setDefaultUrl: (NSString *)url;

@end