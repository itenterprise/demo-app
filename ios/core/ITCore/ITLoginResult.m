//
//  ITLoginResult.m
//  Desktop
//
//  Created by Администратор on 2/7/14.
//  Copyright (c) 2014 Information Technologies Ltd. All rights reserved.
//

#import "ITLoginResult.h"

@implementation ITLoginResult

- (instancetype) initWithName: (NSString*)name ticket:(NSString*) ticket success:(BOOL)success
{
    self = [super init];
    if (self != nil)
    {
        self.userName = name;
        self.ticket = ticket;
        self.success = success;
    }
    return self;
}

- (instancetype) initWithDictionary:(NSDictionary*)dict
{
    self = [super init];
    if (self != nil)
    {
        self.userName = dict[@"UserName"];
        self.ticket = dict[@"Ticket"];
        self.success = [dict[@"Success"] boolValue];
    }
    return self;
}

@end
