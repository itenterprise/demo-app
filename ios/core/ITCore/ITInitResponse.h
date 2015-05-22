//
//  ITInitResponse.h
//  ITCore
//
//  Created by Администратор on 8/18/14.
//  Copyright (c) 2014 Information Technologies Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

enum
{
    kInitResponseStatusSuccess,
    kInitResponseStatusModuleError,
    kInitResponseStatusProjectError,
    kInitResponseStatusNewVersion
};

typedef NSInteger ITInitResponseStatus;

@interface ITInitResponse : NSObject

@property (nonatomic, unsafe_unretained) ITInitResponseStatus responseStatus;
@property (nonatomic, strong) NSDictionary * additionalProperties;

- (instancetype)initWithDictionary:(NSDictionary *)dict;

@end
