//
//  Model.h
//  CaseManagement
//
//  Created by Admin on 24.10.14.
//  Copyright (c) 2014 Information Technologies Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface UserInfo : NSManagedObject

@property (nonatomic, retain) NSString * checksum;
@property (nonatomic, retain) NSString * email;
@property (nonatomic, retain) id imageContents;
@property (nonatomic, retain) NSString * phone;
@property (nonatomic, retain) NSString * userId;

@end
