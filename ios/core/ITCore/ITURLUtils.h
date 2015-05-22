//
//  ITUrlUrils.h
//  ITCore
//
//  Created by Администратор on 8/14/14.
//  Copyright (c) 2014 Information Technologies Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ITURLUtils : NSObject

+ (ITURLUtils *)sharedInstance;

- (NSDictionary *)URLQueryParameters: (NSURL *)url;

@end
