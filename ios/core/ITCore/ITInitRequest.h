//
//  ITVersion.h
//  ITCore
//
//  Created by Администратор on 7/30/14.
//  Copyright (c) 2014 Information Technologies Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ITInitRequest: NSObject

@property (nonatomic, copy) NSString * project;
@property (nonatomic, copy) NSString * module;
@property (nonatomic, copy) NSString * appId;
@property (nonatomic, copy) NSString * version;

- (NSDictionary *)dictionaryRepresentation;

@end
