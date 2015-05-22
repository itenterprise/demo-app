//
//  ITAppDelegateBase.h
//  ITCore
//
//  Created by Администратор on 7/30/14.
//  Copyright (c) 2014 Information Technologies Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ITAppDelegateBase : UIResponder <UIApplicationDelegate, UIAlertViewDelegate>

- (void) checkVersionWithBlock:(void(^)(BOOL))callback;

@end
