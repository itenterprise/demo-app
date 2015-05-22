//
//  ITEdsRepository.h
//  CaseManagement
//
//  Created by Admin on 13.05.15.
//  Copyright (c) 2015 Information Technologies Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ITEdsRepository : NSObject

- (NSArray *) findPrivateKeysInDocuments;
- (NSString *) getCurrentPrivateKey;
- (void) setCurrentPrivateKey: (NSString *)privateKey;
- (void) savePassword:(NSString *)password forKey:(NSString *)key;
- (NSString *) getPasswordForKey:(NSString *)key;
- (void) clearCredentials;

@end
