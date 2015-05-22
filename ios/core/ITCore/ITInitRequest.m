//
//  ITVersion.m
//  ITCore
//
//  Created by Администратор on 7/30/14.
//  Copyright (c) 2014 Information Technologies Ltd. All rights reserved.
//

#import "ITInitRequest.h"
#import "ITApplicationManager.h"

@implementation ITInitRequest

- (NSString *)project
{
    return [[ITApplicationManager sharedManager] applicationProject];
}

- (NSString *)module
{
    return [[ITApplicationManager sharedManager] applicationModule];
}

- (NSString *)version
{
    if (_version == nil)
    {
        _version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
    }
    return _version;
}

- (NSDictionary *)dictionaryRepresentation
{
    return @{@"PROJECT": self.project, @"MODULE": self.module, @"VERSION": self.version, @"APPID": [[ITApplicationManager sharedManager] applicationIdentifier]};
}

@end
