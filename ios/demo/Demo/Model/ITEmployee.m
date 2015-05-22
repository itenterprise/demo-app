//
//  ITEmployee.m
//  Demo
//
//  Created by Admin on 10.02.15.
//  Copyright (c) 2015 Information Technologies Ltd. All rights reserved.
//

#import "ITEmployee.h"

@implementation ITEmployee

+ (ITEmployee *)initWithDictionary: (NSDictionary*) dict
{
    ITEmployee * employee = [ITEmployee new];
    employee.login = dict[@"USERLOGIN"];
    employee.nkdk = dict[@"NKDK"];
    employee.phone = dict[@"PHONE"];
    employee.email = dict[@"EMAIL"];
    employee.fio = dict[@"FIO"];
    employee.department = dict[@"DEPARTMENT"];
    employee.photoName = dict[@"PHOTO"];
    employee.checksum = dict[@"HASH"];
    return employee;
}

+ (NSArray*)initWithArray:(NSArray*)array
{
    NSMutableArray * employees = [NSMutableArray new];
    for (NSDictionary * dict in array)
    {
        [employees addObject:[ITEmployee initWithDictionary:dict]];
    }
    return employees;
}

@end
