//
//  ITPhotoManager.h
//  CaseManagement
//
//  Created by Admin on 20.10.14.
//  Copyright (c) 2014 Information Technologies Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserInfo.h"

@interface ITPhotoManager : NSObject

- (void) loadPhotos: (NSArray *)photos forUsers: (NSArray *)users inContext: (NSManagedObjectContext *)context;

@end
