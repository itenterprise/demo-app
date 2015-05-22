//
//  ITEdsRepository.m
//  CaseManagement
//
//  Created by Admin on 13.05.15.
//  Copyright (c) 2015 Information Technologies Ltd. All rights reserved.
//

#import "ITEdsRepository.h"
#import "KeychainItemWrapper.h"
#import "ITApplicationManager.h"


@implementation ITEdsRepository

- (NSArray *) findPrivateKeysInDocuments
{
    NSMutableArray* privateKeys = [[NSMutableArray alloc] init];
    NSString * documents = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSArray* documentsContent = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:documents error:nil];
    for (NSString* doc in documentsContent)
    {
        if ([doc hasSuffix:@".dat"])
        {
            [privateKeys addObject:doc];
        }
    }
    return privateKeys;
}

- (NSString *) getCurrentPrivateKey
{
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    return [defaults objectForKey:@"EdsPrivateKeyName"];
}

- (void) setCurrentPrivateKey: (NSString *)privateKey
{
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:privateKey forKey:@"EdsPrivateKeyName"];
}

- (void) savePassword:(NSString *)password forKey:(NSString *)key
{
    KeychainItemWrapper * ki = [[KeychainItemWrapper alloc] initWithIdentifier:[self getKeychainIdentifier] accessGroup:nil];
    NSString * jsonOldCredentials = [ki objectForKey:(__bridge id)kSecValueData];
    NSMutableDictionary *credentials = (jsonOldCredentials == nil || [jsonOldCredentials isEqualToString:@""])
                                        ? [NSMutableDictionary new]
                                        : [NSJSONSerialization JSONObjectWithData:[jsonOldCredentials dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:nil];
    [credentials setObject:password forKey:key];
    NSString * jsonCredentials = [[NSString alloc] initWithData:[NSJSONSerialization dataWithJSONObject:credentials options: 0 error: nil] encoding:NSUTF8StringEncoding];
    //[ki setObject:jsonCredentials forKey:(__bridge id)kSecAttrAccount];
    [ki setObject:jsonCredentials forKey:(__bridge id)kSecValueData];
}

- (NSString *) getPasswordForKey:(NSString *)key
{
    KeychainItemWrapper * ki = [[KeychainItemWrapper alloc] initWithIdentifier:[self getKeychainIdentifier] accessGroup:nil];
    NSString *jsonCredentials = [ki objectForKey:(__bridge id)kSecValueData];
    if (jsonCredentials == nil || [jsonCredentials isEqualToString:@""])
    {
        return nil;
    }
    id credentials = [NSJSONSerialization JSONObjectWithData:[jsonCredentials dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:nil];
    return [credentials objectForKey:key];
}

- (void) clearCredentials
{
    KeychainItemWrapper * ki = [[KeychainItemWrapper alloc] initWithIdentifier:[self getKeychainIdentifier] accessGroup:nil];
    [ki resetKeychainItem];
}

- (NSString *) getKeychainIdentifier
{
    return [NSString stringWithFormat:@"%@Eds",[[ITApplicationManager sharedManager] applicationIdentifier]];
}

@end
