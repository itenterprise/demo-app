//
//  CrashReport.m
//  ITCore
//
//  Created by Admin on 19.03.15.
//  Copyright (c) 2015 Information Technologies Ltd. All rights reserved.
//

#import "CrashReport.h"
#import "ITApplicationManager.h"
#import "KeychainItemWrapper.h"
#import <sys/utsname.h>
#import "ALDisk.h"
#import "ITDateParser.h"

@implementation CrashReport

+ (NSDictionary*)createReport:(NSException*)exception
{
    struct utsname systemInfo;
    uname(&systemInfo);
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    
    NSDictionary *reportParams = [[NSDictionary alloc] initWithObjectsAndKeys:
                                   [NSNumber numberWithInteger:[exception hash]], @"REPORT_ID",
                                   [self getUserLogin], @"USER_LOGIN",
                                   [NSNumber numberWithInteger:0], @"APP_VERSION_CODE",
                                   [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"], @"APP_VERSION_NAME",
                                   [[NSBundle mainBundle] bundleIdentifier], @"PACKAGE_NAME",
                                   @"iOS", @"OPERATION_SYSTEM",
                                   [[UIDevice currentDevice] systemVersion], @"OPERATION_SYSTEM_VERSION",
                                   [[UIDevice currentDevice] model], @"DEVICE_BRAND",
                                   [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding], @"DEVICE_MODEL",
                                   @"", @"FILE_PATH",
                                   @"", @"SYSTEM_BUILD",
                                   [NSString stringWithFormat:@"%.f", [ALDisk totalDiskSpaceInBytes]], @"TOTAL_MEMORY",
                                   [NSString stringWithFormat:@"%.f", [ALDisk freeDiskSpaceInBytes]], @"AVAILABLE_MEMORY",
                                   [NSString stringWithFormat:@"%@\r%@\r%@", exception.name, exception.reason, [exception callStackSymbols]], @"STACK_TRACE",
                                   @"", @"INITIAL_CONFIGURATION",
                                   @"", @"CRASH_CONFIGURATION",
                                   [NSString stringWithFormat:@"orientation: %@\r width: %.f\r height: %.f", [self getOrientation], screenRect.size.width, screenRect.size.height], @"DISPLAY_CONFIGURATION",
                                   [ITDateParser dateToJson:[NSDate date]], @"APPLICATION_START_DATE",
                                   [ITDateParser dateToJson:[NSDate date]], @"APPLICATION_CRASH_DATE",
                                   @"", @"DEVICE_FEATURES",
                                   @"", @"ENVIRONMENT",
                                   @"", @"SECURE_SETTINGS",
                                   @"", @"GLOBAL_SETTINGS",
                                   [NSString stringWithFormat:@"%@", [[NSUserDefaults standardUserDefaults] dictionaryRepresentation]], @"APPLICATION_PREFERENCES", nil];
    return reportParams;
}

+ (void)saveReportToFile:(NSDictionary*)report
{
    [report writeToFile:[self getFilePath: [NSString stringWithFormat:@"%@.crrep", [report valueForKey:@"REPORT_ID"]]] atomically:YES];
}

+ (NSDictionary *)getReportFromFile:(NSString*)fileName
{
    return [NSDictionary dictionaryWithContentsOfFile:[self getFilePath:fileName]];
}

//+ (NSArray *)checkForReports
//{
//    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//    NSString *documentsDirectory = [paths objectAtIndex:0];
//    
//    NSMutableArray *reports = [[NSMutableArray alloc]init];
//    NSFileManager *manager = [NSFileManager defaultManager];
//    
//    NSString *item;
//    NSArray *contents = [manager contentsOfDirectoryAtPath:documentsDirectory error:nil];
//    for (item in contents)
//    {
//        if ([[item pathExtension]isEqualToString:@"crrep"])
//        {
//            [[ITApplicationManager sharedManager] sendCrashReport:<#(NSException *)#>]
//            [reports addObject:item];
//        }
//    }
//    return reports;
//}

+ (NSString *)getFilePath:(NSString*)fileName
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    return [documentsDirectory stringByAppendingPathComponent:fileName];
}

//public String DEVICE_FEATURES = errorContent.getProperty(ReportField.DEVICE_FEATURES);
//public String ENVIRONMENT = errorContent.getProperty(ReportField.ENVIRONMENT);
//public String SECURE_SETTINGS = errorContent.getProperty(ReportField.SETTINGS_SECURE);
//public String GLOBAL_SETTINGS = errorContent.getProperty(ReportField.SETTINGS_GLOBAL);
//public String APPLICATION_PREFERENCES = errorContent.getProperty(ReportField.SHARED_PREFERENCES);

+ (NSString*)getUserLogin
{
    NSString *userLogin = @"";
    NSString *appIdentifier = [[ITApplicationManager sharedManager] applicationIdentifier];
    if ([appIdentifier length])
    {
        KeychainItemWrapper * ki = [[KeychainItemWrapper alloc] initWithIdentifier:appIdentifier accessGroup:nil];
        userLogin = [ki objectForKey:(__bridge id)kSecAttrAccount];
    }
    return userLogin;
}

+ (NSString*)getOrientation
{
    NSString *orientation;
    switch ([UIApplication sharedApplication].statusBarOrientation) {
        case 0:
            orientation = @"default";
            break;
        case UIInterfaceOrientationPortrait:
            orientation = @"portrait";
            break;
        case UIInterfaceOrientationLandscapeLeft:
            orientation = @"landscapeLeft";
            break;
        case UIInterfaceOrientationLandscapeRight:
            orientation = @"landscapeRight";
            break;
        default:
            orientation = @"";
            break;
    }
    return orientation;
}

@end