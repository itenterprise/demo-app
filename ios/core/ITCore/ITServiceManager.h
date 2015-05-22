//
//  ITService.h
//  Desktop
//
//  Created by Администратор on 2/7/14.
//  Copyright (c) 2014 Information Technologies Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIImage.h>
#import "ITLoginInfoSource.h"
#import "ITServiceManagerDelegate.h"
#import "ITInitRequest.h"
#import "ITInitResponse.h"

typedef void(^ServiceCallback)(id);

@interface ITServiceManager : NSObject

@property(nonatomic, strong) NSString * ticket;
@property(nonatomic, unsafe_unretained) BOOL skipNextError;
- (void) loginWithLogin: (NSString*)login password: (NSString*) password callback:(ServiceCallback) callback;
- (void) executeMethod: (NSString*) method args: (NSDictionary*) args callback:(ServiceCallback) callback;
- (void) executeMethod: (NSString*) method args:(NSDictionary *)args isAnonymous:(BOOL)isAnonymous callback:(ServiceCallback)callback;
- (void) changePassword:(NSString *)oldPassword toPassword:(NSString *)newPassword forUser:(NSString *)user withBlock: (void(^)(id ret)) block;
- (NSDictionary *) executeMethodSync: (NSString*) method args: (NSDictionary*) args;
- (void) logout;
- (void) sendImage: (UIImage *)image withBlock: (void(^)(NSString*))block;
- (void) getTempFile: (NSString *) name withBlock: (void(^)(NSString *))block;
- (void) getFile: (NSString *) name withBlock: (void(^)(NSString *))block;
- (ITInitResponse *) startApplicationWithRequest:(ITInitRequest *)request;

@property (nonatomic, weak) id<ITLoginInfoSource> loginSource;
@property (nonatomic, weak) id<ITServiceManagerDelegate> serviceDelegate;

+ (ITServiceManager*)sharedManagerWithUrl:(NSString*)url;


@end