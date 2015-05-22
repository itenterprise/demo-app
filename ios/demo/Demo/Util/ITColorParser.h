//
//  ITColorParser.h
//  Demo
//
//  Created by Admin on 23.02.15.
//  Copyright (c) 2015 Information Technologies Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ITColorParser : NSObject

+ (UIColor *)colorWithHexString:(NSString*)hex;

@end
