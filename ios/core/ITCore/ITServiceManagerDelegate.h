//
//  ITServiceManagerDelegate.h
//  Desktop
//
//  Created by Администратор on 2/24/14.
//  Copyright (c) 2014 Information Technologies Ltd. All rights reserved.
//


#import <Foundation/Foundation.h>

@protocol ITServiceManagerDelegate <NSObject>

@required
- (void)handleSessionTimeout;
- (void)handleConnectionLost;

@end