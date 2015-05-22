//
//  ITLoginControllerDelegate.h
//  ITCore
//
//  Created by Администратор on 7/10/14.
//  Copyright (c) 2014 Information Technologies Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ITLoginControllerDelegate <NSObject>

@required
- (void) loginControllerDidLoginSuccessfully;

@end
