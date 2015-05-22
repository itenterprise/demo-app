//
//  ITLoginResult.h
//  Desktop
//
//  Created by Администратор on 2/7/14.
//  Copyright (c) 2014 Information Technologies Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ITLoginResult : NSObject

@property(nonatomic, strong) NSString * userName;
@property(nonatomic, strong) NSString * ticket;
@property(nonatomic, unsafe_unretained) BOOL success;

- (instancetype) initWithName: (NSString*)name ticket:(NSString*) ticket success:(BOOL)success;
- (instancetype) initWithDictionary:(NSDictionary*)dict;

@end
