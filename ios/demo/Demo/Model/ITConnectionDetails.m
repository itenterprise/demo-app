//
//  ITConnectionDetails.m
//  Demo
//
//  Created by Admin on 11.02.15.
//  Copyright (c) 2015 Information Technologies Ltd. All rights reserved.
//

#import "ITConnectionDetails.h"
#import "ITDateParser.h"

@implementation ITConnectionDetails

+ (ITConnectionDetails *)initWithDictionary:(NSDictionary*) dict
{
    ITConnectionDetails * details = [ITConnectionDetails new];
    details.spid = [dict[@"SPID"] integerValue];
    details.dateTransfer = [ITDateParser jsonDateToDate:dict[@"LASTDATE"]];
    details.status = dict[@"STATUS"];
    details.statusColor = dict[@"STATUSCOLOR"];
    details.fio = dict[@"FIO"];
    details.functionName = dict[@"FUNCTIONNAME"];
    details.userLogin = dict[@"USERLOGIN"];
    details.server = dict[@"SERVERNAME"];
    details.dataBase = dict[@"DBNAME"];
    details.sqlLogin = dict[@"LOGIN"];
    details.winLogin = dict[@"WINDOWSUSER"];
    details.itLogin = dict[@"USERID"];
    details.application = dict[@"PRGNAME"];
    details.host = dict[@"HOSTNAME"];
    return details;
}

@end