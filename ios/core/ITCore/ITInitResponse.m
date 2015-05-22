//
//  ITInitResponse.m
//  ITCore
//
//  Created by Администратор on 8/18/14.
//  Copyright (c) 2014 Information Technologies Ltd. All rights reserved.
//

#import "ITInitResponse.h"

@implementation ITInitResponse

- (instancetype)initWithDictionary:(NSDictionary *)dict
{
    self = [super init];
    if (self)
    {
        self.responseStatus = [dict[@"STATUS"] integerValue];
        self.additionalProperties = dict[@"ADDITIONAL"];
    }
    return self;
}

@end
