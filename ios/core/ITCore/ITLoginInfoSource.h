//
//  LoginInfoSource.h
//  Desktop
//
//  Created by Администратор on 2/24/14.
//  Copyright (c) 2014 Information Technologies Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ITLoginInfoSource <NSObject>

@required
- (NSDictionary *) loginInfo;
- (void)loginWithName: (NSString *)name password:(NSString*) password remember: (BOOL)remember callback:(void(^)(BOOL success)) callback;
@end
