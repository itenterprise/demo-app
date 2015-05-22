//
//  ITUrlUrils.m
//  ITCore
//
//  Created by Администратор on 8/14/14.
//  Copyright (c) 2014 Information Technologies Ltd. All rights reserved.
//

#import "ITURLUtils.h"

@implementation ITURLUtils

+ (ITURLUtils *)sharedInstance
{
    static ITURLUtils * instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [ITURLUtils new];
    });
    return instance;
}

- (NSDictionary *)URLQueryParameters:(NSURL*)url
{
    NSArray * parameters = [[url query] componentsSeparatedByString:@"&"];
    NSMutableDictionary * queryParameters = [NSMutableDictionary new];
    for (NSString * param in parameters) {
        NSArray * elts = [param componentsSeparatedByString:@"="];
        if ([elts count] < 2)
        {
            continue;
        }
        [queryParameters setObject:elts[1] forKey:[elts[0] uppercaseString]];
    }
    return queryParameters;
}

@end
