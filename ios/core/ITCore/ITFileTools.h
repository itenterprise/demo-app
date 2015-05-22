//
//  ITFileTools.h
//  ITCore
//
//  Created by Admin on 17.10.14.
//  Copyright (c) 2014 Information Technologies Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ITFileTools : NSObject

+ (ITFileTools *)sharedInstance;

- (void)moveFileFrom: (NSString *)source to: (NSString *)desc;

@end
