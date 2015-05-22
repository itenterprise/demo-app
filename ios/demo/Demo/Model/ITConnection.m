//
//  ITConnection.m
//  Demo
//
//  Created by Admin on 11.02.15.
//  Copyright (c) 2015 Information Technologies Ltd. All rights reserved.
//

#import "ITConnection.h"
#import "ITDateParser.h"

@implementation ITConnection

+ (ITConnection *)initWithDictionary: (NSDictionary*) dict
{
    ITConnection * connection = [ITConnection new];
    connection.spid = [dict[@"SPID"] integerValue];
    connection.dateTransfer = [ITDateParser jsonDateToDate:dict[@"LASTDATE"]];
    connection.status = dict[@"STATUS"];
    connection.statusColor = dict[@"STATUSCOLOR"];
    connection.fio = dict[@"FIO"];
    connection.functionName = dict[@"FUNCTIONNAME"];
    connection.userLogin = dict[@"USERLOGIN"];
    return connection;
}

+ (NSArray*)initWithArray:(NSArray*)array
{
    NSMutableArray * connections = [NSMutableArray new];
    for (NSDictionary * dict in array)
    {
        [connections addObject:[ITConnection initWithDictionary:dict]];
    }
    return connections;
}

@end
