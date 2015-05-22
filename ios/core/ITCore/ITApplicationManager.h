//
//  ITTest.h
//  ITCoreSDK
//
//  Created by Администратор on 2/26/14.
//  Copyright (c) 2014 Information Technologies Ltd. All rights reserved.
//


#import <Foundation/Foundation.h>
#import "ITLoginInfoSource.h"
#import "ITServiceManagerDelegate.h"
#import "ITServiceManager.h"
#import <UIKit/UIKit.h>

@interface ITApplicationManager : NSObject <UIAlertViewDelegate, ITLoginInfoSource, ITServiceManagerDelegate>

@property(nonatomic, copy, readonly) NSString * currentUserName;
@property(nonatomic, copy, readonly) NSString * userId;
@property(nonatomic, strong) NSData * pushNotificationTocken;
@property(nonatomic, unsafe_unretained) BOOL iPad; 
@property(nonatomic, strong) ITServiceManager * serviceManager;
@property (nonatomic, strong) NSBundle * resourcesBundle;

- (NSString *) serviceUrl;
- (void)loginWithName: (NSString *)name password:(NSString*) password remember: (BOOL)remember callback:(void(^)(BOOL success)) callback;
- (void)logout;
- (void)tryLoginFromKeychain:(void(^)(BOOL))callback;
- (NSDictionary*)handlePushNotification: (NSString*)notificationBody;
- (BOOL) isLoggedIn;
- (NSString *)applicationIdentifier;
- (void)handleNoLicense;
- (void)handleNoAccess;
- (void)handleError;
- (BOOL)checkServiceUrl;
- (BOOL)requiresVPN;
- (NSURL *) tempFilePath:(NSString *)name;
- (NSURL *) documentsFilePath: (NSString *)name;
- (void) initApplicationWithBlock: (void(^)(BOOL)) block;
- (NSString *) applicationModule;
- (NSString *) applicationProject;
- (NSString *) itURLFromQRCode: (NSString *)qrCode;
- (BOOL) isIOS7;
- (BOOL) initApplication;
- (void) changePassword:(NSString *)oldPassword toPassword:(NSString *)newPassword withBlock: (void(^)(id ret)) block;
- (void)sendCrashReport: (NSException*) exception;
- (void)loadUserSettings;
- (BOOL) isUsingEds;

+ (ITApplicationManager *)sharedManager;
+ (void)setSharedManager:(ITApplicationManager *)manager;

@end
