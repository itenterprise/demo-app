//
//  ITDiscussSource.h
//  CaseManagement
//
//  Created by Администратор on 6/26/14.
//  Copyright (c) 2014 Information Technologies Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    kObjectTypeEmployee,
    kObjectTypeConnection,
} ITObjectType;

/*
 * Протокол для обозначения корневого объекта
 */
@protocol ITRootModelObject <NSObject>

@required
- (NSDictionary *) keys;
- (ITObjectType) type;
- (BOOL) detailsLoaded;
- (NSString *) name;
- (NSArray *) userIds;

@end
